module ID(CLK,RST,
                   ID_PC,ID_instruction,
                   IRQ, PCSrc,ID_Rs, ID_Rt, ID_Rd,
                   ID_RegDst,ID_RegWr,
                   ID_ALUSrc1,ID_ALUSrc2,
                   ID_ALUOp,ID_Sign,
                   ID_MemWr,ID_MemRd,
                   ID_Mem2Reg,ID_EXTOp,
                   ID_LUOp,PC_Branch,JT,
                   ID_dataA, ID_dataB,
                   ID_jal , WB_RegWr,ID_WrReg,
                   WB_Dst, WB_Out, Mem_in,PC_jr,
                   ForwardC,ForwardD,
                   Jump,Branch_take,Branch,ID_Shamt, ID_Imm16, ID_Funct);
input IRQ, CLK, RST, WB_RegWr, ForwardC, ForwardD;
input[31:0]ID_PC,ID_instruction,WB_Out,Mem_in;
input[4:0]WB_Dst;
output [31:0]PC_jr;
output[2:0]PCSrc;
output[1:0]ID_RegDst,ID_Mem2Reg;
output ID_RegWr,ID_Sign,ID_MemWr,ID_MemRd,ID_EXTOp,ID_LUOp;
output Branch_take;
output[3:0]ID_ALUOp;
output[25:0]JT; 
output[31:0]PC_Branch; 
output[31:0]ID_dataA,ID_dataB;
output[4:0]ID_WrReg,ID_Rt,ID_Rd,ID_Rs;
output Jump;
output Branch;
output ID_jal ;
output ID_ALUSrc1, ID_ALUSrc2;
output [4:0] ID_Shamt; 
output [15:0] ID_Imm16; 
output [5:0] ID_Funct;

wire [31:0] read_data1, read_data2;
wire [31:0] data1,data2;
wire RegWr;

//后续ALU使用
assign ID_Funct=ID_instruction[5:0];

//判定指令是jal与否, forward会用到
assign ID_jal = (ID_instruction[31:26]==3);

//先写后读的冒险
assign data1 = (WB_RegWr && WB_Dst==ID_instruction[25:21]) ? WB_Out : read_data1;
assign data2 = (WB_RegWr && WB_Dst==ID_instruction[20:16]) ? WB_Out : read_data2;

//jr
assign PC_jr=data1; //31号寄存器

//nop指令不写寄存器
assign ID_RegWr=(ID_instruction==32'b0 & ~IRQ) ? 0: RegWr;

//分支地址计算
assign PC_Branch=(ID_Imm16[15])? {14'b11111111111111,ID_Imm16,2'b00}+ID_PC:
                              {14'b0,ID_Imm16,2'b00}+ID_PC;

//判断转发, 送到提前预测分支的比较器
assign ID_dataA=(ForwardC) ? Mem_in:data1;
assign ID_dataB=(ForwardD) ? Mem_in:data2;

//写入寄存器编号($Rd or $Rt)
assign ID_WrReg=(ID_instruction[31:26]==0) ? ID_Rd:ID_Rt;

//判断是否为跳转指令
assign Jump=( (ID_instruction[31:26]==0 & (ID_instruction[5:0]==8 | ID_instruction[5:0]==9)) | 
                       (ID_instruction[31:26]==2 | ID_instruction[31:26]==3)) ? 1:0;

//提前预测分支
assign Branch_take=((ID_instruction[31:26]==1 & ID_dataA[31]==1) |  //bltz
            (ID_instruction[31:26]==4 & ID_dataA==ID_dataB) |  //beq
            (ID_instruction[31:26]==5 & ID_dataA!=ID_dataB) |  //bne
            (ID_instruction[31:26]==6 & (ID_dataA[31]==1|ID_dataA==0) ) |  //blez
            (ID_instruction[31:26]==7 & ID_dataA[31]==0 & ID_dataA!=0)) ? 1:0;  //bgtz

Control control(.Instruct(ID_instruction), .PC31(ID_PC[31]), .IRQ(IRQ) , .JT(JT) , .Imm16(ID_Imm16), .Shamt(ID_Shamt), 
  .Rd(ID_Rd), .Rt(ID_Rt), .Rs(ID_Rs), .PCSrc(PCSrc), .RegDst(ID_RegDst),
  .RegWr(RegWr), .ALUSrc1(ID_ALUSrc1), .ALUSrc2(ID_ALUSrc2), .ALUOp(ID_ALUOp), .Sign(ID_Sign), .MemWr(ID_MemWr),
   .MemRd(ID_MemRd), .Mem2Reg(ID_Mem2Reg), .EXTOp(ID_EXTOp), .LUOp(ID_LUOp), .Branch(Branch));

Register_File register_file(.RST(RST), .CLK(CLK), .RegWrite(WB_RegWr), 
		.Read_register1(ID_instruction[25:21]), .Read_register2(ID_instruction[20:16]), .Write_register(WB_Dst),
		.Write_data(WB_Out), .Read_data1(read_data1), .Read_data2(read_data2));

endmodule