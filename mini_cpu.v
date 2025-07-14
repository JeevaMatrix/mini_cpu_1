module mini_cpu(input clk1, clk2);

    reg [31:0] Mem [1023:0];  //memory Rom - for instructions
    reg [31:0] Reg [31:0];  //32x32 registers

    reg [31:0] pc;       //program contrller
    reg [2:0] ID_EX_type, EX_MEM_type, MEM_WB_type;

    reg [31:0] IF_ID_IR;
    reg [31:0] ID_EX_IR, ID_EX_A, ID_EX_B, ID_EX_Imm;
    reg [31:0] EX_MEM_IR, EX_MEM_ALUout;
    reg [31:0] MEM_WB_IR, MEM_WB_ALUout;

    parameter ADD=6'b000000, SUB=6'b000001, MUL=6'b000010, AND=6'b000011, OR=6'b000100,
              ADDI=6'b000101, SUBI=6'b000110;

    parameter Rtype=3'b000, Itype=3'b001;

    always @(posedge clk1) begin    //IF Stage
        IF_ID_IR <= Mem[pc];
        pc <= pc+1;
    end

    always @(posedge clk2) begin    //ID Stage
        ID_EX_A <= Reg[IF_ID_IR[25:21]];
        ID_EX_B <= Reg[IF_ID_IR[20:16]];

        ID_EX_Imm <= {{16{IF_ID_IR[15]}},{IF_ID_IR[15:0]}};     //sign extended
        ID_EX_IR <= IF_ID_IR;

        case(IF_ID_IR[31:26])   //opcode decode
            ADD,SUB,MUL,AND,OR: ID_EX_type <= Rtype;
            ADDI,SUBI: ID_EX_type <= Itype;
        endcase
    end

    always @(posedge clk1) begin    //EX Stage
        EX_MEM_IR <= ID_EX_IR;
        EX_MEM_type <= ID_EX_type;

        case(ID_EX_type)
            Rtype:  case(ID_EX_IR[31:26])
                        ADD: EX_MEM_ALUout <= ID_EX_A + ID_EX_B;
                        SUB: EX_MEM_ALUout <= ID_EX_A - ID_EX_B;
                        MUL: EX_MEM_ALUout <= ID_EX_A * ID_EX_B;
                        AND: EX_MEM_ALUout <= ID_EX_A & ID_EX_B;
                        OR: EX_MEM_ALUout <= ID_EX_A | ID_EX_B;
                        default: EX_MEM_ALUout <= 32'hxxxxxxxx;
                    endcase
            Itype:  case(ID_EX_IR[31:26])
                        ADDI: EX_MEM_ALUout <= ID_EX_A + ID_EX_Imm;
                        SUBI: EX_MEM_ALUout <= ID_EX_A - ID_EX_Imm;
                        default: EX_MEM_ALUout <= 32'hxxxxxxxx;
                    endcase
        endcase
    end

    always @(posedge clk2) begin    //MEM Stage
        MEM_WB_IR <= EX_MEM_IR;
        MEM_WB_type <= EX_MEM_type;
        MEM_WB_ALUout <= EX_MEM_ALUout;
    end

    always @(posedge clk2) begin    //WB Stage
        case(MEM_WB_type)
            Rtype: Reg[MEM_WB_IR[15:11]] <= MEM_WB_ALUout;
            Itype: Reg[MEM_WB_IR[20:16]] <= MEM_WB_ALUout;
        endcase
    end
endmodule