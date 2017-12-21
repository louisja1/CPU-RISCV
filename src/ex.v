module ex (

    input   wire                rst,
    input   wire[`AluOpBus]     aluop_i,
    input   wire[`AluSelBus]    alusel_i,
    input   wire[`RegBus]       reg1_i,
    input   wire[`RegBus]       reg2_i,
    input   wire[`RegAddrBus]   wd_i,

    output  wire[`RegAddrBus]   wd_o,
    output  reg                 wreg_o,
    output  reg[`RegBus]        wdata_o

);

    reg[`RegBus]    logicout;

//==================== execution according to aluop_i ====================
    always @ ( * ) begin
        if (rst == `RstEnable) begin
            logicout <= `ZeroWord;
        end else begin
            case (aluop_i)
                `EXE_OR_OP: begin
                    logicout <= reg1_i | reg2_i;
                end
                default: begin
                    logicout <= `ZeroWord;
                end
            endcase
        end
    end


//==================== select result according to alusel_o ====================
    always @ ( * ) begin
        wd_o <= wd_i;
        wreg_o <= wreg_i;
        case (alusel_o)
            `EXE_RES_LOGIC: begin
                wdata_o <= logicout;
            end
            default: begin
                wdata_o <= `ZeroWord;
            end
        endcase
    end

endmodule
