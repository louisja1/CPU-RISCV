module data_ram (

    input   wire                clk,
    input   wire                ce,
    input   wire                we,
    input   wire[`DataAddrBus]  addr,
    input   wire[3 : 0]         sel,
    input   wire[`DataBus]      data_i,
    output  reg[`DataBus]       data_o

);
    reg[`ByteWidth]             data_mem0[0 : `DataMemNum - 1];
    reg[`ByteWidth]             data_mem1[0 : `DataMemNum - 1];
    reg[`ByteWidth]             data_mem2[0 : `DataMemNum - 1];
    reg[`ByteWidth]             data_mem3[0 : `DataMemNum - 1];

//==================== load ====================
    always @ ( * ) begin
        if (ce == `ChipDisable) begin
            data_o  <=  `ZeroWord;
        end else if (we == `WriteDisable) begin
            data_o  <=  {data_mem3[addr >> 2], data_mem2[addr >> 2], data_mem1[addr >> 2], data_mem0[addr >> 2]};
            //$display("%h %h %h %h %h %h", clk, ce, we, addr, sel ,data_i);
            $display("Load memory[%h] = %h", addr, {data_mem3[addr >> 2], data_mem2[addr >> 2], data_mem1[addr >> 2], data_mem0[addr >> 2]});
        end else begin
            data_o  <=  `ZeroWord;
        end
    end
//==================== store ====================
    always @ ( posedge clk ) begin
        if (ce == `ChipDisable) begin
            data_o  <=  `ZeroWord;
        end else if (we == `WriteEnable) begin
            if (sel[3] == `Selected) data_mem3[addr >> 2] <= data_i[31 : 24];
            if (sel[2] == `Selected) data_mem2[addr >> 2] <= data_i[23 : 16];
            if (sel[1] == `Selected) data_mem1[addr >> 2] <= data_i[15 : 8];
            if (sel[0] == `Selected) data_mem0[addr >> 2] <= data_i[7 : 0];
            $display("Store memory[%h] = %h", addr, {{(sel[3] == `Selected) ? data_i[31 : 24] : 8'b0}, {(sel[2] == `Selected) ? data_i[23 : 16] : 8'b0}, {(sel[1] == `Selected) ? data_i[15 : 8] : 8'b0}, {(sel[0] == `Selected) ? data_i[7 : 0] : 8'b0}});
        end else begin
            data_o  <=  `ZeroWord;
        end
    end

endmodule
