import pprint
import alooma
import os

api = alooma.Alooma(
    hostname=os.environ['ALOOMA_HOST'],
    port=int(os.environ['ALOOMA_PORT']),
    username=os.environ['ALOOMA_USERNAME'],
    password=os.environ['ALOOMA_PASSWORD'])

# Check for consolidation queries for mappings
events = api.get_event_types()
mappings = [x['name'] for x in events]

cs = api.get_scheduled_queries()
cqueries = [value['configuration']['event_type'] for key, value in
            cs.iteritems()]

result = [x for x in mappings if x not in cqueries]
pprint.pprint(sorted(result))
