#!/usr/bin/env python3

from jinja2 import Template
from glob import glob
import sys
import os


with open("templates/suite.robot", "r") as t:
    suite = Template(t.read())

with open("templates/dedicated.robot", "r") as t:
    dedicated = Template(t.read())

with open("templates/builtin.robot", "r") as t:
    builtin = Template(t.read())

test_cases = []
timeout = "900s"

try:
    os.makedirs("robot_tests/dedicated", exist_ok=True)
    os.makedirs("robot_tests/builtin", exist_ok=True)
except Exception as e:
    print("Unable to create directory ", e)
    sys.exit(1)

for t in sorted(glob("tests/*")):
    test_cases.append(dedicated.render(test=t,
                                       tags="should_pass",
                                       timeout=timeout))

with open("robot_tests/dedicated.robot", "w") as t:
    t.write(suite.render(test_cases="\n".join(test_cases)))


test_cases = []
for t in sorted(glob("verilator/test_regress/t/t_*pl")):
    t = t[len("verilator/test_regress/"):]
    if "bad" in t:
        tags = "should_fail"
    else:
        tags = "should_pass"
    test_cases.append(builtin.render(test=t,
                                     tags=tags,
                                     timeout=timeout))

with open("robot_tests/builtin.robot", "w") as t:
    t.write(suite.render(test_cases="\n".join(test_cases)))
