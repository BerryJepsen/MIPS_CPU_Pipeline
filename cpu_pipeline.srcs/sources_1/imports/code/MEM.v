module MEM(CLK,RST,Mem_MemRd,Mem_MemWr,Mem_in,Mem_outA,Mem_outB,Mem_BusB,IRQ,Forward_sw,WB_dataB, Digi_Tube);
input CLK,RST,Mem_MemRd,Mem_MemWr;
input Forward_sw;
input [31:0] WB_dataB;
input [31:0]Mem_in,Mem_BusB;
output [31:0]Mem_outA,Mem_outB;
output IRQ;
output [11:0]Digi_Tube;

wire [31:0]Mem_Out1,Mem_Out2; //分别为DataMemory、Peripheral
wire [31:0]Mem_WriteData;

//选择读出的数据来�?,Mem_in[30]�?0时是数据, 否则是外�?
assign Mem_outB=(Mem_in[30])? Mem_Out2: Mem_Out1;

//ALU运算结果不写内存
assign Mem_outA=Mem_in;

//写入存储器�?�择
assign Mem_WriteData = (Forward_sw) ? WB_dataB : Mem_BusB;

Data_Memory data_memory(.RST(RST), .CLK(CLK), .Address(Mem_in), .Write_data(Mem_WriteData), .Read_data(Mem_Out1), 
.MemRead(Mem_MemRd), .MemWrite(Mem_MemWr));

Peripheral peripheral(.RST(RST),.CLK(CLK),.rd(Mem_MemRd),.wr(Mem_MemWr),.Address(Mem_in),.Write_Data(Mem_WriteData),
.Read_Data(Mem_Out2), .IRQ(IRQ), .Digi_Tube(Digi_Tube));

endmodule