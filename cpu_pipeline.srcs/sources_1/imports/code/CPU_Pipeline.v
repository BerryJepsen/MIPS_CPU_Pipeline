module CPU_Pipeline(CLK,RST,Digi_Tube);
input RST;
input CLK;
output [11:0]Digi_Tube;

wire stall;
wire flush;
wire Branch_take;
wire [2:0]PCSrc;
wire [25:0]JT;
wire [31:0]PC_jr;
wire [31:0]PC_Branch;
wire [31:0]PC;
wire Branch;
wire ALUSrc1;
wire ALUSrc2;
wire Jump;
wire IRQ;

wire [31:0]IF_PC;
wire [31:0]IF_instruction;


wire ID_Sign;
wire ID_MemWr;
wire ID_MemRd;
wire ID_jal;
wire ID_EXTOp;
wire ID_LUOp;
wire ID_RegWr;
wire [1:0]ID_Mem2Reg;
wire [1:0]ID_RegDst;
wire [3:0]ID_ALUOp;
wire [4:0]ID_Rt;
wire [4:0]ID_Rd;
wire [4:0]ID_Rs;
wire [4:0]ID_WrReg;
wire [4:0] ID_Shamt;
wire [5:0] ID_Funct;
wire [15:0] ID_Imm16;    
wire [31:0]ID_instruction;
wire [31:0]ID_PC;
wire [31:0] ID_dataA, ID_dataB;


wire EX_MemWr;
wire EX_RegWr;
wire EX_MemRd;
wire EX_Sign;
wire EX_jal;
wire EX_ALUSrc1, EX_ALUSrc2;
wire EX_EXTOp;
wire EX_LUOp;
wire [1:0]EX_RegDst;
wire [1:0]EX_Mem2Reg;
wire [3:0]EX_ALUOp;
wire [4:0]EX_Rt;
wire [4:0]EX_Rd;
wire [4:0]EX_Rs;
wire [4:0]EX_WrReg;
wire [5:0]EX_Funct;
wire [4:0] EX_Shamt;
wire [15:0] EX_Imm16;
wire [31:0] EX_dataA;
wire [31:0] EX_dataB;    
wire [31:0] EX_Forward;  
wire [31:0]EX_PC;
wire [31:0]EX_ALUOut;

wire Mem_MemWr;
wire Mem_MemRd;
wire Mem_RegWr;
wire MEM_jal;
wire [1:0]Mem_Mem2Reg;
wire [1:0]Mem_RegDst;
wire [4:0]Mem_WrReg;
wire [4:0]Mem_Rt;
wire [31:0]Mem_BusB;
wire [31:0]Mem_outA;
wire [31:0]Mem_outB;
wire [31:0]Mem_in;
wire [31:0]Mem_PC;


wire WB_RegWr;
wire [4:0]WB_WrReg;
wire [31:0]WB_Out;
wire [31:0]WB_inB;
wire [31:0]WB_inA;
wire [1:0]WB_RegDst;
wire [1:0]WB_Mem2Reg;
wire [31:0]WB_PC;
wire [4:0]WB_Dst;

wire ForwardC;
wire ForwardD;
wire ForwardPC;
wire Forward_sw;
wire [1:0]ForwardA;
wire [1:0]ForwardB;


IF IF1(.CLK(CLK),.RST(RST),.stall(stall), .Branch_take(Branch_take), .PCSrc(PCSrc), .PC_Forward(ForwardPC), 
.PC_Branch(PC_Branch),  .PC_j(JT), .PC_jr(PC_jr),  .MEM_PC(Mem_PC), .IF_PC(IF_PC) ,.IF_instruction(IF_instruction)
);

IF_ID if_id(.CLK(CLK), .RST(RST), .stall(stall), .flush(flush), .IF_instruction(IF_instruction),
 .IF_PC(IF_PC), .ID_instruction(ID_instruction), .ID_PC(ID_PC));


ID id(.CLK(CLK), .RST(RST), .ID_PC(ID_PC) , .ID_instruction(ID_instruction),
                   .IRQ(IRQ), .PCSrc(PCSrc), .ID_Rs(ID_Rs) , .ID_Rt(ID_Rt), .ID_Rd(ID_Rd),
                   .ID_RegDst(ID_RegDst), .ID_RegWr(ID_RegWr),
                   .ID_ALUSrc1(ALUSrc1),.ID_ALUSrc2(ALUSrc2),
                   .ID_ALUOp(ID_ALUOp),.ID_Sign(ID_Sign),
                   .ID_MemWr(ID_MemWr),.ID_MemRd(ID_MemRd),
                   .ID_Mem2Reg(ID_Mem2Reg), .ID_EXTOp(ID_EXTOp),
                   .ID_LUOp(ID_LUOp),.PC_Branch(PC_Branch),.JT(JT),
                   .ID_dataA(ID_dataA),.ID_dataB(ID_dataB),
                   .ID_jal(ID_jal), .WB_RegWr(WB_RegWr), .ID_WrReg(ID_WrReg),
                   .WB_Dst(WB_Dst), .WB_Out(WB_Out),.Mem_in(Mem_in), .PC_jr(PC_jr),
                   .ForwardC(ForwardC),.ForwardD(ForwardD),
                   .Jump(Jump), .Branch_take(Branch_take),.Branch(Branch), 
                   .ID_Shamt(ID_Shamt), .ID_Imm16(ID_Imm16), .ID_Funct(ID_Funct));


ID_EX id_ex(.CLK(CLK), .RST(RST), .stall(stall),
                .ID_MemWr(ID_MemWr),.EX_MemWr(EX_MemWr),
                .ID_RegWr(ID_RegWr),.EX_RegWr(EX_RegWr),
                .ID_MemRd(ID_MemRd),.EX_MemRd(EX_MemRd),
                .ID_ALUOp(ID_ALUOp),.EX_ALUOp(EX_ALUOp),
                .ID_RegDst(ID_RegDst),.EX_RegDst(EX_RegDst),
                .ID_Mem2Reg(ID_Mem2Reg),.EX_Mem2Reg(EX_Mem2Reg),
                .ID_WrReg(ID_WrReg),.EX_WrReg(EX_WrReg),
                .ID_PC(ID_PC),.EX_PC(EX_PC),
                .ID_Rt(ID_Rt),.EX_Rt(EX_Rt),
                .ID_Rd(ID_Rd),.EX_Rd(EX_Rd),
                .ID_Rs(ID_Rs),.EX_Rs(EX_Rs),
                .ID_jal(ID_jal),.EX_jal(EX_jal),
                .ID_ALUSrc1(ALUSrc1),.EX_ALUSrc1(EX_ALUSrc1), 
                .ID_ALUSrc2(ALUSrc2),.EX_ALUSrc2(EX_ALUSrc2),
                .ID_dataA(ID_dataA), .EX_dataA(EX_dataA),
                .ID_dataB(ID_dataB), .EX_dataB(EX_dataB),
                .ID_Imm16(ID_Imm16), .EX_Imm16(EX_Imm16),
                .ID_Shamt(ID_Shamt), .EX_Shamt(EX_Shamt),
                .ID_EXTOp(ID_EXTOp),.EX_EXTOp(EX_EXTOp), 
                .ID_LUOp(ID_LUOp),.EX_LUOp(EX_LUOp),
                .ID_Sign(ID_Sign),.EX_Sign(EX_Sign),
                .ID_Funct(ID_Funct), .EX_Funct(EX_Funct));


EX ex(.ForwardA(ForwardA),.ForwardB(ForwardB),.EX_ALUOp(EX_ALUOp), .EX_Sign(EX_Sign),
 .EX_ALUOut(EX_ALUOut), .MEMWB_data(WB_Out), .EXMEM_data(Mem_in),
 .EX_ALUSrc1(EX_ALUSrc1), .EX_ALUSrc2(EX_ALUSrc2), .EX_Imm16(EX_Imm16), .EX_Shamt(EX_Shamt),
 .EX_dataA(EX_dataA),.EX_dataB(EX_dataB), .EX_EXTOp(EX_EXTOp),.EX_LUOp(EX_LUOp), 
 .EX_Forward(EX_Forward), .EX_Funct(EX_Funct));


EX_MEM ex_mem(.CLK(CLK),.RST(RST),
                 .EX_ALUout(EX_ALUOut),.Mem_in(Mem_in),
                 .EX_MemWr(EX_MemWr),.Mem_MemWr(Mem_MemWr),
                 .EX_MemRd(EX_MemRd),.Mem_MemRd(Mem_MemRd),
                 .EX_Forward(EX_Forward),.Mem_BusB(Mem_BusB),
                 .EX_RegWr(EX_RegWr),.Mem_RegWr(Mem_RegWr),
                 .EX_Mem2Reg(EX_Mem2Reg),.Mem_Mem2Reg(Mem_Mem2Reg),
                 .EX_RegDst(EX_RegDst),.Mem_RegDst(Mem_RegDst),
                 .EX_WrReg(EX_WrReg),.Mem_WrReg(Mem_WrReg),
                 .EX_PC(EX_PC),.Mem_PC(Mem_PC),
                 .EX_Rt(EX_Rt),.Mem_Rt(Mem_Rt),
                 .EX_jal(EX_jal), .MEM_jal(MEM_jal));


MEM mem(.CLK(CLK),.RST(RST),.Mem_MemRd(Mem_MemRd),.Mem_MemWr(Mem_MemWr), 
.Mem_in(Mem_in),.Mem_outA(Mem_outA),.Mem_outB(Mem_outB),.Mem_BusB(Mem_BusB),
.IRQ(IRQ),.Forward_sw(Forward_sw),.WB_dataB(WB_Out), .Digi_Tube(Digi_Tube));
         

MEM_WB mem_wb(.CLK(CLK),.RST(RST),
                 .Mem_outB(Mem_outB),.WB_inB(WB_inB),
                 .Mem_outA(Mem_outA),.WB_inA(WB_inA),
                 .Mem_RegDst(Mem_RegDst),.WB_RegDst(WB_RegDst),
                 .Mem_RegWr(Mem_RegWr), .WB_RegWr(WB_RegWr),
                 .Mem_WrReg(Mem_WrReg),.WB_WrReg(WB_WrReg),
                 .Mem_Mem2Reg(Mem_Mem2Reg),.WB_Mem2Reg(WB_Mem2Reg),
                 .Mem_PC(Mem_PC),.WB_PC(WB_PC));


WB wb(.WB_RegDst(WB_RegDst),.WB_Mem2Reg(WB_Mem2Reg),.WB_Out(WB_Out),
 .WB_inA(WB_inA),.WB_inB(WB_inB),.WB_PC(WB_PC),.WB_WrReg(WB_WrReg),.WB_Dst(WB_Dst));


Forward forward(
  .RST(RST),
  .Mem_RegWr(Mem_RegWr),.Mem_WrReg(Mem_WrReg),
  .EX_Rs(EX_Rs), .EX_Rt(EX_Rt),
  .WB_RegWr(WB_RegWr), .WB_WrReg(WB_WrReg),
  .Branch(Branch), .MEM_jal(MEM_jal),
  .ID_Rs(ID_Rs),.ID_Rt(ID_Rt),
  .MEM_MemWr(Mem_MemWr),.Mem_Rt(Mem_Rt), .PCSrc(PCSrc),
  .ForwardA(ForwardA),.ForwardB(ForwardB),
  .ForwardC(ForwardC),.ForwardD(ForwardD),
  .ForwardPC(ForwardPC),.Forward_sw(Forward_sw)
);

Hazard hazard(
  .RST(RST),.CLK(CLK),
  .Branch(Branch),.Branch_take(Branch_take),.Jump(Jump), 
  .EX_MemRd(EX_MemRd) ,.EX_RegWr(EX_RegWr),
  .EX_Rt(EX_Rt),.EX_Rd(EX_Rd),
  .EX_RegDst0(EX_RegDst[0]),
  .ID_Rs(ID_Rs), .ID_Rt(ID_Rt),
  .IRQ(IRQ), .stall(stall), .flush(flush)
);

endmodule