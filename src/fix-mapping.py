import alooma
import os
import sys
import pprint

api = alooma.Alooma(
    hostname=os.environ['ALOOMA_HOST'],
    port=int(os.environ['ALOOMA_PORT']),
    username=os.environ['ALOOMA_USERNAME'],
    password=os.environ['ALOOMA_PASSWORD'])

mapping_name = sys.argv[1]
schema_name = sys.argv[2]
table_name = sys.argv[3]

pprint.pprint(
    'Changing mapping ' + mapping_name + ' to consolidate to schema ' + schema_name + ' and table ' + table_name
)
mp = api.get_mapping(mapping_name)
mp['consolidation']['consolidatedSchema'] = schema_name
mp['consolidation']['consolidatedTableName'] = table_name
mp['mapping']['schema'] = schema_name
mp['mapping']['tableName'] = table_name + '_log'
api.set_mapping(mp, mapping_name)
