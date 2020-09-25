module WB(WB_RegDst,WB_Mem2Reg,WB_Out,WB_inA,WB_inB,WB_PC,WB_WrReg,WB_Dst);
input [1:0]WB_RegDst,WB_Mem2Reg;
input [4:0]WB_WrReg;
input [31:0]WB_inA,WB_inB;
input [31:0] WB_PC;
output [31:0]WB_Out;
output [4:0]WB_Dst;

assign WB_Out = (WB_Mem2Reg==0) ? WB_inA: //ALU输出数据
              (WB_Mem2Reg==1) ? WB_inB: // MEM读出数据
              (WB_Mem2Reg==2) ? {1'b0, WB_PC[30:0]}: //jr指令
              ({1'b0, WB_PC[30:0]} - 4); //中断
assign WB_Dst = (WB_RegDst==2) ? 31://送入ID段的写入寄存器编号
                  (WB_RegDst==3) ? 26://中断异常
                   WB_WrReg;
endmodule