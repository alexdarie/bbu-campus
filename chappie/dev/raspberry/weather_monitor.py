from google.cloud import pubsub_v1
from datetime import datetime
import threading
import flotilla
import time
import json
import os

credential_path = './asavage2251-c9acf02886b8.json'
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path
print('Credentials from environ: {}'.format(os.environ.get('GOOGLE_APPLICATION_CREDENTIALS')))

dock = flotilla.Client()
while not dock.ready:
    pass

weather = dock.first(flotilla.Weather)
light_v = dock.first(flotilla.Light)
colour = dock.first(flotilla.Colour)
number = dock.first(flotilla.Number)
matrix = dock.first(flotilla.Matrix)
rainbow = dock.first(flotilla.Rainbow)
rainbow.set_brightness(1)
slider = dock.first(flotilla.Dial)

font = {
    'A': [0, 127, 127, 68, 68, 127, 127, 0],
    'C': [0, 62, 127, 65, 65, 99, 34, 0],
    'P': [0, 127, 127, 68, 68, 124, 56, 0],
    'T': [0, 96, 64, 127, 127, 64, 96, 0],
    'L': [0, 127, 127, 1, 1, 1, 3, 0]
}

display = True
display_thread = None

if light_v is None or weather is None or number is None or matrix is None or rainbow is None or colour is None:
    dock.stop()
    sys.exit(1)


def temp_display():
    global display
    start_loop = datetime.now()
    while display and (datetime.now() - start_loop).total_seconds() <= 5:
        number.set_temp(float(weather.temperature))
        number.update()
        matrix.set_brightness(slider.position//204 * 15 + 15)
        matrix.set_icon('T', font)
        matrix.update()
    matrix.stop()
    while display:
        number.set_temp(float(weather.temperature))
        number.update()
    number.stop()


def light_display():
    global display
    start_loop = datetime.now()
    while display and (datetime.now() - start_loop).total_seconds() <= 5:
        number.set_number(int(light_v.light))
        number.update()
        matrix.set_brightness(slider.position//204 * 15 + 15)
        matrix.set_icon('L', font)
        matrix.update()
    matrix.stop()
    while display:
        number.set_number(int(light_v.light))
        number.update()
    number.stop()


def air_pressure_display():
    global display
    start_loop = datetime.now()
    while display and (datetime.now() - start_loop).total_seconds() <= 5:
        number.set_number(int(weather.pressure))
        number.update()
        pressure = int(weather.pressure)
        if pressure >= 10150:
            rainbow.set_pixel(0, 255, 0, 0)
        elif pressure > 9850:
            rainbow.set_pixel(2, 0, 255, 0)
        elif pressure > 8000:
            rainbow.set_pixel(4, 0, 0, 255)
        rainbow.update()
        matrix.set_brightness(slider.position//204 * 15 + 15)
        matrix.set_icon('P', font)
        matrix.update()
    matrix.stop()
    while display:
        number.set_number(int(weather.pressure))
        number.update()
        pressure = int(weather.pressure)
        if pressure >= 10150:
            rainbow.set_pixel(0, 255, 0, 0)
        elif pressure > 9850:
            rainbow.set_pixel(2, 0, 255, 0)
        elif pressure > 8000:
            rainbow.set_pixel(4, 0, 0, 255)
        rainbow.update()
    number.stop()
    rainbow.stop()


def color_display():
    global display
    start_loop = datetime.now()
    while display and (datetime.now() - start_loop).total_seconds() <= 5:
        rainbow.set_brightness(slider.position//204 + 1)
        for x in range(rainbow.num_pixels):
            rainbow.set_pixel(x, colour.red, colour.green, colour.blue)
        rainbow.update()
        matrix.set_brightness(slider.position//204 * 15 + 15)
        matrix.set_icon('C', font)
        matrix.update()
    matrix.stop()
    while display:
        rainbow.set_brightness(slider.position//204 + 1)
        for x in range(rainbow.num_pixels):
            rainbow.set_pixel(x, colour.red, colour.green, colour.blue)
        rainbow.update()
    rainbow.stop()


def alternate_display():
    global display
    start_loop = datetime.now()
    while display and (datetime.now() - start_loop).total_seconds() <= 5:
        number.set_temp(float(weather.temperature))
        number.update()
        matrix.set_brightness(slider.position//204 * 15 + 15)
        matrix.set_icon('A', font)
        matrix.update()
    matrix.stop()
    while display:
        start_loop = datetime.now()
        while display and (datetime.now() - start_loop).total_seconds() <= 5:
            number.set_number(int(light_v.light))
            number.update()
        while display and (datetime.now() - start_loop).total_seconds() <= 10:
            number.set_number(int(weather.pressure))
            number.update()
        while display and (datetime.now() - start_loop).total_seconds() <= 15:
            number.set_temp(float(weather.temperature))
            number.update()
    number.stop()


def silent_display():
    number.stop()


def display_settings_callback(message):
    global display, display_thread, options
    data = message.data.decode('utf-8')
    data = json.loads(data); display = False
    if display_thread is not None:
        display_thread.join()
    display_thread = threading.Thread(target=options[str(data['displayCode'])])
    display = True
    display_thread.start()
    message.ack()


def pairing_callback(message):
    global data_communication_thread, display_settings_thread, display
    data = message.data.decode('utf-8')
    try:
        message.ack()
        data = json.loads(data)
        print(message, data)
        if 'emit' in data:
            if data['emit']:
                print('pair')
                display = True
                data_communication_thread = threading.Thread(target=data_communication)
                display_settings_thread = threading.Thread(target=display_settings)
                data_communication_thread.start()
                display_settings_thread.start()
            elif not data['emit']:
                print('unpair')
                display = False
                data_communication_thread.do_run = False
                display_settings_thread.do_run = False
    except Exception as exc:
        print('Pairing callback exception: ', exc)


def data_communication():
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path('asavage2251', 'chappie-weather-measurements')
    try:
        t = threading.currentThread()
        while getattr(t, 'do_run', True):
            data = {'temperature': weather.temperature,
                    'air_pressure': weather.pressure,
                    'color': {'red': colour.red, 'green': colour.green, 'blue': colour.blue, 'clear': colour.clear},
                    'light': light_v.light,
                    'event_time': datetime.today().isoformat()}

            data = json.dumps(data)
            data = data.encode('utf-8')
            future = publisher.publish(topic_path, data=data)
            print(data, future.result())
            time.sleep(2)
    except KeyboardInterrupt:
        print('Stopping Flotilla..'); dock.stop()


def display_settings():
    subscriber = pubsub_v1.SubscriberClient()
    subscription_path = subscriber.subscription_path('asavage2251', 'chappie-display-settings')
    future = subscriber.subscribe(subscription_path, callback=display_settings_callback)
    t = threading.currentThread()
    while getattr(t, 'do_run', True):
        try: future.result(timeout=5)
        except Exception as exc:
            print('Timeout refresh: ', exc)
    future.cancel()


def pairing():
    subscriber = pubsub_v1.SubscriberClient()
    subscription_path = subscriber.subscription_path('asavage2251', 'chappie-pairing')
    future = subscriber.subscribe(subscription_path, callback=pairing_callback)
    try: future.result()
    except Exception as exc:
        print('Pairing exception: ', exc); future.cancel()


data_communication_thread = threading.Thread(target=data_communication)
display_settings_thread = threading.Thread(target=display_settings)
pairing_thread = threading.Thread(target=pairing)

options = {
    '0': alternate_display,
    '1': temp_display,
    '2': air_pressure_display,
    '3': light_display,
    '4': color_display,
    '5': silent_display
}

try:
    data_communication_thread.start()
    display_settings_thread.start()
    pairing_thread.start()
    display_thread = threading.Thread(target=options['1'])
    display_thread.start()
    
    data_communication_thread.join()
    display_settings_thread.join()
    pairing_thread.join()
except KeyboardInterrupt:
    display = False
    print('bye')
