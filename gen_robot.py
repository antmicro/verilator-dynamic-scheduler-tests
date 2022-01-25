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

with open("templates/ext_test.robot", "r") as t:
    ext_test = Template(t.read())

test_cases = []
timeout = "600s"

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
    os.makedirs("robot_tests/ext_tests", exist_ok=True)
except Exception as e:
    print("Unable to create directory ", e)
    sys.exit(1)

for t in sorted(glob("tests/*")):
    t = t[len("tests/"):]
    test_cases.append(
        dedicated.render(test=t, tags="should_pass", timeout=timeout))

with open("robot_tests/dedicated.robot", "w") as t:
    t.write(suite.render(test_cases="\n".join(test_cases)))

# tests related to optimization that could be non-functional now
tests_opt = {
    "t_case_huge.pl", "t_case_huge_prof.pl", "t_dedupe_clk_gate.pl",
    "t_merge_cond.pl", "t_var_life.pl", "t_mem_shift.pl",
    "t_inst_tree_inl0_pub1.pl", "t_inst_tree_inl0_pub1_norelcfuncs.pl",
    "t_unopt_combo_isolate_vlt.pl", "t_alw_splitord.pl", "t_cellarray.pl",
    "t_reloop_cam.pl", "t_reloop_offset.pl", "t_reloop_offset_lim_63.pl",
    "t_alw_split.pl", "t_alw_reorder.pl", "t_merge_cond.pl",
    "t_dedupe_seq_logic.pl", "t_alw_split_rst.pl", "t_clk_gater.pl",
    "t_alw_nosplit.pl", "t_gate_chained.pl", "t_alw_noreorder.pl",
    "t_unopt_combo_isolate.pl", "t_flag_expand_limit.pl",
    "t_const_opt_cov.pl", "t_gate_ormux.pl", "t_func_crc.pl",
    "t_const_opt_red.pl"
}

# tests related to performance, sometimes fail in the CI but not on a regular
# machine
tests_perf = {
    "t_a3_selftest.pl", "t_debug_graph_test.pl", "t_case_huge.pl",
    "t_case_huge_prof.pl", "t_unopt_array_csplit.pl", "t_split_var_0.pl",
    "t_split_var_2_trace.pl", "t_math_signed.pl",
    "t_interface_gen7_noinl.pl", "t_inst_tree_inl0_pub0.pl",
    "t_inst_tree_inl0_pub1.pl", "t_inst_tree_inl0_pub1_norelcfuncs.pl",
    "t_inst_tree_inl1_pub1.pl", "t_final.pl", "t_gen_genblk_noinl.pl",
    "t_gate_chained.pl", "t_flag_csplit_eval.pl"
}

# tests that use $file_grep, they either look for some optimizations, specific
# signal names or other things that may have changed with the dynamic scheduler
# but should not be considered critical
tests_grep = {
    "t_sys_file_scan.pl", "t_trace_complex.pl",
    "t_unopt_combo_isolate_vlt.pl", "t_alw_splitord.pl",
    "t_cellarray.pl", "t_trace_two_port_sc.pl", "t_trace_two_dump_sc.pl",
    "t_mem_shift.pl", "t_func_dotted_inl2_vlt.pl",
    "t_trace_complex_structs.pl", "t_var_pins_sc2.pl",
    "t_split/t_var_2_trace.pl", "t_hier_block_nohier.pl",
    "t_reloop_cam.pl", "t_reloop_offset.pl", "t_reloop_offset_lim_63.pl",
    "t_trace_two_hdr_cc.pl", "t_trace_two_port_cc.pl",
    "t_var_pins_sc_uint_biguint.pl", "t_hier_block_prot_lib.pl",
    "t_assert/t_property_fail_1.pl", "t_alw_split.pl", "t_flag_help.pl",
    "t_flag_xinitial_unique.pl", "t_clk_concat.pl", "t_assert_cover.pl",
    "t_trace_two_hdr_sc.pl", "t_inst/t_tree_inl1_pub0.pl",
    "t_clk_concat_vlt.pl", "t_var_pins_sc1.pl", "t_alw_reorder.pl",
    "t_threads_crazy.pl", "t_merge_cond.pl",
    "t_inst/t_tree_inl0_pub0.pl", "t_protect_ids.pl",
    "t_multitop_sig.pl", "t_inst/t_tree_inl0_pub1_norelcfuncs.pl",
    "t_vpi_release_dup_bad.pl", "t_split/t_var_3_wreal.pl",
    "t_dedupe_seq_logic.pl", "t_assert_basic_cover.pl",
    "t_inst/t_tree_inl0_pub1.pl", "t_var_pins_cc.pl", "t_flag_mmd.pl",
    "t_hier_block.pl", "t_trace_two_dump_cc.pl",
    "t_func_dotted_inl0_vlt.pl", "t_var_pins_sc32.pl",
    "t_case_huge_prof.pl", "t_flag_quiet_exit.pl", "t_dpi_var.pl",
    "t_split/t_var_0.pl", "t_alw_split_rst.pl", "t_clk_gater.pl",
    "t_prot_lib_clk_gated.pl", "t_trace_array.pl",
    "t_assert_implication_bad.pl", "t_trace_public_sig_vlt.pl",
    "t_var_pins_sc64.pl", "t_flag_csplit_off.pl",
    "t_trace_complex_portable.pl", "t_assert_elab_bad.pl",
    "t_optm_redor.pl", "t_hier_block_prot_lib_shared.pl",
    "t_cover_sva_notflat.pl", "t_trace_decoration.pl",
    "t_var_pins_scui.pl", "t_alw_nosplit.pl",
    "t_assert/t_property_fail_2.pl", "t_display_merge.pl",
    "t_optm_if_cond.pl", "t_trace_public_sig.pl", "t_prot_lib_shared.pl",
    "t_inst/t_tree_inl1_pub1.pl", "t_func_dotted_inl1.pl",
    "t_multitop1.pl", "t_case_huge.pl", "t_func_dotted_inl1_vlt.pl",
    "t_var_life.pl", "t_var_escape.pl", "t_flag_csplit.pl",
    "t_hier_block_vlt.pl", "t_class_dead.pl", "t_gate_chained.pl",
    "t_time_vpi_1ns1ns.pl", "t_trace_array_threads_1.pl",
    "t_threads_nondeterminism.pl", "t_dedupe_clk_gate.pl",
    "t_flag_xinitial_0.pl", "t_trace_complex_old_api.pl",
    "t_trace_complex_threads_1.pl", "t_cdc_async_bad.pl",
    "t_hier_block_sc.pl", "t_trace_ena_sc.pl", "t_noprot_lib.pl",
    "t_var_pins_sc_uint.pl", "t_cover_toggle.pl", "t_alw_noreorder.pl",
    "t_flag_build.pl", "t_dpi_var_vlt.pl", "t_optm_if_array.pl",
    "t_trace_primitive.pl", "t_trace_ena_cc.pl",
    "t_var_pins_sc_biguint.pl", "t_unopt_combo_isolate.pl",
    "t_trace_complex_params.pl", "t_prot_lib.pl",
    "t_hier_block_cmake.pl", "t_func_dotted_inl0.pl",
    "t_emit_memb_limit.pl", "t_time_vpi_1ms10ns.pl",
    "t_func_dotted_inl2.pl", "t_foreach.pl", "t_protect_ids_key.pl",
    "t_xml_debugcheck.pl", "t_xml_tag.pl"
}

# tests for which debug output is checked, which may or may not change because
# of the dynamic scheduler, but it's not related to actual functionality
tests_debug = {
    "t_gen_upscope.pl", "t_verilated_debug.pl"
}

# tests that are supposed to fail
tests_fail = {
    "t_clk_latch.pl", "t_clk_latch_edgestyle.pl", "t_order_doubleloop.pl"
}

# tests that generate verilog debug outupts and compares with
# already hardcoded files
tests_code_gen = {
    "t_debug_emitv.pl",
    "t_cover_line_trace.pl"
}

test_cases = []
for t in sorted(glob("verilator/test_regress/t/t_*pl")):
    tags = []

    t = t[len("verilator/test_regress/t/"):]

    if t in tests_opt:
        tags.append("opt")

    if "t_dist_" in t:
        tags.append("dist")

    if t in tests_perf or "bench" in t:
        tags.append("perf")

    if t in tests_grep:
        tags.append("file_grep")

    if t in tests_debug:
        tags.append("debug_out")

    if t in tests_code_gen:
        tags.append("code_gen")

    if t in tests_fail or "bad" in t:
        tags.append("should_fail")
    else:
        tags.append("should_pass")

    test_cases.append(
        builtin.render(test=t, tags="    ".join(tags), timeout=timeout))

with open("robot_tests/builtin.robot", "w") as t:
    t.write(suite.render(test_cases="\n".join(test_cases)))

test_cases = []
for t in sorted(glob("ext_tests/t/t_*pl")):
    t = t[len("ext_tests/t/"):]
    test_cases.append(
        ext_test.render(test=t, timeout=timeout))

with open("robot_tests/ext_tests.robot", "w") as t:
    t.write(suite.render(test_cases="\n".join(test_cases)))
