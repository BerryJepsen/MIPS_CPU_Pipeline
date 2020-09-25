module EX(ForwardA, ForwardB, EX_ALUOp, EX_Sign, EX_ALUOut, MEMWB_data, EXMEM_data,
                   EX_ALUSrc1, EX_ALUSrc2, EX_Imm16, EX_Shamt, EX_dataA, EX_dataB,EX_EXTOp,EX_LUOp,EX_Forward, EX_Funct);
input EX_Sign;
input [1:0]ForwardA,ForwardB;
input [31:0]MEMWB_data;
input [31:0]EXMEM_data;
input EX_ALUSrc1, EX_ALUSrc2;
input EX_EXTOp, EX_LUOp;
input [4:0] EX_Shamt;
input [15:0] EX_Imm16;
input [31:0] EX_dataA;
input [31:0] EX_dataB; 
input [3:0]EX_ALUOp;
input [5:0] EX_Funct;
output [31:0]EX_ALUOut;
output [31:0]EX_Forward; 

wire [31:0] Data1,Data2;
wire [31:0] BusA, BusB;
wire [4:0] ALUCtl;
wire Sign;

assign BusA = EX_ALUSrc1 ? EX_Shamt : EX_dataA;
assign BusB = EX_ALUSrc2 ? (EX_LUOp ? {EX_Imm16, 16'b0} : (EX_EXTOp ? (EX_Imm16[15] ? {16'b1111111111111111, EX_Imm16} : {16'b0, EX_Imm16}) : {16'b0, EX_Imm16})) : EX_dataB;

//对送入ALU的数据通路进行选择
assign Data1=(ForwardA==2'b00) ? BusA :
             (ForwardA==2'b01) ? MEMWB_data :
             (ForwardA==2'b10) ? EXMEM_data : 
             32'b0;

assign Data2=(ForwardB==2'b00 || EX_ALUSrc2) ? BusB ://当送入立即数时，不需要转发，这是为了规避lw及sw的问题
             (ForwardB==2'b01) ? MEMWB_data :
             (ForwardB==2'b10) ? EXMEM_data : 
             32'b0;

assign EX_Forward = (ForwardB==2'b00) ? EX_dataB :
                           (ForwardB==2'b01) ? MEMWB_data :
                           (ForwardB==2'b10) ? EXMEM_data :
                           32'b0;

ALU alu(.in1(Data1), .in2(Data2), .ALUCtl(ALUCtl), .Sign(Sign), .out(EX_ALUOut));
ALU_Control alu_control(.ALUOp(EX_ALUOp), .Funct(EX_Funct), .ALUCtl(ALUCtl), .Sign(Sign));
endmodule
