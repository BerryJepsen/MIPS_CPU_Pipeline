module EX_MEM(CLK,RST,
                 EX_ALUout,Mem_in,
                 EX_MemWr,Mem_MemWr,
                 EX_MemRd,Mem_MemRd,
                 EX_Forward,Mem_BusB,
                 EX_RegWr,Mem_RegWr,
                 EX_Mem2Reg,Mem_Mem2Reg,
                 EX_RegDst,Mem_RegDst,
                 EX_WrReg,Mem_WrReg,
                 EX_PC,Mem_PC,
                 EX_Rt,Mem_Rt,
                 EX_jal,MEM_jal);
input CLK,RST,EX_MemWr,EX_MemRd,EX_RegWr;
input[31:0]EX_ALUout,EX_Forward;
input [31:0]EX_PC;
input[1:0]EX_Mem2Reg,EX_RegDst;
input[4:0]EX_WrReg,EX_Rt;
input EX_jal;

output reg MEM_jal;
output reg[4:0]Mem_WrReg,Mem_Rt;
output reg[1:0]Mem_Mem2Reg,Mem_RegDst;
output reg Mem_MemWr,Mem_MemRd,Mem_RegWr;
output reg [31:0]Mem_in,Mem_BusB;
output reg [31:0] Mem_PC;

always@(posedge CLK or posedge RST) begin
    if(RST) begin
        Mem_MemWr<=0;
        Mem_MemRd<=0;
        Mem_in<=0;
        Mem_BusB<=0;
        Mem_Mem2Reg<=0;
        Mem_WrReg<=0;
        Mem_RegWr<=0;
        Mem_RegDst<=0;
        Mem_PC<=32'b0;
        Mem_Rt<=0;
        MEM_jal<=0;
    end
    else begin
        Mem_MemWr<=EX_MemWr;
        Mem_MemRd<=EX_MemRd;
        Mem_in<=EX_ALUout;
        Mem_BusB<=EX_Forward;
        Mem_Mem2Reg<=EX_Mem2Reg;
        Mem_WrReg<=EX_WrReg;
        Mem_RegWr<=EX_RegWr;
        Mem_RegDst<=EX_RegDst;
        Mem_PC<=EX_PC;
        Mem_Rt<=EX_Rt;
        MEM_jal<=EX_jal;
    end
end
endmodule
