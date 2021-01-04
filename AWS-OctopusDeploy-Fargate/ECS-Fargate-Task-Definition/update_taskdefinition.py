import json
import sys

def main():
    update_taskdefinition(db_connection_string)

def update_taskdefinition(db_connection_string):
    # In progress

    with open("Task-Definition-Terraform/task_definition.json") as j:
        data = json.load(j)
        data["containerDefinitions"]["environment"]["value"] = db_connection_string

        j.write()

db_connection_string = sys.argv[1]

if __name__ == '__main__':
    main()