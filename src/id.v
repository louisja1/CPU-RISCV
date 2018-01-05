module id (
    input   wire                rst,
    input   wire[`InstAddrBus]  pc_i,
    input   wire[`InstBus]      inst_i,

    input   wire[`RegBus]       reg1_data_i,
    input   wire[`RegBus]       reg2_data_i,

    output  reg                  reg1_read_o,
    output  reg                  reg2_read_o,
    output  reg[`RegAddrBus]     reg1_addr_o,
    output  reg[`RegAddrBus]     reg2_addr_o,

    output  reg[`AluOpBus]       aluop_o,
    output  reg[`AluSelBus]      alusel_o,
    output  reg[`RegBus]         reg1_o,
    output  reg[`RegBus]         reg2_o,
    output  reg[`RegAddrBus]     wd_o,
    output  reg                  wreg_o

);

    //R-type
    wire[6 : 0]     funct7 = inst_i[31 : 25];
    wire[4 : 0]     rs2_addr = inst_i[24 : 20];
    wire[4 : 0]     rs1_addr = inst_i[19 : 15];
    wire[2 : 0]     funct3 = inst_i[14 : 12];
    wire[4 : 0]     rd_addr = inst_i[11 : 7];
    wire[6 : 0]     opcode = inst_i[6 : 0];

    //I-type immediate
    wire[31 : 0]    i_type_imm = {{21{inst_i[31 : 31]}}, inst_i[30 : 25], inst_i[24 : 21], inst_i[20 : 20]};
    //S-type immediate
    wire[31 : 0]    s_type_imm = {{21{inst_i[31 : 31]}}, inst_i[30 : 25], inst_i[11 : 8], inst_i[7 : 7]};
    //B-type immediate
    wire[31 : 0]    b_type_imm = {{20{inst_i[31 : 31]}}, inst_i[7 : 7], inst_i[30 : 25], inst_i[11 : 8], 1'b0};
    //U-type immediate
    wire[31 : 0]    u_type_imm = {inst_i[31 : 31], inst_i[30 : 20], inst_i[19 : 12], {20{1'b0}}};
    //J-type immediate
    wire[31 : 0]    j_type_imm = {{12{inst_i[31 : 31]}}, inst_i[19 : 12], inst_i[20 : 20], inst_i[30 : 25], inst_i[24 : 21], 1'b0};

    reg[`RegBus]    imm;
    reg instvalid;

//==================== decode ====================
    always @ ( * ) begin
        if (rst == `RstEnable) begin
            aluop_o         <=  `EXE_NOP_OP;
            alusel_o        <=  `EXE_RES_NOP;
            wd_o            <=  `NOPRegAddr;
            wreg_o          <=  `WriteDisable;
            instvalid       <=  `InstValid;
            reg1_read_o     <=  1'b0;
            reg2_read_o     <=  1'b0;
            reg1_addr_o     <=  `NOPRegAddr;
            reg2_addr_o     <=  `NOPRegAddr;
            imm             <=  `ZeroWord;
        end else begin
            aluop_o         <=  `EXE_NOP_OP;
            alusel_o        <=  `EXE_RES_NOP;
            wd_o            <=  rd_addr;
            wreg_o          <=  `WriteDisable;
            instvalid       <=  `InstInvalid;
            reg1_read_o     <=  1'b0;
            reg2_read_o     <=  1'b0;
            reg1_addr_o     <=  rs1_addr;
            reg2_addr_o     <=  rs2_addr;
            imm             <=  `ZeroWord;

            case (opcode)
                `OPCODE_OP_IMM : begin
                    wreg_o      <=  `WriteEnable;
                    reg1_read_o <=  1'b1;
                    instvalid   <=  `InstValid;
                    case (funct3)
                        `FUNCT3_ORI : begin
                            aluop_o     <= `EXE_OR_OP;
                            alusel_o    <= `EXE_RES_LOGIC;
                            imm         <= i_type_imm;
                        end
                        default: begin
                        end
                    endcase
                end
                default : begin
                end
            endcase
        end
    end

//==================== rsrc1 ====================
    always @ ( * ) begin
        if (rst == `RstEnable) begin
            reg1_o  <=  `ZeroWord;
        end else if (reg1_read_o == 1'b1) begin
            reg1_o  <=  reg1_data_i;
        end else if (reg1_read_o == 1'b0) begin
            reg1_o  <=  imm;
        end else begin
            reg1_o  <=  `ZeroWord;
        end
    end


//==================== rsrc2 ====================
    always @ ( * ) begin
        if (rst == `RstEnable) begin
            reg2_o  <=  `ZeroWord;
        end else if (reg2_read_o == 1'b1) begin
            reg2_o  <=  reg2_data_i;
        end else if (reg2_read_o == 1'b0) begin
            reg2_o  <=  imm;
        end else begin
            reg2_o  <=  `ZeroWord;
        end
    end
endmodule
