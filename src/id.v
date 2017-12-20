module id (
    input   wire                rst,
    input   wire[`InstAddrBus]  pc_i,
    input   wire[`InstBus]      inst_i,

    input   wire[`RegBus]       reg1_data_i,
    input   wire[`RegBus]       reg2_data_i,

    output reg                  reg1_read_o;
    output reg                  reg2_read_o;
    output reg[`RegAddrBus]     reg1_addr_o;
    output reg[`RegAddrBus]     reg2_addr_o;

    output reg[`AluOpBus]       aluop_o,
    output reg[`AluSelBus]      alusel_o,
    output reg[`RegBus]         reg1_o,
    output reg[`RegBus]         reg2_o,
    output reg[`RegAddrBus]     wd_o,
    output reg                  wreg_o

);

    //R-type
    wire[6 : 0]     funct7 = inst_i[31 : 25];
    wire[4 : 0]     rs2_addr = inst_i[24 : 20];
    wire[4 : 0]     rs1_addr = inst_i[19 : 15];
    wire[2 : 0]     funct3 = inst_i[14 : 12];
    wire[4 : 0]     rd_addr = inst_i[11 : 7];
    wire[6 : 0]     opcode = inst_i[6 : 0];
    //I-type immediate
    wire[31 : 0]    i_type_imm = {21{inst_i[31 : 31]}, inst_i[30 : 25], inst_i[24 : 21, inst_i[20 : 20]};
    //S-type immediate
    wire[31 : 0]    s_type_imm = {21{inst_i[31 : 31]}, inst_i[30 : 25], inst_i[11 : 8], inst_i[7 : 7]};
    //B-type immediate
    wire[31 : 0]    b_type_imm = {20{inst_i[31 : 31]}, inst_i[7 : 7], inst_i[30 : 25], inst_i[11 : 8], 0};
    //U-type immediate
    wire[31 : 0]    u_type_imm = {inst_i[31 : 31], inst_i[30 : 20], inst_i[19 : 12], 20{0}};
    //J-type immediate
    wire[31 : 0]    j_type_imm = {12{inst_i[31 : 31]}, inst_i[19 : 12], inst_i[20 : 20], inst_i[30 : 25], inst_i[24 : 21], 0};

    reg[`RegBus]    imm;
    reg instvalid;

//==================== decode ====================
    always @ ( * ) begin
        if (rst == `RstData) begin

        end else begin

        end
    end

endmodule
