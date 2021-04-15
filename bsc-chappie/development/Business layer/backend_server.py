import time
import json
import asyncio
import websockets
from copy import deepcopy
from math import floor

import requests
from datetime import datetime, timedelta
from stravaio import strava_oauth2, StravaIO

from google.cloud import bigquery
from google.cloud import bigquery_storage_v1beta1
from google.oauth2 import service_account

from flask import Flask, request
from flask_restful import Resource, Api
from flask_cors import CORS

app = Flask(__name__)
cors = CORS(app)
api = Api()


def execute_bigquery_job(q):
    query_job = client.query(q)
    results = list(query_job.result())
    return results


class WeatherHabits(Resource):
    """
        This resource is returning the weather habits as a numerical value with 2 decimals. The last
        type of measurement return a string value representing the activity habit predicted for the
        current weather data.
    """

    def __init__(self):
        self.queries = {
            "temperature": """SELECT AVG(predicted_avg_temperature) AS avg_temperature
                            FROM
                            ML.PREDICT( MODEL fitness.temperature_habits, (
                            WITH habits AS (
                                SELECT
                                  avg_temperature, avg_air_pressure,
                                  EXTRACT(HOUR FROM start_date) AS hourofday,
                                FROM `asavage2251.bachelor.habits`)
                            SELECT * FROM habits))""",
            "light" : """SELECT AVG(avg_light) AS avg_light
                            FROM
                            ML.PREDICT( MODEL fitness.temperature_habits, (
                            WITH habits AS (
                                SELECT
                                  avg_light, avg_air_pressure, avg_temperature,
                                  EXTRACT(HOUR FROM start_date) AS hourofday,
                                FROM `asavage2251.bachelor.habits`
                            ) SELECT * FROM habits))""",
            "air-pressure":  """SELECT AVG(avg_air_pressure) AS avg_air_pressure
                            FROM
                            ML.PREDICT( MODEL fitness.air_pressure_habits, (
                            WITH habits AS (
                                SELECT
                                  avg_temperature, avg_air_pressure,
                                  EXTRACT(HOUR FROM start_date) AS hourofday,
                                FROM `asavage2251.bachelor.habits`
                            ) SELECT * FROM habits))""",
            "activity-type": """
                        select predicted_type
                        from ML.PREDICT (MODEL `fitness.habits_type`,
                        (select (select temperature from `bachelor.weather` order by event_time desc limit 1) as avg_temperature, 
                        (select air_pressure from `bachelor.weather` order by event_time desc limit 1) as avg_air_pressure, 
                        (select light from `bachelor.weather` order by event_time desc limit 1) as avg_light));
                        """
        }

    def get(self, measurement):
        query = self.queries[measurement]
        tuples = execute_bigquery_job(query)
        if measurement == "temperature":
            return str(round(tuples[0].avg_temperature, 2))
        elif measurement == "light":
            return str(round(tuples[0].avg_light, 2))
        elif measurement == "air-pressure":
            return str(round(tuples[0].avg_air_pressure, 2))
        elif measurement == "activity-type":
            return str(tuples[0].predicted_type)
        else:
            return str(0)


class WeatherBoundaries(Resource):
    """
        This resource returns the minimum and maximum values for weather measurements, used to
        normalize data.
    """
    def __init__(self):
        self.queries = {
            "temperature": """ select MIN(temperature) as min_temperature, MAX(temperature) as max_temperature
                            from `asavage2251.bachelor.weather`""",
            "light": """ select MIN(light) as min_light, MAX(light) as max_light
                            from `asavage2251.bachelor.weather`""",
            "air-pressure": """ select MIN(air_pressure) as min_air_pressure, MAX(air_pressure) as max_air_pressure
                            from `asavage2251.bachelor.weather`"""
        }

    def get(self, measurement):
        query = self.queries[measurement]
        tuples = execute_bigquery_job(query)
        data = dict(tuples[0])
        return data


class StravaUser(Resource):
    """
        This resources deals with the Strava user business part.
    """

    @staticmethod
    def recent_activities():
        unused_features = ['photos', 'map', 'segment_efforts', 'highlighted_kudosers', 'splits_standard', 'laps',
                           'upload_id', 'external_id', 'splits_metric', 'splits_standard', 'gear_id',
                           'weighted_average_watts', 'segment_efforts', 'embed_token', 'device_watts', 'max_watts',
                           'average_watts', 'kilojoules', 'has_kudoed', 'trainer', 'commute', 'manual', 'private',
                           'flagged', 'start_date_local', 'photo_count', 'id', 'description', 'gear', 'workout_type',
                           'total_elevation_gain', 'elev_high', 'elev_low', 'timezone', 'start_latlng',
                           'end_latlng', 'achievement_count', 'kudos_count', 'comment_count', 'athlete_count',
                           'total_photo_count', 'best_efforts', 'device_name']
        results = execute_bigquery_job("select max(start_date) from `asavage2251.bachelor.activities`")
        last_saved_activity_start_date = results[0][0]
        print(last_saved_activity_start_date)

        strava_credentials = StravaUser.renew_credentials()
        with open('tokens.json', 'w', encoding='utf-8') as f:
            json.dump(strava_credentials, f, ensure_ascii=False, indent=4)

        sclient = StravaIO(access_token=strava_credentials['access_token'])
        activities = sclient.get_logged_in_athlete_activities(last_saved_activity_start_date)

        processed_activities = []
        normal_activities = []
        for activity in activities:
            strava_format_activity = sclient.get_activity_by_id(activity.id)
            activity = strava_format_activity.to_dict()

            yy = deepcopy(activity) # as in activitY copY
            yy['athlete_id'] = yy['athlete']['id']
            yy.pop('athlete', None)
            normal_activities.append(yy)
            date_left_bound = datetime.strptime(activity['start_date'], "%Y-%m-%dT%H:%M:%SZ")
            date_right_bound = datetime.strptime(activity['start_date'], "%Y-%m-%dT%H:%M:%SZ") + \
                               timedelta(0, int(activity["elapsed_time"]))
            q = "select MIN(temperature) as min_temp, MAX(temperature) as max_temp, AVG(temperature) as avg_temp, " + \
                "MIN(air_pressure) as min_air_pressure, MAX(air_pressure) as max_air_pressure, AVG(air_pressure) " + \
                "as avg_air_pressure, MIN(light) as min_light, MAX(light) as max_light, AVG(light) as avg_light " + \
                "from `asavage2251.bachelor.weather` " + \
                "where date(event_time) = '" + str(date_left_bound)[:10] + \
                "' and time(event_time) > '" + str(date_left_bound)[11:19] + \
                "' and date(event_time) = '" + str(date_right_bound)[:10] + \
                "' and time(event_time) < '" + str(date_right_bound)[11:19] + "'"
            try:
                query_job = client.query(q)
                results = list(query_job.result())
                activity_related_weather_values = results[0]

                x = activity
                x['avg_temperature'] = activity_related_weather_values.avg_temp
                x['avg_light'] = activity_related_weather_values.avg_light
                x['avg_air_pressure'] = activity_related_weather_values.avg_air_pressure

                for unused_feature in unused_features:
                    x.pop(unused_feature, None)

                x['athlete_id'] = x['athlete']['id']
                x.pop('athlete', None)
                processed_activities.append(x)
            except Exception as exc:
                print(exc)

        return [processed_activities, normal_activities]

    @staticmethod
    def renew_credentials():
        with open('credentials.json') as json_file:
            client = json.load(json_file)

        with open('tokens.json') as json_file:
            credentials = json.load(json_file)

        url = 'https://www.strava.com/api/v3/oauth/token?client_id=' + client['Client ID'] + \
              '&client_secret=' + client['Client Secret'] + '&refresh_token=' + credentials['refresh_token'] \
              + '&grant_type=refresh_token&scope=read,profile:read_all,activity:read'
        r = requests.post(url, None)
        json_data = r.json()
        return json_data

    def post(self):
        credentials = request.get_json()
        if credentials is None:
            credentials = StravaUser.renew_credentials()

        with open('tokens.json', 'w', encoding='utf-8') as f:
            json.dump(credentials, f, ensure_ascii=False, indent=4)
        client = StravaIO(access_token=credentials['access_token'])
        athlete = client.get_logged_in_athlete()
        athlete = athlete.to_dict()
        ath = client.athletes_api.get_stats(athlete['id'])
        ath = ath.__dict__
        for x in ath:
            if not isinstance(ath[x], int) and not isinstance(ath[x], str) and not isinstance(ath[x], float) and ath[x] is not None:
                ath[x] = ath[x].__dict__
        athlete['stats'] = ath
        return athlete


class BigQueryML(Resource):
    """
        This resources deals with BigQuery ML statistical models and views update.
    """
    def __init__(self):
        self.update_models_queries = {
            "temperature": """
                CREATE or REPLACE MODEL fitness.temperature_habits
                OPTIONS
                  (model_type='linear_reg', labels=['avg_temperature'], MIN_REL_PROGRESS=0.00000000001, MAX_ITERATIONS=50) AS

                WITH params AS (
                        SELECT 1 AS TRAIN, 0 AS EVAL),
                     habits AS (
                        SELECT
                          avg_temperature,
                          avg_air_pressure,
                          EXTRACT(HOUR FROM start_date) AS hourofday,
                        FROM
                          `asavage2251.bachelor.habits`, params
                        WHERE
                          moving_time > 0 and distance > 0
                          and type = "Run"
                          and avg_temperature is not null
                          and avg_air_pressure is not null
                    )
                SELECT * FROM habits;
                CREATE or REPLACE MODEL fitness.air_pressure_habits
                OPTIONS
                  (model_type='linear_reg', labels=['avg_air_pressure'], MIN_REL_PROGRESS=0.00000000001, MAX_ITERATIONS=50) AS
                
                WITH params AS ( 
                        SELECT 1 AS TRAIN, 0 AS EVAL),
                     habits AS (
                        SELECT 
                          avg_temperature,
                          avg_air_pressure,
                          EXTRACT(HOUR FROM start_date) AS hourofday,
                        FROM 
                          `asavage2251.bachelor.habits`, params
                        WHERE
                          moving_time > 0 and distance > 0 
                          and avg_temperature is not null
                          and avg_air_pressure is not null
                    )
                                    
                SELECT * FROM habits;
                CREATE or REPLACE MODEL fitness.light_habits
                OPTIONS
                  (model_type='linear_reg', labels=['avg_light'], MIN_REL_PROGRESS=0.00000000001, MAX_ITERATIONS=50) AS
                
                WITH params AS ( 
                        SELECT 1 AS TRAIN, 0 AS EVAL),
                     habits AS (
                        SELECT 
                          avg_light,
                          avg_air_pressure,
                          avg_temperature,
                          EXTRACT(HOUR FROM start_date) AS hourofday,
                        FROM 
                          `asavage2251.bachelor.habits`, params
                        WHERE
                          moving_time > 0 and distance > 0 
                          and avg_light is not null
                          and avg_air_pressure is not null
                          and avg_temperature is not null
                    )
                    
                SELECT * FROM habits;
                CREATE or REPLACE MODEL fitness.habits_type
                OPTIONS
                  (model_type='logistic_reg', auto_class_weights=true, labels=['type'], max_iterations=10) AS
                WITH params AS ( 
                        SELECT 1 AS TRAIN, 0 AS EVAL),
                     habits AS (
                        SELECT 
                          type,
                          avg_temperature,
                          avg_air_pressure,
                          avg_light
                        FROM 
                          `asavage2251.bachelor.habits`, params
                        WHERE
                          moving_time > 0 and distance > 0 
                          and avg_temperature is not null
                          and avg_air_pressure is not null
                          and avg_light is not null
                    )
                SELECT * FROM habits;
                CREATE or REPLACE MODEL fitness.habits_type
                OPTIONS
                    (model_type='logistic_reg', auto_class_weights=true, labels=['type'], max_iterations=10) AS
                WITH params AS (
                    SELECT 1 AS TRAIN, 0 AS EVAL),
                    habits AS (
                        SELECT
                        type,
                        avg_temperature,
                        avg_air_pressure,
                        avg_light
                    FROM
                        `asavage2251.bachelor.habits`, params
                    WHERE
                    moving_time > 0 and distance > 0
                    and avg_temperature is not null
                    and avg_air_pressure is not null
                    and avg_light is not null
                    )
                SELECT * FROM habits;
            """}
        self.update_views_query = """
                CREATE OR REPLACE VIEW `asavage2251.fitness.previous_weeks` AS SELECT ROUND(distance/1000, 2) as distance,
                  moving_time,
                  avg_temperature,
                  avg_light,
                  avg_air_pressure,
                  start_date,
                  week_delta
                FROM (
                  SELECT *, EXTRACT(WEEK FROM CURRENT_DATE()), EXTRACT(WEEK FROM start_date),
                  EXTRACT(WEEK FROM CURRENT_DATE()) - EXTRACT(WEEK FROM start_date) + 1 AS week_delta,
                  FROM `asavage2251.bachelor.habits`
                  WHERE EXTRACT(YEAR FROM start_date) = EXTRACT(YEAR FROM CURRENT_DATE())
                  UNION ALL
                  SELECT *, EXTRACT(WEEK FROM CURRENT_DATE()), EXTRACT(WEEK FROM start_date),
                  52 + EXTRACT(WEEK FROM CURRENT_DATE()) - EXTRACT(WEEK FROM start_date) + 1 AS week_delta,
                  FROM `asavage2251.bachelor.habits`
                  WHERE EXTRACT(YEAR FROM start_date) = EXTRACT(YEAR FROM CURRENT_DATE()) - 1
                  UNION ALL
                  SELECT *, EXTRACT(WEEK FROM CURRENT_DATE()), EXTRACT(WEEK FROM start_date),
                  104 + EXTRACT(WEEK FROM CURRENT_DATE()) - EXTRACT(WEEK FROM start_date) + 1 AS week_delta,
                  FROM `asavage2251.bachelor.habits`
                  WHERE EXTRACT(YEAR FROM start_date) = EXTRACT(YEAR FROM CURRENT_DATE()) - 2
                )
                ORDER BY week_delta;

                CREATE OR REPLACE VIEW `asavage2251.fitness.previous_weeks_grouped_by_week` AS
                SELECT
                  COUNT(*) as count,
                  ROUND(AVG(distance)/1000, 2) as distance,
                  ROUND(AVG(moving_time / 60), 0) as moving_time,
                  ROUND(AVG(avg_temperature), 2) as avg_temperature,
                  ROUND(AVG(avg_light), 2) as avg_light,
                  ROUND(AVG(avg_air_pressure), 2) as avg_air_pressure,
                  week_delta
                FROM (
                  SELECT *, EXTRACT(WEEK FROM CURRENT_DATE()), EXTRACT(WEEK FROM start_date),
                  EXTRACT(WEEK FROM CURRENT_DATE()) - EXTRACT(WEEK FROM start_date) + 1 AS week_delta,
                  FROM `asavage2251.bachelor.habits`
                  WHERE EXTRACT(YEAR FROM start_date) = EXTRACT(YEAR FROM CURRENT_DATE())
                  UNION ALL
                  SELECT *, EXTRACT(WEEK FROM CURRENT_DATE()), EXTRACT(WEEK FROM start_date),
                  52 + EXTRACT(WEEK FROM CURRENT_DATE()) - EXTRACT(WEEK FROM start_date) + 1 AS week_delta,
                  FROM `asavage2251.bachelor.habits`
                  WHERE start_date BETWEEN CAST(DATE(
                    EXTRACT(YEAR FROM CURRENT_DATE()) - 1,
                    EXTRACT(MONTH FROM CURRENT_DATE()),
                    EXTRACT(DAY FROM CURRENT_DATE())) AS timestamp) AND
                    CAST(DATE(EXTRACT(YEAR FROM CURRENT_DATE()) - 1, 12, 31) AS timestamp)
                )
                GROUP BY week_delta
                ORDER BY week_delta;
            """
    
    async def produce(self, message, host, port):
        async with websockets.connect(f"ws://{host}:{port}") as ws:
            try:
                await ws.send(message)
            except websockets.exceptions.ConnectionClosed as exc:
                print('err', exc)

    def get(self):
        print("Log: Fetch recent activities from Strava")

        batch = StravaUser.recent_activities()
        processed_activities = batch[0]
        activities = batch[1]

        if len(activities) > 0:
            print("Log: " + str(len(activities)) + " new activities.")
            dataset_ref = client.dataset('bachelor')
            habits_table_ref = dataset_ref.table('habits')
            habits_table = client.get_table(habits_table_ref)

            # Create new habit tuples from those activities
            ch_errs = client.insert_rows(habits_table, [
                (activity['name'], activity['athlete_id'], activity['avg_temperature'],
                 activity['type'], activity['avg_air_pressure'], activity['max_speed'],
                 activity['average_speed'], activity['elapsed_time'], activity['distance'],
                 activity['moving_time'], activity['calories'], activity['avg_light'],
                 activity['start_date']) for activity in processed_activities
            ])
            print(ch_errs)

            if len(ch_errs) == 0:
                activities_table_ref = dataset_ref.table('activities')
                activities_table = client.get_table(activities_table_ref)

                # Insert those activities into their tables
                ia_errs = client.insert_rows(activities_table, [
                    (activity['device_name'], activity['athlete_id'], activity['athlete_count'],
                     activity['type'], activity['max_speed'], activity['total_photo_count'],
                     activity['kudos_count'], activity['start_latlng'], activity['timezone'],
                     activity['elev_low'], activity['achievement_count'],
                     [{"name": None, "start_date": activity['start_date'], "moving_time": None}],
                     activity['name'], activity['elev_high'], activity['total_elevation_gain'],
                     activity['start_date'], activity['average_speed'], activity['elapsed_time'],
                     activity['end_latlng'], activity['calories'], activity['moving_time'],
                     activity['comment_count'], activity['distance']) for activity in activities])
                print(ia_errs)

                if len(ia_errs) == 0:
                    print("Log: Model retraining..")
                    m_errs = execute_bigquery_job(self.update_models_queries['temperature'])

                    print("Log: Views update..")
                    v_errs = execute_bigquery_job(self.update_views_query)

                    if len(m_errs) == 0 and len(v_errs) == 0:
                        return {"status": "updated"}
            return {"status": "error"}

        else:
            print("Log: 0 new activities - update/retraining postponed")
            return {"status": "idle"}


class Predictions(Resource):
    """
        This resources generates data with regard to the number of km predicted to run
        if starting at a given hour in a day, the average of the bike riding distance per
        hour and the availability to engage in fitness activities.
    """
    def __init__(self):
        self.queries = {
            "run": """SELECT ROUND(predicted_distance / 1000, 2) AS predicted_distance_km, hourofday
                        FROM
                        ML.PREDICT(MODEL fitness.hourly_activities, (
                        WITH activities AS (
                              SELECT
                                hour AS hourofday,
                              FROM `asavage2251.fitness.hours`
                              ORDER BY hourofday
                        ) SELECT * FROM activities))""",
            "availability": """WITH daynames AS (
                                SELECT ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'] AS daysofweek),
                                total_activities AS (
                                SELECT COUNT(*) as total FROM `asavage2251.bachelor.habits`),
                                activities AS (
                                SELECT
                                COUNT(*) AS number_of_activities,
                                daysofweek[ORDINAL(EXTRACT(DAYOFWEEK FROM start_date))] AS dayofweek
                                FROM
                                `asavage2251.bachelor.habits`, daynames
                                GROUP BY dayofweek
                                ORDER BY dayofweek)
                                SELECT dayofweek, (number_of_activities / total) * 100 as percent FROM activities, total_activities""",
            "riding-distance": """SELECT ROUND(AVG(distance / 1000), 2) as avg_distance,
                                      EXTRACT(HOUR FROM start_date) AS hourofday,
                                    FROM
                                      `asavage2251.bachelor.habits`
                                    WHERE
                                      moving_time > 0 and distance > 0 and type = "Ride"
                                    GROUP BY hourofday
                                    ORDER BY hourofday
                                    """
        }

    def get(self, target):
        query_job = client.query(self.queries[target])
        results = list(query_job.result())
        if target == "run":
            aux = []
            for x in list(results):
                aux.append([x['predicted_distance_km'], x['hourofday']])
            return aux
        elif target == "riding-distance":
            aux = []
            for x in list(results):
                aux.append([x['avg_distance'], x['hourofday']])
            return aux
        elif target == "availability":
            records = [dict(row) for row in results]
            return {'week distribution': records}
        else:
            return {"status": "invalid target"}


class Seasons(Resource):
    """
        This resource returns data about the seasons: winter, summer, spring, autumn, with
        the associated months.
    """
    def get(self):
        query_job = client.query("""
            SELECT COUNT(*) as count,
            ROUND(SUM(distance) / 1000, 2) as distance,
            ROUND(SUM(moving_time) / 60, 0) as moving_time,
            ROUND(AVG(avg_temperature), 2) as temperature,
            ROUND(AVG(avg_light), 2) as light,
            ROUND(AVG(avg_air_pressure), 2) as air_pressure,
            EXTRACT(MONTH FROM start_date) AS month,
            FROM `asavage2251.bachelor.habits`
            GROUP BY month
            ORDER BY month
        """)
        results = list(query_job.result())
        records = [dict(row) for row in results]
        return {'seasons': records}


class WeatherMeasurements(Resource):
    """
        This resource deals with the insert operation of weather measurements into the
        persistence layer.
    """
    def post(self):
        batch = request.get_json()
        # The logic of this function was moved in the file "weather.py" because while
        # presenting the application workflow, we need real weather data, which will be
        # obtained from sensors placed on the exterior of the building.
        return {'status': 'ok'}


class WeatherGraph(Resource):
    """
        This resource returns the measurements took in the last 24 hours.
    """

    def get(self):
        query_job = client.query("""
            SELECT * FROM `asavage2251.bachelor.weather`
            WHERE TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), event_time, HOUR) <= 24
            ORDER BY event_time""")

        results = list(query_job.result())
        res = []
        row = results[0]
        res.append(
            {"temperature": row.temperature, "location": row.location, "air_pressure": row.air_pressure, "light": row.light,
             "event_time": row.event_time.isoformat(), "color": row.color})
        n = len(results)
        last = results[0].event_time
        i = 1
        while i < n:
            while i < n and ((results[i].event_time - last).total_seconds() / 60) < 60:
                i += 1
            if i < n:
                row = results[i]
                last = results[i].event_time
                res.append({"temperature": row.temperature, "location": row.location, "air_pressure": row.air_pressure,
                            "light": row.light, "event_time": row.event_time.isoformat(), "color": row.color})
                i += 1
        return {"data": res}


class RecentActivities(Resource):
    """
        This resource returns the recent fitness activities.
    """

    def __init__(self):
        self.queries = {
            "run": """SELECT * FROM `asavage2251.bachelor.habits`
                    WHERE type = "Run" and avg_air_pressure IS NOT null 
                    and avg_temperature IS NOT NULL and avg_light IS NOT NULL
                    ORDER BY start_date DESC 
                    LIMIT 5""",
            "ride": """select * from `asavage2251.bachelor.habits`
                    where type = "Ride" and avg_air_pressure IS NOT null 
                    and avg_temperature IS NOT NULL and avg_light IS NOT NULL
                    order by start_date desc
                    limit 5""",
            "weights": """select * from `asavage2251.bachelor.habits`
                    where type = "WeightTraining" and avg_air_pressure IS NOT null 
                    and avg_temperature IS NOT NULL and avg_light IS NOT NULL
                    order by start_date desc
                    limit 5"""
        }

    def get(self, type):
        query_job = client.query(self.queries[type])
        results = list(query_job.result())
        tuples = [dict(row) for row in results]
        for t in tuples:
            t['start_date'] = t['start_date'].isoformat()
        return {'activities': tuples[:5]}


class PreviousWeeks(Resource):
    """
        This resource returns a summary of the previous weeks.
    """
    
    def get(self, noweeks):
        q = "SELECT * FROM `asavage2251.fitness.previous_weeks_grouped_by_week` WHERE week_delta <= " + noweeks + ";"
        query_job = client.query(q)
        results = list(query_job.result())
        records = [dict(row) for row in results]
        for record in records:
            q = """
                SELECT a.rmse, b.mit, b.mat, ((a.rmse - b.mit) / GREATEST((b.mat - b.mit), 1.0)) as nrmse  FROM (
                  SELECT SQRT(mean_squared_error) AS rmse, 1 as id FROM
                  ML.EVALUATE( MODEL fitness.temperature_habits, (
                   WITH habits AS (
                      SELECT
                        avg_temperature,
                        avg_air_pressure,
                        EXTRACT(HOUR FROM start_date) AS hourofday,
                      FROM
                        `asavage2251.fitness.previous_weeks`
                      WHERE EXTRACT(WEEK FROM start_date) > """ + str(record['week_delta']) + """)
                  SELECT * FROM habits))) as a
                  JOIN (
                    SELECT
                        MIN(avg_temperature) as mit,
                        MAX(avg_temperature) as mat,
                        1 as id
                    FROM
                      `asavage2251.fitness.previous_weeks`
                    WHERE EXTRACT(WEEK FROM start_date) > """ + str(record['week_delta']) + """
                ) as b on a.id = b.id;
            """
            query_job = client.query(q)
            results = list(query_job.result())
            result = dict(results[0])
            record['temp_rmse'] = result['rmse']
            record['temp_nrmse'] = result['nrmse']
        records = [x for x in records if x['temp_nrmse'] != None]
        n = len(records)
        print(records)
        for i in range(n - 1):
            if records[i]['temp_nrmse'] is not None and records[i+1]['temp_nrmse'] is not None:
                if records[i]['temp_nrmse'] < records[i+1]['temp_nrmse']:
                    records[i]['icon_name'] = 'arrow-dropdown-circle'
                elif records[i]['temp_nrmse'] > records[i+1]['temp_nrmse']:
                    records[i]['icon_name'] = 'arrow-dropup-circle'
                else:
                    records[i]['icon_name'] = 'remove-circle'
            else:
                records[i]['icon_name'] = 'remove-circle'
        if n > 0:
            records[n-1]['icon_name'] = 'close-circle'

        return {'previous weeks': records}


path = './asavage2251-c9acf02886b8.json'; project_id = 'asavage2251'
credentials = service_account.Credentials.from_service_account_file(path)
client = bigquery.Client(
                credentials=credentials,
                project=project_id)

api.add_resource(WeatherHabits, '/weather-habits/<string:measurement>')
api.add_resource(WeatherBoundaries, '/weather-boundaries/<string:measurement>')
api.add_resource(StravaUser, '/strava-user')
api.add_resource(RecentActivities, '/recent-activities/<string:type>')
api.add_resource(BigQueryML, '/bqml-retrain')
api.add_resource(Predictions, '/prediction/<string:target>')
api.add_resource(Seasons, '/seasons')
api.add_resource(WeatherGraph, '/weather-graph')
api.add_resource(PreviousWeeks, '/previous-weeks/<string:noweeks>')
api.add_resource(WeatherMeasurements, '/insert-weather')


api.init_app(app)
app.run(host='0.0.0.0', port=4001)
