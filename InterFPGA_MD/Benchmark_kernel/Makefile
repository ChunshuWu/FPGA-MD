.PHONY: help

help:
	@echo "Makefile Usage:"
	@echo "  make all DEVICE=<FPGA platform>"
	@echo "      Command to generate the xo for specified device."
	@echo "      By default, DEVICE=xilinx_u280_xdma_201920_3"
	@echo ""
	@echo "  make clean "
	@echo "      Command to remove the generated non-hardware files."
	@echo ""
	@echo "  make distclean"
	@echo "      Command to remove all the generated files."
	@echo ""


DEVICE ?= xilinx_u280_xdma_201920_3
KRNL_NAME_HDL := MD_RL
SUBMODULENAME = 100G-fpga-network-stack-core

XSA := $(strip $(patsubst %.xpfm, % , $(shell basename $(DEVICE))))
TEMP_DIR := _x.$(XSA)
VIVADO := $(XILINX_VIVADO)/bin/vivado
VPP := $(XILINX_VITIS)/bin/v++
CLFLAGS += -t hw --platform $(DEVICE) --save-temps

BINARY_HDL_OBJS = $(TEMP_DIR)/${KRNL_NAME_HDL}.xo

kernel_list ?= krnl_s2mm krnl_mm2s
BINARY_OBJS = $(addprefix $(TEMP_DIR)/, $(addsuffix .xo, $(kernel_list)))

.PHONY: all clean cleanall 
all: check-devices check-vivado check-vitis $(BINARY_HDL_OBJS) $(BINARY_OBJS)


# Cleaning stuff
clean:
	rm -rf *v++* *.log *.jou

distclean: clean
	rm -rf build_dir*
	rm -rf ./tmp_$(KRNL_NAME_HDL)* ./packaged_kernel* ./tmp_$(KRNL_SWITCH)*
	rm -rf _x* *.str
	rm -rf .Xil
	rm -rf ./bd


$(TEMP_DIR)/${KRNL_NAME_HDL}.xo:
	mkdir -p $(TEMP_DIR)
	$(VIVADO) -mode batch -source package_MD_RL_gen.tcl -notrace -tclargs $@ ${KRNL_NAME_HDL} $(XSA)

$(TEMP_DIR)/krnl_mm2s.xo: src/krnl_mm2s.cpp
	$(VPP) $(CLFLAGS) -k $(subst $(TEMP_DIR)/,,$(subst .xo,,$@)) -c -o $@ $^

$(TEMP_DIR)/krnl_s2mm.xo: src/krnl_s2mm.cpp
	$(VPP) $(CLFLAGS) -k $(subst $(TEMP_DIR)/,,$(subst .xo,,$@)) -c -o $@ $^


check-devices:
ifndef DEVICE
	$(error DEVICE not set. Please set the DEVICE properly and rerun. Run "make help" for more details.)
endif

#Checks for XILINX_VIVADO
check-vivado:
ifndef XILINX_VIVADO
	$(error XILINX_VIVADO variable is not set, please set correctly and rerun)
endif

#Checks for XILINX_VITIS
check-vitis:
ifndef XILINX_VITIS
	$(error XILINX_VITIS variable is not set, please set correctly and rerun)
endif
