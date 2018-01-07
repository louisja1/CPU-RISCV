//==================== GLOBAL ====================
`define RstEnable       1'b1
`define RstDisable      1'b0
`define ZeroWord        32'h00000000
`define WriteEnable     1'b1
`define WriteDisable    1'b0
`define ReadEnable      1'b1
`define ReadDisable     1'b0
`define AluOpBus        7 : 0
`define AluSelBus       2 : 0
`define InstValid       1'b0
`define InstInvalid     1'b1
`define True_v          1'b1
`define False_v         1'b0
`define ChipEnable      1'b1
`define ChipDisable     1'b0
`define Stop            1'b1
`define NoStop          1'b0
`define Branch          1'b1
`define NotBranch       1'b0
`define InDelaySlot     1'b1
`define NotInDelaySlot  1'b0
`define Selected        1'b1
`define REG_READ        2'b00
`define REG_IMM         2'b01
`define REG_PC          2'b10
`define REG_ZERO        2'b11

//==================== OPCODE ====================
`define OPCODE_LUI          7'b0110111
`define OPCODE_AUIPC        7'b0010111
`define OPCODE_JAL          7'b1101111
`define OPCODE_JALR         7'b1100111
`define OPCODE_BRANCH       7'b1100011
`define OPCODE_LOAD         7'b0000011
`define OPCODE_STORE        7'b0100011
`define OPCODE_OP_IMM       7'b0010011
`define OPCODE_OP           7'b0110011
`define OPCODE_MEM          7'b0001111

//==================== FUNCT3 ====================
//JALR
`define FUNCT3_JALR     3'b000
//BRANCH
`define FUNCT3_BEQ      3'b000
`define FUNCT3_BNE      3'b001
`define FUNCT3_BLT      3'b100
`define FUNCT3_BGE      3'b101
`define FUNCT3_BLTU     3'b110
`define FUNCT3_BGEU     3'b111
//LOAD
`define FUNCT3_LB       3'b000
`define FUNCT3_LH       3'b001
`define FUNCT3_LW       3'b010
`define FUNCT3_LBU      3'b100
`define FUNCT3_LHU      3'b101
//STORE
`define FUNCT3_SB       3'b000
`define FUNCT3_SH       3'b001
`define FUNCT3_SW       3'b010
//OP-IMM
`define FUNCT3_ADDI     3'b000
`define FUNCT3_SLTI     3'b010
`define FUNCT3_SLTIU    3'b011
`define FUNCT3_XORI     3'b100
`define FUNCT3_ORI      3'b110
`define FUNCT3_ANDI     3'b111
`define FUNCT3_SLLI     3'b001
`define FUNCT3_SRLI     3'b101
`define FUNCT3_SRAI     3'b101
//OP
`define FUNCT3_ADD      3'b000
`define FUNCT3_SUB      3'b000
`define FUNCT3_SLL      3'b001
`define FUNCT3_SLT      3'b010
`define FUNCT3_SLTU     3'b011
`define FUNCT3_XOR      3'b100
`define FUNCT3_SRL      3'b101
`define FUNCT3_SRA      3'b101
`define FUNCT3_OR       3'b110
`define FUNCT3_AND      3'b111
//MEM
`define FUNCT3_FENCE    3'b000
`define FUNCT3_FENCEI   3'b001

//==================== FUNCT7 ====================
`define FUNCT7_SLLI     7'b0000000
`define FUNCT7_SRLI     7'b0000000
`define FUNCT7_SRAI     7'b0100000
`define FUNCT7_ADD      7'b0000000
`define FUNCT7_SUB      7'b0100000
`define FUNCT7_SLL      7'b0000000
`define FUNCT7_SLT      7'b0000000
`define FUNCT7_SLTU     7'b0000000
`define FUNCT7_XOR      7'b0000000
`define FUNCT7_SRL      7'b0000000
`define FUNCT7_SRA      7'b0100000
`define FUNCT7_OR       7'b0000000
`define FUNCT7_AND      7'b0000000

//==================== ALUOP ====================
`define EXE_NOP_OP      5'd0
`define EXE_AND_OP      5'd1
`define EXE_OR_OP       5'd2
`define EXE_XOR_OP      5'd3
`define EXE_ADDI_OP     5'd4
`define EXE_SLTI_OP     5'd5
`define EXE_SLTIU_OP    5'd6
`define EXE_SLL_OP      5'd7
`define EXE_SRL_OP      5'd8
`define EXE_SRA_OP      5'd9
`define EXE_SLT_OP      5'd10
`define EXE_SLTU_OP     5'd11
`define EXE_ADD_OP      5'd12
`define EXE_SUB_OP      5'd13
`define EXE_JAL_OP      5'd14
`define EXE_JALR_OP     5'd15
`define EXE_BEQ_OP      5'd16
`define EXE_BNE_OP      5'd17
`define EXE_BLT_OP      5'd18
`define EXE_BLTU_OP     5'd19
`define EXE_BGE_OP      5'd20
`define EXE_BGEU_OP     5'd21
`define EXE_LW_OP       5'd22
`define EXE_LH_OP       5'd23
`define EXE_LB_OP       5'd24
`define EXE_LBU_OP      5'd25
`define EXE_LHU_OP      5'd26
`define EXE_SB_OP       5'd27
`define EXE_SH_OP       5'd28
`define EXE_SW_OP       5'd29


//==================== ALUSEL ====================
`define EXE_RES_LOGIC       3'b001
`define EXE_RES_SHIFT       3'b010
`define EXE_RES_ARITHMETIC  3'b100
`define EXE_RES_JUMP_BRANCH 3'b110
`define EXE_RES_LOAD_STORE  3'b111

`define EXE_RES_NOP         3'b000

//==================== ROM ====================
`define InstAddrBus     31 : 0
`define InstBus         31 : 0
`define InstMemNum      1000
`define InstMemNumLog2  17

//==================== REGFILE ====================
`define RegAddrBus      4 : 0
`define RegBus          31 : 0
`define RegWidth        32
`define DoubleRegWidth  64
`define DoubleRegBus    63 : 0
`define RegNum          32
`define RegNumLog2      5
`define NOPRegAddr      5'b00000
`define DataAddrBus     31 : 0
`define DataBus         31 : 0
`define DataMemNum      1000
`define DataMemNumLog2  17
`define ByteWidth       7 : 0
