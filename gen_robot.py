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
    test_cases.append(
        dedicated.render(test=t, tags="should_pass", timeout=timeout))

with open("robot_tests/dedicated.robot", "w") as t:
    t.write(suite.render(test_cases="\n".join(test_cases)))

# tests related to optimization that could be non-functional now
tests_opt = [
    "t/t_case_huge.pl", "t/t_case_huge_prof.pl", "t/t_dedupe_clk_gate.pl",
    "t/t_merge_cond.pl", "t/t_var_life.pl", "t/t_mem_shift.pl",
    "t/t_inst_tree_inl0_pub1.pl", "t/t_inst_tree_inl0_pub1_norelcfuncs.pl",
    "t_unopt_combo_isolate_vlt.pl", "t_alw_splitord.pl", "t_cellarray.pl",
    "t_reloop_cam.pl", "t_alw_split.pl", "t_alw_reorder.pl", "t_merge_cond.pl",
    "t_dedupe_seq_logic.pl", "t_alw_split_rst.pl", "t_clk_gater.pl",
    "t_alw_nosplit.pl", "t_gate_chained.pl", "t_alw_noreorder.pl",
    "t_unopt_combo_isolate.pl"
]

# tests related to performance, sometimes fail in the CI but not on a regular
# machine
tests_perf = [
    "t/t_a3_selftest.pl", "t/t_debug_graph_test.pl", "t/t_case_huge.pl",
    "t/t_case_huge_prof.pl", "t/t_unopt_array_csplit.pl", "t/t_split_var_0.pl",
    "t/t_split_var_2_trace.pl", "t/t_math_signed.pl",
    "t/t_interface_gen7_noinl.pl", "t_inst_tree_inl0_pub0.pl",
    "t_inst_tree_inl0_pub1.pl", "t/t_inst_tree_inl0_pub1_norelcfuncs.pl",
    "t/t_inst_tree_inl1_pub1.pl", "t/t_final.pl", "t/t_gen_genblk_noinl.pl",
    "t/t_gate_chained.pl"
]


test_cases = []
for t in sorted(glob("verilator/test_regress/t/t_*pl")):
    tags = []

    t = t[len("verilator/test_regress/"):]

    if t in tests_opt:
        tags.append("opt")

    if "t/t_dist_" in t:
        tags.append("dist")

    if t in tests_perf or "bench" in t:
        tags.append("perf")

    if "bad" in t:
        tags.append("should_fail")
    else:
        tags.append("should_pass")

    test_cases.append(
        builtin.render(test=t, tags="    ".join(tags), timeout=timeout))

with open("robot_tests/builtin.robot", "w") as t:
    t.write(suite.render(test_cases="\n".join(test_cases)))
