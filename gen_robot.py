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
timeout = "1h"

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
    "t/t_gate_chained.pl", "t/t_flag_csplit_eval.pl"
]

# tests that use $file_grep, they either look for some optimizations, specific
# signal names or other things that may have changed with the dynamic scheduler
# but should not be considered critical
tests_grep = [
    "t/t_sys_file_scan.pl", "t/t_trace_complex.pl",
    "t/t_unopt_combo_isolate_vlt.pl", "t/t_alw_splitord.pl",
    "t/t_cellarray.pl", "t/t_trace_two_port_sc.pl", "t/t_trace_two_dump_sc.pl",
    "t/t_mem_shift.pl", "t/t_func_dotted_inl2_vlt.pl",
    "t/t_trace_complex_structs.pl", "t/t_var_pins_sc2.pl",
    "t/t_split/t_var_2_trace.pl", "t/t_hier_block_nohier.pl",
    "t/t_reloop_cam.pl", "t/t_trace_two_hdr_cc.pl", "t/t_trace_two_port_cc.pl",
    "t/t_var_pins_sc_uint_biguint.pl", "t/t_hier_block_prot_lib.pl",
    "t/t_assert/t_property_fail_1.pl", "t/t_alw_split.pl", "t/t_flag_help.pl",
    "t/t_flag_xinitial_unique.pl", "t/t_clk_concat.pl", "t/t_assert_cover.pl",
    "t/t_trace_two_hdr_sc.pl", "t/t_inst/t_tree_inl1_pub0.pl",
    "t/t_clk_concat_vlt.pl", "t/t_var_pins_sc1.pl", "t/t_alw_reorder.pl",
    "t/t_threads_crazy.pl", "t/t_merge_cond.pl",
    "t/t_inst/t_tree_inl0_pub0.pl", "t/t_protect_ids.pl",
    "t/t_multitop_sig.pl", "t/t_inst/t_tree_inl0_pub1_norelcfuncs.pl",
    "t/t_vpi_release_dup_bad.pl", "t/t_split/t_var_3_wreal.pl",
    "t/t_dedupe_seq_logic.pl", "t/t_assert_basic_cover.pl",
    "t/t_inst/t_tree_inl0_pub1.pl", "t/t_var_pins_cc.pl", "t/t_flag_mmd.pl",
    "t/t_hier_block.pl", "t/t_trace_two_dump_cc.pl",
    "t/t_func_dotted_inl0_vlt.pl", "t/t_var_pins_sc32.pl",
    "t/t_case_huge_prof.pl", "t/t_flag_quiet_exit.pl", "t/t_dpi_var.pl",
    "t/t_split/t_var_0.pl", "t/t_alw_split_rst.pl", "t/t_clk_gater.pl",
    "t/t_prot_lib_clk_gated.pl", "t/t_trace_array.pl",
    "t/t_assert_implication_bad.pl", "t/t_trace_public_sig_vlt.pl",
    "t/t_var_pins_sc64.pl", "t/t_flag_csplit_off.pl",
    "t/t_trace_complex_portable.pl", "t/t_assert_elab_bad.pl",
    "t/t_optm_redor.pl", "t/t_hier_block_prot_lib_shared.pl",
    "t/t_cover_sva_notflat.pl", "t/t_trace_decoration.pl",
    "t/t_var_pins_scui.pl", "t/t_alw_nosplit.pl",
    "t/t_assert/t_property_fail_2.pl", "t/t_display_merge.pl",
    "t/t_optm_if_cond.pl", "t/t_trace_public_sig.pl", "t/t_prot_lib_shared.pl",
    "t/t_inst/t_tree_inl1_pub1.pl", "t/t_func_dotted_inl1.pl",
    "t/t_multitop1.pl", "t/t_case_huge.pl", "t/t_func_dotted_inl1_vlt.pl",
    "t/t_var_life.pl", "t/t_var_escape.pl", "t/t_flag_csplit.pl",
    "t/t_hier_block_vlt.pl", "t/t_class_dead.pl", "t/t_gate_chained.pl",
    "t/t_time_vpi_1ns1ns.pl", "t/t_trace_array_threads_1.pl",
    "t/t_threads_nondeterminism.pl", "t/t_dedupe_clk_gate.pl",
    "t/t_flag_xinitial_0.pl", "t/t_trace_complex_old_api.pl",
    "t/t_trace_complex_threads_1.pl", "t/t_cdc_async_bad.pl",
    "t/t_hier_block_sc.pl", "t/t_trace_ena_sc.pl", "t/t_noprot_lib.pl",
    "t/t_var_pins_sc_uint.pl", "t/t_cover_toggle.pl", "t/t_alw_noreorder.pl",
    "t/t_flag_build.pl", "t/t_dpi_var_vlt.pl", "t/t_optm_if_array.pl",
    "t/t_trace_primitive.pl", "t/t_trace_ena_cc.pl",
    "t/t_var_pins_sc_biguint.pl", "t/t_unopt_combo_isolate.pl",
    "t/t_trace_complex_params.pl", "t/t_prot_lib.pl",
    "t/t_hier_block_cmake.pl", "t/t_func_dotted_inl0.pl",
    "t/t_emit_memb_limit.pl", "t/t_time_vpi_1ms10ns.pl",
    "t/t_func_dotted_inl2.pl", "t/t_foreach.pl"
]

# tests that generate verilog debug outupts and compares with
# already hardcoded files
tests_code_gen = [
    "t/t_debug_emitv.pl"
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

    if t in tests_grep:
        tags.append("file_grep")
    
    if t in tests_code_gen:
        tags.append("code_gen")

    if "bad" in t:
        tags.append("should_fail")
    else:
        tags.append("should_pass")

    test_cases.append(
        builtin.render(test=t, tags="    ".join(tags), timeout=timeout))

with open("robot_tests/builtin.robot", "w") as t:
    t.write(suite.render(test_cases="\n".join(test_cases)))
