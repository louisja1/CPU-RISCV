SRC = ./src
CPU = 	$(SRC)/defines.v \
		$(SRC)/id.v \
		$(SRC)/if_id.v \
		$(SRC)/pc_reg.v \
		$(SRC)/regfile.v \
		$(SRC)/ex_mem.v \
		$(SRC)/id_ex.v \
		$(SRC)/ex.v \
		$(SRC)/mem_wb.v \
		$(SRC)/riscv.v \
		$(SRC)/inst_rom.v \
		$(SRC)/riscv_min_sopc.v \
		$(SRC)/riscv_min_sopc_tb.v \

cpu-riscv : $(CPU)
	iverilog -o cpu-riscv.vvp $(CPU)



clean :
	rm cpu-riscv
