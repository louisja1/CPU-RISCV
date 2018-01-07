`timescale 1ns / 1ps

module riscv_min_sooc_tb ();

    reg     CLOCK_50;
    reg     rst;


    initial begin
         CLOCK_50 = 1'b0;
         forever #10 CLOCK_50 = ~CLOCK_50;
    end

    initial begin
        rst = `RstEnable;
        $dumpfile("cpu-riscv.vcd");
        $dumpvars(0);
        #195 rst = `RstDisable;
        #1200 $finish;

    end

    riscv_min_sopc riscv_min_sopc0 (
        .clk(CLOCK_50),
        .rst(rst)
    );

endmodule
