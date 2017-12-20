//==================== GLOBAL ====================
`define RstEnable       1'b1
`define RstDiable       1'b0
`define ZeroWord        32'h00000000
`define WriteEnable     1'b1
`define WriteDisable    1'b0
`define ReadEnable      1'b1
`define ReadDisable     1'b0
`define AluOpBus        7:0
`define AlusSelBus      2:0
`define InstValid       1'b0
`define True_v          1'b1
`define False_v         1'b0
`define ChipEnable      1'b1
`define ChipDisable     1'b0

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
`define FUCNT3_LHU      3'b101
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
`define EXE_OR_OP       8'b00100101
`define EXE_NOP_OP      8'b00000000

//==================== ALUSEL ====================
`define EXE_RES_LOGIC   3'b001

`define EXE_RES_NOP     3'b000

//==================== ROM ====================
`define InstAddrBus     31 : 0
`define InstBus         31 : 0
`define InstMemNum      131071
`define InstMemNumLog2  17

//==================== REGFILE ====================
`define RegAddrBus      4 : 0
`define RegBus          31 : 0
`define RegWidth        32
`define DoubleRegWidth  64
`define DoubleRegBus    63 : 0
`define RegNumber       32
`define RegNumLog2      5
`define NOPRegAddr      5'b00000
