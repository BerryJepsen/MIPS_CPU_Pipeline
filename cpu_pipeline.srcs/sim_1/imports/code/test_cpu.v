`timescale 1ns / 1ps
module test_cpu();
	
	reg RST;
	reg CLK;
	wire [11:0] Digi;

CPU_Pipeline cpu_pipeline(.CLK(CLK),.RST(RST),.Digi_Tube(Digi));

	initial begin
		RST = 1;
		CLK = 0;
		#50 RST = 0;
	end
	
	always #50 CLK = ~CLK;
		
endmodule
