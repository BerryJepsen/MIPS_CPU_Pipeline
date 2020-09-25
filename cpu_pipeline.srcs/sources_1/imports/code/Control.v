module Control(Instruct, PC31,IRQ, JT, Imm16, Shamt, Rd,Rt,Rs,PCSrc,RegDst,
  RegWr,ALUSrc1,ALUSrc2,ALUOp,Sign,MemWr,MemRd,Mem2Reg,EXTOp,LUOp, Branch);
  
  input [31:0] Instruct; 
  input PC31;
  input IRQ; 
  output [25:0] JT;
  output [15:0] Imm16;
  output [4:0] Shamt, Rd, Rt, Rs;
  output [2:0] PCSrc;
  output [1:0] RegDst, Mem2Reg;
  output [3:0] ALUOp;
  output RegWr, ALUSrc1, ALUSrc2, Sign, MemWr, MemRd, EXTOp, LUOp, Branch;

  wire  [5:0] Opcode, Funct;  //提取出Opcode, Funct
  wire R,I,J,JR,nop;          //判断指令类型
  wire Branch; //分支指令判断
  wire state;               //判断用户�?(0)还是内核�?(1)
  wire bad_instruction;          //坏指�?
  wire IRQ_proc; //处理中断
  wire EXP_proc; //处理异常

  assign Opcode=Instruct[31:26];
  assign Funct=Instruct[5:0];
  assign JT=Instruct[25:0]; 
  assign Imm16=Instruct[15:0];
  assign Shamt=Instruct[10:6];
  assign Rd=Instruct[15:11];
  assign Rt=Instruct[20:16];
  assign Rs=Instruct[25:21];

  assign nop=(Instruct==32'h0);  //判断是否为nop, 如果是赋1

  assign R= ~nop&(Opcode==6'b0)&
   			( (Instruct[10:3]==8'b00000100) |      //add,addu,sub,subu,and,or,xor,nor
				(Instruct[10:0]==11'b00000101010) |  //slt
				((Instruct[25:21] == 5'd0)&(Instruct[5:2]==4'd0)&(Instruct[1:0]!=2'b01))| //sll,srl,sra
				({Instruct[20:11],Instruct[5:1]}==15'b000000000000100) |               //jr
				({Instruct[20:16],Instruct[5:0]}==11'b00000001001)                     //jalr
			);    
  assign I=
      ( ((Instruct[31:29]==3'b001)&((Instruct[28:26]==3'b100)|~Instruct[28]|(Instruct[28:21]==8'b11100000)))|  //addi,addiu,andi,slti,sltiu,lui
			  ((Instruct[31:30]==2'b10)&(Instruct[28:26]==3'b011))|  //lw,sw
			  ((Instruct[31:29]==3'b000)&((Instruct[28:27]==2'b10)|  //beq,bne
			  ((Instruct[20:16]==5'b00000)&((Instruct[28:27]==2'b11)|(Instruct[28:26]==3'b001)))))//blez,bgtz,bltz
		  );
  assign J=(Instruct[31:27]==5'b00001);  //j,jal
	assign JR=R&(Instruct[5:1]==5'b00100); //jr,jalr
  assign bad_instruction=~(R|I|J|nop);   //�?测是否为mips指令

  //判断是否为分支指�?
  assign Branch=I&(Instruct[31:29]==3'b000);  //beq,bne,blez,bgtz,bltz

  //判断是否处理中断或异�?
  assign IRQ_proc=~PC31 & IRQ; 
  assign EXP_proc=~PC31 & bad_instruction; 
 
  //赋值给PCSrc, branch类型001, jump类型010, jr/jalr 011, 中断处理100, 异常处理 101, 其余情况000
  assign PCSrc[0]=(JR|Branch|EXP_proc)&~IRQ_proc;
  assign PCSrc[1]=(JR|J)&~IRQ_proc;
  assign PCSrc[2]=EXP_proc|IRQ_proc;

  //赋值给MemRd, lw�?1
  assign MemRd=(Opcode == 6'h23)? 1'b1: 1'b0;

  //赋值给Mem2Reg,  00-ALU; 01-lw ; 10-PC; 11-(PC-4)
  assign Mem2Reg[0]=MemRd|IRQ_proc; //lw, 中断处理
  assign Mem2Reg[1]=(J&Opcode[0])|(JR&Funct[0])|IRQ_proc; //jal, jalr, 中断处理

  //RegWr, R型指令除了jr, I型指令除了branch和sw, jal, 中断处理
  assign RegWr=(R&~(JR&~Funct[0])) | (I&~Branch&~MemWr) | (J&Opcode[0]) | IRQ_proc | EXP_proc;

  //赋值给MemWr, sw�?1
  assign MemWr=Opcode[5]&Opcode[3];  //Opcode==6'b101011

  //赋值给RegDst, 00写回$rd(R�?),01时写�?$rt(I�?), 10�?(jal, jalr, 中断)写回31号寄存器($ra), 11�?(中断, 异常)写回26号寄存器($k0)
  assign RegDst[0]=I | EXP_proc | IRQ_proc;
  assign RegDst[1]=Mem2Reg[1] | EXP_proc;

  //赋值给Sign, add, sub, addi, slti
  assign Sign=(R&(Funct[5:2]==4'b1000)&~Funct[0]) | (I&(Opcode[5:2]==4'b0010)&~Opcode[0]);

  //赋值给ALUOp
  assign ALUOp[2:0] = 
		(Opcode == 6'h00)? 3'b010: 
		(Opcode == 6'h04)? 3'b001: 
		(Opcode == 6'h0c)? 3'b100: 
		(Opcode == 6'h0a || Opcode == 6'h0b)? 3'b101: 
		3'b000;
	assign ALUOp[3] = Opcode[0];

  //赋值给ALUSrc1, sll, srl, sra时是1, 否则�?0
  assign ALUSrc1=R&~Funct[5]&~Funct[3];  //sll,srl,sra
  
  //赋值给ALUSrc2, 除了branch的I型指令是1
  assign ALUSrc2=I&~Branch; 

  //赋值给EXTOp, 和Sign一致
  assign EXTOp=Sign;

  //赋值给LUOp, lui指令�?1
  assign LUOp=(Opcode[3:1]==3'b111); //lui

endmodule