module Forward(
  RST,
  Mem_RegWr,Mem_WrReg,
  EX_Rs,EX_Rt,
  WB_RegWr,WB_WrReg,
  Branch,  MEM_jal,
  ID_Rs, ID_Rt,
  MEM_MemWr,Mem_Rt, PCSrc,
  ForwardA, ForwardB,
  ForwardC, ForwardD,
  ForwardPC, Forward_sw 
);

  input RST;
  input Mem_RegWr;
  input [4:0]Mem_WrReg;
  input [4:0]EX_Rs;
  input [4:0]EX_Rt;
  input WB_RegWr;
  input [4:0]WB_WrReg;
  input Branch;
  input [4:0]ID_Rs;
  input [4:0]ID_Rt;
  input MEM_jal;
  input [2:0]PCSrc;
  input MEM_MemWr;
  input [4:0] Mem_Rt;

  output reg [1:0] ForwardA;
  output reg [1:0] ForwardB;
  output reg ForwardC;
  output reg ForwardD;
  output reg ForwardPC;
  output reg Forward_sw;

always @(*) begin
  if (RST) begin
    ForwardA <= 2'b00;
    ForwardB <= 2'b00;
    ForwardC <= 0;
    ForwardD <= 0;
    Forward_sw <= 0;
    ForwardPC <= 0;
  end
  else begin
    //ALUSrc1转发
    if (Mem_WrReg!=0 && Mem_RegWr && (Mem_WrReg==EX_Rs)) ForwardA <= 2'b10;
    else if (WB_WrReg!=0 && WB_RegWr && (WB_WrReg==EX_Rs)) ForwardA <= 2'b01;
    else ForwardA <= 2'b00;
 
    //ALUSrc2转发
    if (Mem_WrReg!=0 && Mem_RegWr && (Mem_WrReg==EX_Rt)) ForwardB <= 2'b10;
    else if (WB_WrReg!=0 && WB_RegWr && (WB_WrReg==EX_Rt)) ForwardB <= 2'b01;
    else ForwardB <= 2'b00;

    //Register_File1路转发
    ForwardC <= (Branch && (Mem_WrReg!=0) && (Mem_WrReg==ID_Rs));

    //Register_File2路转发
    ForwardD <= (Branch && (Mem_WrReg!=0) && (Mem_WrReg==ID_Rt));

    //jal-jr冒险的PC转发
    ForwardPC <=(PCSrc==3 && MEM_jal==1) ?1:0;

    //write-store冒险转发
    Forward_sw <= (MEM_MemWr && WB_RegWr && (Mem_Rt == WB_WrReg));
  end
end

endmodule