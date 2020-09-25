module ID_EX(CLK,RST,stall,
                ID_MemWr,EX_MemWr,
                ID_RegWr,EX_RegWr,
                ID_MemRd,EX_MemRd,
                ID_ALUOp,EX_ALUOp,
                ID_RegDst,EX_RegDst,
                ID_Mem2Reg,EX_Mem2Reg,
                ID_WrReg,EX_WrReg,
                ID_PC,EX_PC,
                ID_Rt,EX_Rt,
                ID_Rd,EX_Rd,
                ID_Rs,EX_Rs,
                ID_jal,EX_jal,
                ID_ALUSrc1,EX_ALUSrc1, 
                ID_ALUSrc2,EX_ALUSrc2,
                ID_dataA, EX_dataA,
                ID_dataB, EX_dataB,
                ID_Imm16, EX_Imm16,
                ID_Shamt, EX_Shamt,
                ID_EXTOp,EX_EXTOp, 
                ID_LUOp,EX_LUOp,
                ID_Sign ,EX_Sign,
                ID_Funct, EX_Funct);
input CLK,RST,stall,ID_MemWr,ID_MemRd,ID_RegWr;
input [3:0]ID_ALUOp;
input [1:0]ID_RegDst,ID_Mem2Reg;
input [4:0]ID_WrReg,ID_Rt,ID_Rd,ID_Rs;
input [31:0]ID_PC;
input ID_jal;
input ID_ALUSrc1, ID_ALUSrc2; 
input [4:0]ID_Shamt;
input [31:0]ID_dataA;
input [31:0]ID_dataB;
input [15:0]ID_Imm16;
input [5:0] ID_Funct;
input ID_EXTOp, ID_LUOp;
input ID_Sign;

output reg EX_Sign;
output reg EX_jal;
output reg [31:0]EX_PC;
output reg [4:0]EX_WrReg,EX_Rt,EX_Rd,EX_Rs;
output reg [1:0]EX_RegDst,EX_Mem2Reg;
output reg [3:0]EX_ALUOp;
output reg EX_MemWr,EX_MemRd,EX_RegWr;
output reg EX_ALUSrc1, EX_ALUSrc2;
output reg [4:0]EX_Shamt;
output reg [31:0]EX_dataA;
output reg [31:0]EX_dataB;
output reg [15:0]EX_Imm16; 
output reg [5:0] EX_Funct;
output reg EX_EXTOp, EX_LUOp;

always@(posedge CLK or posedge RST) begin
    if(RST) begin
        EX_MemWr <= 0;
        EX_MemRd <= 0;
        EX_RegWr <= 0;
        EX_ALUOp <= 0;
        EX_RegDst <= 0;
        EX_Mem2Reg <= 0;
        EX_WrReg <= 0;
        EX_PC <= 32'b0;
        EX_Rt <= 0;
        EX_Rd <= 0;
        EX_Rs <= 0;
        EX_jal <= 0;
        EX_ALUSrc1 <= 0;
        EX_ALUSrc2 <= 0;
        EX_Shamt <= 5'b0;
        EX_dataA <= 32'b0;
        EX_dataB <= 32'b0;
        EX_Imm16 <= 16'b0;
        EX_EXTOp <= 0;
        EX_LUOp <= 0;
        EX_Sign <= 0;
        EX_Funct <= 6'b0;
    end
    else begin
        //�?要stall的时�?,将MemWr,MenRd, RegWr置零
        EX_MemWr <= stall ? 0:ID_MemWr;
        EX_MemRd <= stall ? 0:ID_MemRd;
        EX_RegWr <= (stall & ID_RegDst != 3)? 0:ID_RegWr;
        EX_ALUOp <= ID_ALUOp;
        EX_RegDst <= ID_RegDst;
        EX_Mem2Reg <= ID_Mem2Reg;
        EX_WrReg <= ID_WrReg;
        EX_PC <= ID_PC;
        EX_Rt <= ID_Rt;
        EX_Rd <= ID_Rd;
        EX_Rs <= ID_Rs;
        EX_jal <= ID_jal;
        EX_ALUSrc1 <= ID_ALUSrc1;
        EX_ALUSrc2 <= ID_ALUSrc2;
        EX_Shamt <= ID_Shamt;
        EX_dataA <= ID_dataA;
        EX_dataB <= ID_dataB;
        EX_Imm16 <= ID_Imm16;
        EX_EXTOp <= ID_EXTOp;
        EX_LUOp <= ID_LUOp;
        EX_Sign <= ID_Sign;
        EX_Funct <= ID_Funct;
    end
end
endmodule
