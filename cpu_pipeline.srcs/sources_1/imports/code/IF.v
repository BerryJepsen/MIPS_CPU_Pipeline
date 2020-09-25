module IF(CLK, RST, stall, Branch_take, PCSrc,  PC_Forward, PC_Branch,  PC_j, PC_jr,  MEM_PC, IF_PC ,IF_instruction
);

input CLK, RST, stall, Branch_take ,PC_Forward;
input[31:0] PC_Branch,PC_jr;
input [31:0] MEM_PC; 
input[25:0]PC_j;
input[2:0] PCSrc;
output [31:0]IF_PC;//IF阶段输出的PC值
output [31:0]IF_instruction; //IF阶段输出指令

PC_Controller pc_controller(.CLK(CLK), .PC_Rst(RST), .stall(stall), .Branch_take(Branch_take), .PC_Src(PCSrc),  .PC_Forward(PC_Forward),
 .PC_Branch(PC_Branch),  .PC_j(PC_j), .PC_jr(PC_jr),  .MEM_PC(MEM_PC), .PC_Out(IF_PC)
);
Instruction_Memory instruction_memory(.Address(IF_PC), .Instruction(IF_instruction));

endmodule