import pprint
import alooma
import os
import sys
import datetime
import time

api = alooma.Alooma(
    hostname=os.environ['ALOOMA_HOST'],
    port=int(os.environ['ALOOMA_PORT']),
    username=os.environ['ALOOMA_USERNAME'],
    password=os.environ['ALOOMA_PASSWORD'])

# Get epoch time to send to the API
time = int(time.mktime((datetime.datetime.now() - datetime.timedelta(minutes=int(sys.argv[1]))).timetuple()) * 1000)

notifications = api.get_notifications(time)

if sys.argv[2] == 'true':
    # Print RAW output
    pprint.pprint(notifications)
else:
    # Make the output human readable (default)
    messages = notifications['messages']

    for message in messages:
        print(
            '--------------------------------------------------------\n' +
            str(message['severity']).capitalize() + ': ' +
            str(message['message']) + ' \n' +
            str(message['type']) + ': ' +
            str(message['typeDescription']) + ' \n' +
            '--------------------------------------------------------'
        )

