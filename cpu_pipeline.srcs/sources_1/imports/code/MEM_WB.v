module MEM_WB(CLK,RST,
                 Mem_outB,WB_inB,
                 Mem_outA,WB_inA,
                 Mem_RegDst,WB_RegDst,
                 Mem_RegWr,WB_RegWr,
                 Mem_WrReg,WB_WrReg,
                 Mem_Mem2Reg,WB_Mem2Reg,
                 Mem_PC,WB_PC);
input CLK,RST,Mem_RegWr;
input [31:0]Mem_outB,Mem_outA;
input [31:0]Mem_PC;
input [1:0]Mem_Mem2Reg,Mem_RegDst;
input [4:0]Mem_WrReg;

output reg[1:0]WB_Mem2Reg,WB_RegDst;
output reg[4:0]WB_WrReg;
output reg[31:0]WB_inA,WB_inB;
output reg [31:0]WB_PC;
output reg WB_RegWr;

always@(posedge CLK or posedge RST) begin
    if(RST) begin
        WB_inA<=32'b0;
        WB_inB<=32'b0;
        WB_RegWr<=0;
        WB_RegDst<=0;
        WB_Mem2Reg<=0;
        WB_WrReg<=0;
        WB_PC<=31'b0;
    end
    else begin
        WB_inA<=Mem_outA;
        WB_inB<=Mem_outB;
        WB_RegWr<=Mem_RegWr;
        WB_RegDst<=Mem_RegDst;
        WB_Mem2Reg<=Mem_Mem2Reg;
        WB_WrReg<=Mem_WrReg;
        WB_PC<=Mem_PC;
    end
end
endmodule