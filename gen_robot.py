#!/usr/bin/env python3

from jinja2 import Template
from glob import glob


with open("templates/suite.robot", "r") as t:
    suite = Template(t.read())

with open("templates/dedicated.robot", "r") as t:
    dedicated = Template(t.read())

with open("templates/buitin.robot", "r") as t:
    builtin = Template(t.read())

test_cases = []
timeout = "120s"

for t in sorted(glob("tests/*")):
    test_cases.append(dedicated.render(test=t,
                                       tags="should_pass",
                                       timeout=timeout))

for t in sorted(glob("verilator/test_regress/t/t_*pl")):
    t = t[len("verilator/test_regress/"):]
    if "bad" in t:
        tags = "should_fail"
    else:
        tags = "should_pass"
    test_cases.append(builtin.render(test=t,
                                     tags=tags,
                                     timeout=timeout))

with open("all_tests.robot", "w") as t:
    t.write(suite.render(test_cases="\n".join(test_cases)))
