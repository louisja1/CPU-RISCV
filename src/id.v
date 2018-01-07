module id (
    input   wire                rst,
    input   wire[`InstAddrBus]  pc_i,
    input   wire[`InstBus]      inst_i,

    input   wire[`RegBus]       reg1_data_i,
    input   wire[`RegBus]       reg2_data_i,

    input   wire                ex_wreg_i,
    input   wire[`RegBus]       ex_wdata_i,
    input   wire[`RegAddrBus]   ex_wd_i,

    input   wire                ex_is_load_i,

    input   wire                mem_wreg_i,
    input   wire[`RegBus]       mem_wdata_i,
    input   wire[`RegAddrBus]   mem_wd_i,

    output  reg[1 : 0]          reg1_read_o,
    output  reg[1 : 0]          reg2_read_o,
    output  reg[`RegAddrBus]    reg1_addr_o,
    output  reg[`RegAddrBus]    reg2_addr_o,

    output  reg[`AluOpBus]      aluop_o,
    output  reg[`AluSelBus]     alusel_o,
    output  reg[`RegBus]        reg1_o,
    output  reg[`RegBus]        reg2_o,
    output  reg[`RegAddrBus]    wd_o,
    output  reg                 wreg_o,
    output  reg                 stallreq_from_jump_branch,
    output  reg                 stallreq_from_load,

    output  reg                 branch_flag_o,
    output  reg[`RegBus]        branch_target_address_o,
    output  reg[`RegBus]        link_addr_o,
    output  wire[`InstBus]      inst_o

);

    assign inst_o = inst_i;

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
    wire[31 : 0]    u_type_imm = {inst_i[31 : 31], inst_i[30 : 20], inst_i[19 : 12], {12{1'b0}}};
    //J-type immediate
    wire[31 : 0]    j_type_imm = {{12{inst_i[31 : 31]}}, inst_i[19 : 12], inst_i[20 : 20], inst_i[30 : 25], inst_i[24 : 21], 1'b0};

    reg[`RegBus]    imm;
    reg instvalid;

    wire[`RegBus]   pc_plus_8;
    wire[`RegBus]   pc_plus_4;
    wire[`RegBus]   pc_plus_i_type_imm;
    wire[`RegBus]   pc_plus_j_type_imm;
    assign pc_plus_8 = pc_i + 8;
    assign pc_plus_4 = pc_i + 4;
    assign pc_plus_i_type_imm = pc_i + i_type_imm;
    assign pc_plus_j_type_imm = pc_i + j_type_imm;

//==================== decode ====================
    always @ ( * ) begin
        if (rst == `RstEnable) begin
            aluop_o         <=  `EXE_NOP_OP;
            alusel_o        <=  `EXE_RES_NOP;
            wd_o            <=  `NOPRegAddr;
            wreg_o          <=  `WriteDisable;
            instvalid       <=  `InstValid;
            reg1_read_o     <=  `REG_IMM;
            reg2_read_o     <=  `REG_IMM;
            reg1_addr_o     <=  `NOPRegAddr;
            reg2_addr_o     <=  `NOPRegAddr;
            imm             <=  `ZeroWord;
            stallreq_from_jump_branch   <=  `NoStop;
            stallreq_from_load = `NoStop;
            link_addr_o     <=  `ZeroWord;
            branch_target_address_o     <=  `ZeroWord;
            branch_flag_o   <=  `NotBranch;
        end else begin
            aluop_o         <=  `EXE_NOP_OP;
            alusel_o        <=  `EXE_RES_NOP;
            wd_o            <=  rd_addr;
            wreg_o          <=  `WriteDisable;
            instvalid       <=  `InstInvalid;
            reg1_read_o     <=  `REG_IMM;
            reg2_read_o     <=  `REG_IMM;
            reg1_addr_o     <=  rs1_addr;
            reg2_addr_o     <=  rs2_addr;
            imm             <=  `ZeroWord;
            stallreq_from_jump_branch   <=  `NoStop;
            stallreq_from_load = `NoStop;
            link_addr_o     <=  `ZeroWord;
            branch_target_address_o     <= `ZeroWord;
            branch_flag_o   <=  `NotBranch;

            case (opcode)
                `OPCODE_JAL : begin
                    wreg_o      <=  `WriteEnable;
                    aluop_o     <=  `EXE_JAL_OP;
                    alusel_o    <=  `EXE_RES_JUMP_BRANCH;
                    reg1_read_o <=  `REG_IMM;
                    reg2_read_o <=  `REG_IMM;
                    stallreq_from_jump_branch   <=  `Stop;
                    link_addr_o <=  pc_plus_4;
                    branch_flag_o   <=  `Branch;
                    branch_target_address_o     <=  pc_plus_j_type_imm;
                    instvalid   <=  `InstValid;
                end
                `OPCODE_JALR : begin
                    wreg_o      <=  `WriteEnable;
                    aluop_o     <=  `EXE_JALR_OP;
                    alusel_o    <=  `EXE_RES_JUMP_BRANCH;
                    reg1_read_o <=  `REG_READ;
                    reg2_read_o <=  `REG_IMM;
                    stallreq_from_jump_branch   <=  `Stop;
                    link_addr_o <=  pc_plus_4;
                    branch_flag_o   <=  `Branch;
                    instvalid   <=  `InstValid;
                    branch_target_address_o <=  (pc_plus_i_type_imm >> 1) << 1;
                end
                `OPCODE_AUIPC : begin
                    wreg_o      <=  `WriteEnable;
                    aluop_o     <=  `EXE_ADD_OP;
                    alusel_o    <=  `EXE_RES_ARITHMETIC;
                    reg1_read_o <=  `REG_PC;
                    reg2_read_o <=  `REG_IMM;
                    imm         <=  u_type_imm;
                    instvalid   <=  `InstValid;
                end
                `OPCODE_LUI : begin
                    wreg_o      <=  `WriteEnable;
                    aluop_o     <=  `EXE_OR_OP;
                    alusel_o    <=  `EXE_RES_LOGIC;
                    reg1_read_o <=  `REG_ZERO;
                    reg2_read_o <=  `REG_IMM;
                    imm         <=  u_type_imm;
                    instvalid   <=  `InstValid;
                end
                `OPCODE_BRANCH : begin
                    wreg_o      <=  `WriteDisable;
                    reg1_read_o <=  `REG_READ;
                    reg2_read_o <=  `REG_READ;
                    instvalid   <=  `InstValid;
                    case (funct3)
                        `FUNCT3_BEQ : begin
                            aluop_o     <=  `EXE_BEQ_OP;
                            alusel_o    <=  `EXE_RES_JUMP_BRANCH;
                            if (reg1_o == reg2_o) begin
                                stallreq_from_jump_branch   <=  `Stop;
                                branch_target_address_o     <=  pc_i + b_type_imm;
                                branch_flag_o               <=  `Branch;
                            end
                        end
                        `FUNCT3_BNE : begin
                            aluop_o     <=  `EXE_BNE_OP;
                            alusel_o    <=  `EXE_RES_JUMP_BRANCH;
                            if (reg1_o != reg2_o) begin
                                stallreq_from_jump_branch   <=  `Stop;
                                branch_target_address_o     <=  pc_i + b_type_imm;
                                branch_flag_o               <=  `Branch;
                            end
                        end
                        `FUNCT3_BLT : begin
                            aluop_o     <=  `EXE_BLT_OP;
                            alusel_o    <=  `EXE_RES_JUMP_BRANCH;
                            if ((reg1_o[31] > reg2_o[31]) || (reg1_o[31] == reg2_o[31] && reg1_o[30 : 0] < reg2_o[30 : 0])) begin
                                stallreq_from_jump_branch   <=  `Stop;
                                branch_target_address_o     <=  pc_i + b_type_imm;
                                branch_flag_o               <=  `Branch;
                            end
                        end
                        `FUNCT3_BLTU : begin
                            aluop_o     <=  `EXE_BLTU_OP;
                            alusel_o    <=  `EXE_RES_JUMP_BRANCH;
                            if (reg1_o < reg2_o) begin
                                stallreq_from_jump_branch   <=  `Stop;
                                branch_target_address_o     <=  pc_i + b_type_imm;
                                branch_flag_o               <=  `Branch;
                            end
                        end
                        `FUNCT3_BGE : begin
                            aluop_o     <=   `EXE_BGE_OP;
                            alusel_o    <=   `EXE_RES_JUMP_BRANCH;
                            //$display("reg1_o = %h reg2_o = %h", reg1_o, reg2_o);
                            if ((reg1_o[31] < reg2_o[31]) || (reg1_o[31] == reg2_o[31] && reg1_o[30 : 0] >= reg2_o[30 : 0])) begin
                                stallreq_from_jump_branch   <=  `Stop;
                                branch_target_address_o     <=  pc_i + b_type_imm;
                                branch_flag_o               <=  `Branch;
                            end
                        end
                        `FUNCT3_BGEU : begin
                            aluop_o     <=   `EXE_BGEU_OP;
                            alusel_o    <=   `EXE_RES_JUMP_BRANCH;
                            if (reg1_o >= reg2_o) begin
                                stallreq_from_jump_branch   <=  `Stop;
                                branch_target_address_o     <=  pc_i + b_type_imm;
                                branch_flag_o               <=  `Branch;
                            end
                        end
                        default : begin
                        end
                    endcase
                end
                `OPCODE_LOAD : begin
                    wreg_o      <=  `WriteEnable;
                    instvalid   <=  `InstValid;
                    reg1_read_o <= `REG_READ;
                    reg2_read_o <= `REG_IMM;
                    case (funct3)
                        `FUNCT3_LW : begin
                            aluop_o     <=  `EXE_LW_OP;
                            alusel_o    <=  `EXE_RES_LOAD_STORE;
                        end
                        `FUNCT3_LH : begin
                            aluop_o     <=  `EXE_LH_OP;
                            alusel_o    <=  `EXE_RES_LOAD_STORE;
                        end
                        `FUNCT3_LB : begin
                            aluop_o     <=  `EXE_LB_OP;
                            alusel_o    <=  `EXE_RES_LOAD_STORE;
                        end
                        `FUNCT3_LHU : begin
                            aluop_o     <=  `EXE_LHU_OP;
                            alusel_o    <=  `EXE_RES_LOAD_STORE;
                        end
                        `FUNCT3_LBU : begin
                            aluop_o     <=  `EXE_LBU_OP;
                            alusel_o    <=  `EXE_RES_LOAD_STORE;
                        end
                        default : begin
                        end
                    endcase
                end
                `OPCODE_STORE : begin
                    wreg_o      <=  `WriteDisable;
                    instvalid   <=  `InstValid;
                    reg1_read_o <= `REG_READ;
                    reg2_read_o <= `REG_READ;
                    case (funct3)
                        `FUNCT3_SW : begin
                            aluop_o     <=  `EXE_SW_OP;
                            alusel_o    <=  `EXE_RES_LOAD_STORE;
                        end
                        `FUNCT3_SH : begin
                            aluop_o     <=  `EXE_SH_OP;
                            alusel_o    <=  `EXE_RES_LOAD_STORE;
                        end
                        `FUNCT3_SB : begin
                            aluop_o     <=  `EXE_SB_OP;
                            alusel_o    <=  `EXE_RES_LOAD_STORE;
                        end
                        default : begin
                        end
                    endcase
                end
                `OPCODE_OP_IMM : begin
                    wreg_o      <=  `WriteEnable;
                    reg1_read_o <=  `REG_READ;
                    reg2_read_o <=  `REG_IMM;
                    instvalid   <=  `InstValid;
                    case (funct3)
                        `FUNCT3_XORI : begin
                            aluop_o     <=  `EXE_XOR_OP;
                            alusel_o    <=  `EXE_RES_LOGIC;
                            imm         <=  i_type_imm;
                        end
                        `FUNCT3_ORI : begin
                            aluop_o     <=  `EXE_OR_OP;
                            alusel_o    <=  `EXE_RES_LOGIC;
                            imm         <=  i_type_imm;
                        end
                        `FUNCT3_ANDI : begin
                            aluop_o     <=  `EXE_AND_OP;
                            alusel_o    <=  `EXE_RES_LOGIC;
                            imm         <=  i_type_imm;
                        end
                        `FUNCT3_SLLI : begin
                            aluop_o     <=  `EXE_SLL_OP;
                            alusel_o    <=  `EXE_RES_SHIFT;
                            imm         <=  i_type_imm;
                        end
                        `FUNCT3_SRLI : begin
                            if (funct7 == `FUNCT7_SRL) begin
                                aluop_o     <=  `EXE_SRL_OP;
                                alusel_o    <=  `EXE_RES_SHIFT;
                                imm         <=  i_type_imm;
                            end else if (funct7 == `FUNCT7_SRA) begin
                                aluop_o     <=  `EXE_SRA_OP;
                                alusel_o    <=  `EXE_RES_SHIFT;
                                imm         <=  i_type_imm;
                            end
                        end
                        `FUNCT3_SLTI : begin
                            aluop_o     <=  `EXE_SLT_OP;
                            alusel_o    <=  `EXE_RES_ARITHMETIC;
                            imm         <=  i_type_imm;
                        end
                        `FUNCT3_SLTIU : begin
                            aluop_o     <=  `EXE_SLTU_OP;
                            alusel_o    <=  `EXE_RES_ARITHMETIC;
                            imm         <=  i_type_imm;
                        end
                        `FUNCT3_ADDI: begin
                            aluop_o     <=  `EXE_ADD_OP;
                            alusel_o    <=  `EXE_RES_ARITHMETIC;
                            imm         <=  i_type_imm;
                        end
                        default : begin
                        end
                    endcase
                end
                `OPCODE_OP : begin
                    wreg_o      <=  `WriteEnable;
                    reg1_read_o <=  `REG_READ;
                    reg2_read_o <=  `REG_READ;
                    instvalid   <=  `InstValid;
                    case (funct3)
                        `FUNCT3_XOR : begin
                            aluop_o     <=  `EXE_XOR_OP;
                            alusel_o    <=  `EXE_RES_LOGIC;
                        end
                        `FUNCT3_OR : begin
                            aluop_o     <=  `EXE_OR_OP;
                            alusel_o    <=  `EXE_RES_LOGIC;
                        end
                        `FUNCT3_AND : begin
                            aluop_o     <=  `EXE_AND_OP;
                            alusel_o    <=  `EXE_RES_LOGIC;
                        end
                        `FUNCT3_SLL : begin
                            aluop_o     <=  `EXE_SLL_OP;
                            alusel_o    <=  `EXE_RES_SHIFT;
                        end
                        `FUNCT3_SRL : begin
                            if (funct7 == `FUNCT7_SRL) begin
                                aluop_o   <=  `EXE_SRL_OP;
                                alusel_o  <=  `EXE_RES_SHIFT;
                            end else if (funct7 == `FUNCT7_SRA) begin
                                aluop_o   <=  `EXE_SRA_OP;
                                alusel_o  <=  `EXE_RES_SHIFT;
                            end
                        end
                        `FUNCT3_SLT : begin
                            aluop_o     <=  `EXE_SLT_OP;
                            alusel_o    <=  `EXE_RES_ARITHMETIC;
                        end
                        `FUNCT3_SLTU : begin
                            aluop_o     <=  `EXE_SLTU_OP;
                            alusel_o    <=  `EXE_RES_ARITHMETIC;
                        end
                        `FUNCT3_ADD : begin
                            if (funct7 == `FUNCT7_ADD) begin
                                aluop_o     <=  `EXE_ADD_OP;
                                alusel_o    <=  `EXE_RES_ARITHMETIC;
                            end else if (funct7 == `FUNCT7_SUB) begin
                                aluop_o     <=  `EXE_SUB_OP;
                                alusel_o    <=  `EXE_RES_ARITHMETIC;
                            end
                        end
                        default : begin
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
        end else if ((reg1_read_o == `REG_READ) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o) && (reg1_addr_o != 5'b0)) begin
            reg1_o  <=  ex_wdata_i;
        end else if ((reg1_read_o == `REG_READ) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg1_addr_o) && (reg1_addr_o != 5'b0)) begin
            reg1_o  <=  mem_wdata_i;
        end else if (reg1_read_o == `REG_READ) begin
            reg1_o  <=  reg1_data_i;
        end else if (reg1_read_o == `REG_IMM) begin
            reg1_o  <=  imm;
        end else if (reg1_read_o == `REG_ZERO) begin
            reg1_o  <=  `ZeroWord;
        end else if (reg1_read_o == `REG_PC) begin
            reg1_o  <=  pc_i;
        end else begin
            reg1_o  <=  `ZeroWord;
        end
    end


//==================== rsrc2 ====================
    always @ ( * ) begin
        if (rst == `RstEnable) begin
            reg2_o  <=  `ZeroWord;
        end else if ((reg2_read_o == `REG_READ) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg2_addr_o) && (reg2_addr_o != 5'b0)) begin
            reg2_o  <=  ex_wdata_i;
        end else if ((reg2_read_o == `REG_READ) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg2_addr_o) && (reg2_addr_o != 5'b0)) begin
            reg2_o  <=  mem_wdata_i;
        end else if (reg2_read_o == `REG_READ) begin
            reg2_o  <=  reg2_data_i;
        end else if (reg2_read_o == `REG_IMM) begin
            reg2_o  <=  imm;
        end else if (reg2_read_o == `REG_ZERO) begin
            reg2_o  <=  `ZeroWord;
        end else if (reg2_read_o == `REG_PC) begin
            reg2_o  <=  pc_i;
        end else begin
            reg2_o  <=  `ZeroWord;
        end
    end

    //==================== stall for load ========================
    reg         stallreq_for_reg1;
    reg         stallreq_for_reg2;
    always @ ( * ) begin
        stallreq_for_reg1   <=  1'b0;
        if (rst == `RstDisable && reg1_read_o == `REG_READ &&
            reg1_addr_o != `ZeroWord && ex_is_load_i == 1'b1 && ex_wd_i == reg1_addr_o) begin
                stallreq_for_reg1    <=  1'b1;
        end
    end
    always @ ( * ) begin
        stallreq_for_reg2   <=  1'b0;
        if (rst == `RstDisable && reg2_read_o == `REG_READ &&
            reg2_addr_o != `ZeroWord && ex_is_load_i == 1'b1 && ex_wd_i == reg2_addr_o) begin
                stallreq_for_reg2    <=  1'b1;
        end
    end
    always @ ( * ) begin
        stallreq_from_load <= stallreq_for_reg1 | stallreq_for_reg2;
    end

endmodule
