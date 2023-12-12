from json import loads as json_loads
from subprocess import Popen, DEVNULL
from os.path import expanduser

with open(expanduser("~/.config/yapl/yapl.json"), "r") as file:
    conf_json = json_loads(file.read())
    sorted_apps = sorted(conf_json.items())
    sorted_names = [x[0] for x in sorted_apps]
    sorted_cmds = [x[1] for x in sorted_apps]

    for x, y in enumerate(sorted_names, 1):
        print(f"{x}. {y}")

    while True:

        try:
            sel_prog = int(input("\nPlease choose which program to start: "))
            break

        except ValueError:
            print("Invalid input format")
            continue

    Popen(["nohup", sorted_cmds[sel_prog-1]], stdout=DEVNULL, stderr=DEVNULL)

