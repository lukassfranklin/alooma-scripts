import pprint
import alooma
import os
import sys

api = alooma.Alooma(
    hostname=os.environ['ALOOMA_HOST'],
    port=int(os.environ['ALOOMA_PORT']),
    username=os.environ['ALOOMA_USERNAME'],
    password=os.environ['ALOOMA_PASSWORD'])

mp = api.get_mapping(sys.argv[1])

pprint.pprint(mp)
