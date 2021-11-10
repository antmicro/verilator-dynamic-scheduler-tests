root_dir:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
curr_dir:=$(dir $(lastword $(MAKEFILE_LIST)))
IBEX = ${curr_dir}/ibex

################################
#### verilator - simulation ####
################################
IBEX_BUILD = ${root_dir}/build/lowrisc_ibex_ibex_simple_system_0

IBEX_INCLUDE = \
	-I$(IBEX_BUILD)/src/lowrisc_dv_verilator_ibex_pcounts_0/cpp \
	-I$(IBEX_BUILD)/src/lowrisc_dv_verilator_memutil_dpi_0/cpp \
	-I$(IBEX_BUILD)/src/lowrisc_dv_verilator_simutil_verilator_0/cpp \
	-I$(IBEX_BUILD)/src/lowrisc_dv_dv_fcov_macros_0 \
	-I$(IBEX_BUILD)/src/lowrisc_prim_assert_0.1/rtl \
	-I$(IBEX_BUILD)/src/lowrisc_prim_util_memload_0/rtl \
	-I$(IBEX_BUILD)/src/lowrisc_dv_verilator_memutil_verilator_0/cpp

SURELOG_PARAMETERS = +define+RVFI


IBEX_SOURCES = \
        $(shell \
                cat ${IBEX_BUILD}/sim-verilator/lowrisc_ibex_ibex_simple_system_0.vc | \
                grep -F .sv | \
                sed 's@^..@${IBEX_BUILD}@')

IBEX_SOURCES_DELETE = \
        $(shell \
                cat ${IBEX_BUILD}/sim-verilator/lowrisc_ibex_ibex_simple_system_0.vc | \
                grep -F .sv | sed "s/.*\///" )

IBEX_SOURCES_DELETE_OR = \
	$(shell \
		echo ${IBEX_SOURCES_DELETE} | sed 's/\s/\\|/g')

# Use up to 8 threads for simulated model (related to design parallelism factor)
CPU_COUNT := $(shell nproc)
CPUS_GT_8 := $(shell [ ${CPU_COUNT} -gt 8 ] && echo true )
ifeq ($(CPUS_GT_8),true)
	THREAD_COUNT = 8
else
	THREAD_COUNT = ${CPU_COUNT}
endif

clean-build:
	rm -rf $(root_dir)/build
	mkdir -p $(root_dir)/build

prepare-sources:
	virtualenv ${root_dir}/venv-ibex
	(export PATH=${root_dir}/../verilator/bin:${PATH} && \
		. ${root_dir}/venv-ibex/bin/activate && \
		pip install -r ${IBEX}/python-requirements.txt && \
		pip install git+https://github.com/antmicro/edalize@surelog && \
		fusesoc --cores-root=${IBEX} run \
			--target=sim \
			--setup lowrisc:ibex:ibex_simple_system \
			--RV32E=0 \
			--RV32M=ibex_pkg::RV32MFast \
			--verilator_options '--threads $(THREAD_COUNT)' \
			)

verilator/simple-system: clean-build | prepare-sources
	(export PATH=${root_dir}/../verilator/bin:${PATH} && \
	        . ${root_dir}/venv-ibex/bin/activate && \
		cd ${IBEX_BUILD}/sim-verilator/ && \
		$(MAKE))
