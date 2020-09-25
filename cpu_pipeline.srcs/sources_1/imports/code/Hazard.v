module Hazard(
  RST, CLK,
  Branch,  Branch_take,  Jump, 
  EX_MemRd,EX_RegWr,
  EX_Rt, EX_Rd,
  EX_RegDst0,
  ID_Rs, ID_Rt,
  IRQ, stall, flush
);

input RST;
input CLK;
input Branch;
input EX_MemRd;
input [4:0]EX_Rt;
input [4:0]EX_Rd;
input EX_RegWr;
input EX_RegDst0;
input [4:0]ID_Rs;
input [4:0]ID_Rt;
input Branch_take;
input Jump;
input IRQ;

output  stall; // stall指令
output  flush; // 清空IF/ID寄存�?


wire flush_tmp, irq_flush;
reg pre_irq;

assign stall=(RST | (Jump)) ? 0:
                    //load-use冒险
                    (EX_MemRd & ( (EX_Rt==ID_Rs) || (EX_Rt==ID_Rt) ) ) ? 1: 
                    //reg-branch冒险
                    (Branch  & (EX_RegWr && (
                         ((ID_Rt==EX_Rt) &&  EX_RegDst0) || 
                         ((ID_Rt==EX_Rd) && ~EX_RegDst0) ||
                         ((ID_Rs==EX_Rt) &&  EX_RegDst0) || 
                         ((ID_Rs==EX_Rd) && ~EX_RegDst0)) 
                      ) ) ? 1:0;

assign flush_tmp=(RST | (EX_MemRd && ( (EX_Rt==ID_Rs) || (EX_Rt==ID_Rt) ) )) ? 0:
                                        //jump
                                        (Jump) ? 1:
                                        //branch
                                        ( (Branch_take) & ~(EX_RegWr && (
                                             ((ID_Rt==EX_Rt) &&  EX_RegDst0) || 
                                             ((ID_Rt==EX_Rd) && ~EX_RegDst0) ||
                                              ((ID_Rs==EX_Rt) &&  EX_RegDst0) || 
                                             ((ID_Rs==EX_Rd) && ~EX_RegDst0) ) 
                                        ) ) ? 1:0;

assign irq_flush = (IRQ && ~pre_irq);

assign flush = flush_tmp || irq_flush;

always @(posedge CLK or posedge RST) begin
  if(RST)  begin
    pre_irq <= 0;
  end
  else begin
    pre_irq <= IRQ;  
  end
end

endmodule