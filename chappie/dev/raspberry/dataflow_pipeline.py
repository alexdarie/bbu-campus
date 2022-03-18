import argparse
import json
import os
import logging

import apache_beam as beam
import apache_beam.transforms.window as window
from apache_beam.options.pipeline_options import PipelineOptions
from google.oauth2 import service_account

credentials = service_account.Credentials.from_service_account_file(
            './savage2251-a452ea028c0a.json')


credential_path = "./savage2251-c04e78928873.json"
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path


class GroupWindowsIntoBatches(beam.PTransform):
    """A composite transform that groups Pub/Sub messages based on publish
    time and outputs a list of dictionaries, where each contains one message
    and its publish timestamp.
    """

    def __init__(self, window_size):
        # Convert minutes into seconds.
        self.window_size = int(window_size * 60)

    def expand(self, pcoll):
        return (
            pcoll
            | "Window into Fixed Intervals" >> beam.WindowInto(window.FixedWindows(self.window_size))
            | "Add timestamps to messages" >> beam.ParDo(AddTimestamps())
            | "Add Dummy Key" >> beam.Map(lambda elem: (None, elem))
            | "Groupby" >> beam.GroupByKey()
            | "Abandon Dummy Key" >> beam.MapTuple(lambda _, val: val)
        )


class AddTimestamps(beam.DoFn):
    def process(self, element, publish_time=beam.DoFn.TimestampParam):
        import datetime

        """Processes each incoming windowed element by extracting the Pub/Sub
        message and its publish timestamp into a dictionary. `publish_time`
        defaults to the publish timestamp returned by the Pub/Sub server. It
        is bound to each element by Beam at runtime.
        """

        yield {
            "message_body": element.decode("utf-8"),
            "publish_time": datetime.datetime.utcfromtimestamp(
                float(publish_time)
            ).strftime("%Y-%m-%d %H:%M:%S.%f"),
        }


class WriteBatchesToGCS(beam.DoFn):
    def __init__(self, output_path):
        self.output_path = output_path

    def process(self, batch, window=beam.DoFn.WindowParam):
        """Write one batch per file to a Google Cloud Storage bucket. """
        # import datetime
        import requests
        from google.cloud import bigquery
        # from google.cloud import bigquery_storage_v1beta1

        # ts_format = "%H:%M"
        # window_start = window.start.to_utc_datetime().strftime(ts_format)
        # window_end = window.end.to_utc_datetime().strftime(ts_format)
        # filename = "-".join([self.output_path, window_start, window_end])

        # with beam.io.gcp.gcsio.GcsIO().open(filename=filename, mode="w") as f:
        #     for element in batch:
        #         f.write("{}\n".format(json.dumps(element)).encode("utf-8"))

        # url = "https://weather-town.firebaseio.com/try.json"
        # for element in batch:
        #     data = json.loads(element['message_body'])
        #     data['publish_time'] = element['publish_time']
        #     data['processing_time'] = str(datetime.datetime.today())
        #     data['window_start'] = str(window_start)
        #     data['window_end'] = str(window_end)
        #     data['location'] = {'lat': 47.645995, 'lng': 26.252854}
        #     data = json.dumps(data)
        #     requests.post(url, data)

        project_id = 'savage2251'
        bigquery_client = bigquery.Client(credentials=credentials, project=project_id)

        dataset_ref = bigquery_client.dataset('demo')

        table_ref = dataset_ref.table('target2')
        table = bigquery_client.get_table(table_ref)  # API call

        rows_to_insert = [
            (10.0, [11.0, 11.0], 100.0, 200.0, None, [10.0, 10.0, 10.0, 10.0])
        ]
        bigquery_client.insert_rows(table, rows_to_insert)  # API request
        r = requests.get('http://161.35.76.247:4001/update-bqml-model')
        # json_data = r.json()
        # print(json_data)


def run(input_topic, output_path, window_size=1.0, pipeline_args=None):
    # `save_main_session` is set to true because some DoFn's rely on
    # globally imported modules.
    print(pipeline_args)
    pipeline_options = PipelineOptions(
        pipeline_args, streaming=True, save_main_session=True
    )

    with beam.Pipeline(options=pipeline_options) as pipeline:
        (
            pipeline
            | "Read Weather Message" >> beam.io.ReadFromPubSub(topic=input_topic)
            | "Check for Strava Activities & Write to DB" >> GroupWindowsIntoBatches(window_size)
            | "Update the Model" >> beam.ParDo(WriteBatchesToGCS(output_path))
            # | "Write to file" >> beam.io.WriteToText('./results/by-minute/')
            # | 'Log results' >> beam.ParDo(PrintMessages())
        )


if __name__ == "__main__":
    logging.getLogger().setLevel(logging.INFO)

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--input_topic",
        help="The Cloud Pub/Sub topic to read from.\n",
        default="projects/savage2251/topics/temp-1"
    )
    parser.add_argument(
        "--window_size",
        type=float,
        default=1.0,
        help="Output file's window size in number of minutes.",
    )
    parser.add_argument(
        "--output_path",
        help="GCS Path of the output file including filename prefix.",
        default="gs://savage-bucket/results/",
    )
    parser.add_argument(
        "--output",
        default="gs://savage-bucket/logs/",
    )
    # parser.add_argument(
    #     "--runner",
    #     default="DataflowRunner"
    # )
    # parser.add_argument(
    #     "--job_name",
    #     default="job-1"
    # )
    known_args, pipeline_args = parser.parse_known_args()
    print(known_args)
    print(pipeline_args)

    run(
        known_args.input_topic,
        known_args.output_path,
        known_args.window_size,
        pipeline_args,
    )
