module  ctrl (
    input   wire        rst,
    input   wire        stallreq_from_load,
    input   wire        stallreq_from_jump_branch,
    output  reg[5 : 0]  stall
    // pc(1 = keep), if, id, ex, mem, wb(1 = stall)
);

    always @ ( * ) begin
        if (rst == `RstEnable) begin
            stall <= 6'b000000;
        end else if (stallreq_from_jump_branch == `Stop) begin
            stall <= 6'b000010;
        end else if (stallreq_from_load == `Stop) begin
            stall <= 6'b000111;
        end else begin
            stall <= 6'b000000;
        end
    end

endmodule
