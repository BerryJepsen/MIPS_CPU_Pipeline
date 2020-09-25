module PC_Controller(CLK, PC_Rst, stall, Branch_take, PC_Src,  PC_Forward, PC_Branch,  PC_j, PC_jr,  MEM_PC, PC_Out
);

input CLK, PC_Rst, stall, Branch_take ,PC_Forward;
input[31:0] PC_Branch,PC_jr;
input [31:0] MEM_PC; //注意不修改最高位PC
input[25:0]PC_j;
input[2:0] PC_Src;

output [31:0]PC_Out;//输出的PC�?

reg[31:0] PC_Register;//PC寄存�?
wire[31:0] PC;//放入PC寄存器的�?
wire[31:0] PC_temp;
assign PC_temp=(PC_Rst)?32'h00000000: PC_Register + 4;

assign  PC_Out = {PC_Register[31],PC_temp[30:0]}; //保持PC_Register[31]不变
assign PC= stall? PC_Register: //stall, 优先级较�?
                  (PC_Src==4) ?  32'h80000004: //Interrupt
                  (PC_Src==5) ?  32'h80000008: //Exception
                  (PC_Forward==1) ? {1'b0, MEM_PC[30:0]} : //bypass
                  (PC_Src==0) ? PC_Out : //+4
                  (PC_Src==1 & Branch_take==1) ? {PC_Register[31], PC_Branch[30:0]} : //branch
                  (PC_Src==2) ?  {PC_Register[31:28], PC_j, 2'b0}: //j, jal
                  (PC_Src==3) ?  PC_jr: //jr
                  PC_Out;  //default

always @(posedge CLK or posedge PC_Rst) begin
    if(PC_Rst)
        PC_Register<=32'h00000000; //reset
    else 
        PC_Register<=PC; //refresh
end

endmodule