module inst_rom_data_ram (
    input   wire                clk,

    input   wire                rom_ce,
    input   wire[`InstAddrBus]  rom_addr,
    output  reg[`InstBus]       rom_inst,

    input   wire                ram_ce,
    input   wire                ram_we,
    input   wire[`DataAddrBus]  ram_addr,
    input   wire[3 : 0]         ram_sel,
    input   wire[`DataBus]      ram_data_i,
    output  reg[`DataBus]       ram_data_o

);

    reg[`InstBus]               inst_mem[0 : `InstMemNum - 1];

    reg[`ByteWidth]             data_mem0[0 : `DataMemNum - 1];
    reg[`ByteWidth]             data_mem1[0 : `DataMemNum - 1];
    reg[`ByteWidth]             data_mem2[0 : `DataMemNum - 1];
    reg[`ByteWidth]             data_mem3[0 : `DataMemNum - 1];

    integer i;

    initial begin
        $readmemh ( "inst_rom.data" , inst_mem );
        for (i = 0; i < `InstMemNum; i = i + 1) begin
            data_mem0[i] <= inst_mem[i][31 : 24];
            data_mem1[i] <= inst_mem[i][23 : 16];
            data_mem2[i] <= inst_mem[i][15 : 8];
            data_mem3[i] <= inst_mem[i][7 : 0];
        end
    end
//==================== inst_rom ================
    always @ ( rom_ce or rom_addr ) begin
        if (rom_ce == `ChipDisable) begin
            rom_inst <= `ZeroWord;
        end else begin
            rom_inst <= {inst_mem[rom_addr >> 2][7 : 0], inst_mem[rom_addr >> 2][15 : 8],
                    inst_mem[rom_addr >> 2][23 : 16], inst_mem[rom_addr >> 2][31 : 24]};
        /*$display("inst[%d] = %b", addr >> 2, {inst_mem[addr >> 2][7 : 0], inst_mem[addr >> 2][15 : 8],
                    inst_mem[addr >> 2][23 : 16], inst_mem[addr >> 2][31 : 24]});*/
    end
end
//==================== data_ram ================

//==================== load =====================
    always @ ( * ) begin
        if (ram_ce == `ChipDisable) begin
            ram_data_o  <=  `ZeroWord;
        end else if (ram_we == `WriteDisable) begin
            ram_data_o  <=  {data_mem3[ram_addr >> 2], data_mem2[ram_addr >> 2], data_mem1[ram_addr >> 2], data_mem0[ram_addr >> 2]};
            $display("Load memory[%h] = %h", ram_addr, {data_mem3[ram_addr >> 2], data_mem2[ram_addr >> 2], data_mem1[ram_addr >> 2], data_mem0[ram_addr >> 2]});
        end else begin
            ram_data_o  <=  `ZeroWord;
        end
    end
//==================== store ====================
    always @ ( posedge clk ) begin
        if (ram_ce == `ChipDisable) begin
            ram_data_o  <=  `ZeroWord;
        end else if (ram_we == `WriteEnable) begin
            if (ram_sel[3] == `Selected) data_mem3[ram_addr >> 2] <= ram_data_i[31 : 24];
            if (ram_sel[2] == `Selected) data_mem2[ram_addr >> 2] <= ram_data_i[23 : 16];
            if (ram_sel[1] == `Selected) data_mem1[ram_addr >> 2] <= ram_data_i[15 : 8];
            if (ram_sel[0] == `Selected) data_mem0[ram_addr >> 2] <= ram_data_i[7 : 0];
            if (ram_addr == 32'h104) begin
                if (ram_sel[3] == `Selected) $display("%c", ram_data_i[31 : 24]);
                if (ram_sel[2] == `Selected) $display("%c", ram_data_i[23 : 16]);
                if (ram_sel[1] == `Selected) $display("%c", ram_data_i[15 : 8]);
                if (ram_sel[0] == `Selected) $display("%c", ram_data_i[7 : 0]);
            end
            $display("Store memory[%h] = %h", ram_addr, {{(ram_sel[3] == `Selected) ? ram_data_i[31 : 24] : 8'b0}, {(ram_sel[2] == `Selected) ? ram_data_i[23 : 16] : 8'b0}, {(ram_sel[1] == `Selected) ? ram_data_i[15 : 8] : 8'b0}, {(ram_sel[0] == `Selected) ? ram_data_i[7 : 0] : 8'b0}});
        end else begin
            ram_data_o  <=  `ZeroWord;
        end
    end

endmodule
