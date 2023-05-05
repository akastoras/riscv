VERILATOR = verilator
VERILATOR_FLAGS = -cc --exe -Wall --trace
VERILATOR_INPUT = ../src/pipelined/toplevel.v main.cpp
VERILATOR_INCLUDES = -I../src/pipelined
TEST = add

default: verilate build

verilate:
	@echo 
	@echo "----- VERILATE -----"
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_INCLUDES) $(VERILATOR_INPUT)

build:
	@echo 
	@echo "----- BUILD -----"
	$(MAKE) -j -C obj_dir -f Vtoplevel.mk

run: 
	@echo 
	@echo "----- RUN -----"
	obj_dir/Vtoplevel +trace +text_file=../tests/$(TEST).text.vh +data_file=../tests/$(TEST).data.vh

clean:
	rm -rf obj_dir 