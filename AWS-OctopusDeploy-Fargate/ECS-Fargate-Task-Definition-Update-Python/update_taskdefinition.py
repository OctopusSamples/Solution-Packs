# Example:
# python update_taskdefinition.py 'Server=ecshostedpoc.c1ufrgizkeyf.us-east-1.rds.amazonaws.com,1433;Initial Catalog=Octopus;Persist Security Info=False;User ID=sa;Password=S61#p!4tf7OLQCoV;MultipleActiveResultSets=False;Connection Timeout=30;'

import json
import sys

def main():
    update_taskdefinition(db_connection_string)

def update_taskdefinition(db_connection_string):
    # The JSON file, "task_definition.json" gets read, along with the index for the environment
    with open("Task-Definition-Terraform/task_definition.json", 'r+') as j:
        data = json.load(j)
        for d in data[0]['environment']:
            d['value'] = db_connection_string
    
    # After the index for the environment is read, the JSON file is written to
    # with the connection string that you pass in at runtime
    with open("Task-Definition-Terraform/task_definition.json", 'w') as input:
        json.dump(data, input)
        
# Pass in the connection string at runtime
db_connection_string = sys.argv[1]

if __name__ == '__main__':
    main()