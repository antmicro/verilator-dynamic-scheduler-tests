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

if len(sys.argv) > 1:
    timeout_arg = sys.argv[1]
    if timeout_arg.isnumeric():
        timeout = timeout_arg + "s"
    else:
        print(f"Usage: {sys.argv[0]} [timeout in seconds]")
        exit(1)

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
    if t in {"t/t_case_huge.pl", "t/t_case_huge_prof.pl", "t/t_dedupe_clk_gate.pl", "t/t_merge_cond.pl", "t/t_var_life.pl", "t/t_mem_shift.pl"}:
        tags = "opt"
    elif "t/t_dist_" in t:
        tags = "dist"
    elif "bad" in t:
        tags = "should_fail"
    else:
        tags = "should_pass"
    test_cases.append(builtin.render(test=t,
                                     tags=tags,
                                     timeout=timeout))

with open("robot_tests/builtin.robot", "w") as t:
    t.write(suite.render(test_cases="\n".join(test_cases)))
