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
		$(SRC)/mem.v \
		$(SRC)/riscv.v \
		$(SRC)/inst_rom.v \
		$(SRC)/riscv_min_sopc.v \
		$(SRC)/riscv_min_sopc_tb.v\
		$(SRC)/ctrl.v \
		$(SRC)/data_ram.v

all : $(CPU)
	riscv32-unknown-elf-as -o inst_rom.o -march=rv32i inst_rom.s && \
	riscv32-unknown-elf-ld inst_rom.o -o inst_rom.om && \
	riscv32-unknown-elf-objcopy -O binary inst_rom.om inst_rom.bin && \
	./Bin_to_Text inst_rom.bin > inst_rom.data && \
	rm inst_rom.o inst_rom.om inst_rom.bin && \
	iverilog -o cpu-riscv.vvp $(CPU) && \
	vvp cpu-riscv.vvp

clean :
	rm cpu-riscv.vvp
