module Instruction_Memory(Address, Instruction);
	input [31:0] Address;
	output reg [31:0] Instruction;

	always @(*)
	    case (Address[9:2]) //256条指�??
			// j sort
			8'd1:    Instruction <= {32'h08000005};
			// lui $t0,16384
			8'd2:    Instruction <= {32'h3c084000};
			// addi $t1,$zero,3
			8'd3:    Instruction <= {32'h20090003};
			// sw $t1,8($t0)
			8'd4:    Instruction <= {32'had090008};
			// jr $k0
			8'd5:    Instruction <= {32'h03400008};

			//sort:
        	// add $s0, $zero, $zero
			8'd6:    Instruction <= {32'h00008020};
			// lw $s2, 0($s0)
			8'd7:    Instruction <= {32'h8e120000};
			// add &t0, $zero, $zero
			8'd8:    Instruction <= {32'h00004020};
			//outer:
			//addi $s0, $s0, 4#for(i=0; i<n; i++)
			8'd9:    Instruction <= {32'h22100004};
			// addi $t0, $t0, 1	#i++
			8'd10:    Instruction <= {32'h21080001};
			// add $t1,$t0, $zero	#j=i
			8'd11:    Instruction <= {32'h01004820};
			// add $t2,$s0, $zero
			8'd12:    Instruction <= {32'h02005020};
			// inner: 
            // subi $t2, $t2, 4#for(j=i-1; j>=0 && v[j] > v[j+1]; j--)
			8'd13:    Instruction <= {32'h20010004};
			8'd14:    Instruction <= {32'h01415022};

			// subi $t1,$t1,1
			8'd15:    Instruction <= {32'h20010001};
			8'd16:   Instruction <= {32'h01214822};

			// beqz  $t1,innerend
			8'd17:   Instruction <= {32'h11200006};
			// lw $t3,0($t2)
			8'd18:   Instruction <= {32'h8d4b0000};
			// lw $t4,4($t2)
			8'd19:   Instruction <= {32'h8d4c0004};
			// slt $t5,$t4,$t3
			8'd20:   Instruction <= {32'h018b682a};
			// beqz  $t5,inner
			8'd21:   Instruction <= {32'h11a0fff7};
			// jal swap
			8'd22:   Instruction <= {32'h0c000019};
			// j inner
			8'd23:   Instruction <= {32'h0800000c};
			//innerend: 
			//bne $t0 $s2 outer
			8'd24:   Instruction <= {32'h1512fff0};
			//j Display
			8'd25:   Instruction <= {32'h0800001c};
			//swap:
			//sw $t3,4($t2)
			8'd26:   Instruction <= {32'had4b0004};
			//sw $t4,0($t2)
			8'd27:   Instruction <= {32'had4c0000};
			//jr $ra
			8'd28:   Instruction <= {32'h03e00008};

			//Display:
			//lui $t0,16384
			8'd29:   Instruction <= {32'h3c084000};
			//lw $s0,20($t0)
			8'd30:   Instruction <= {32'h8d100014};
			//sw $s0,20($t0)
			8'd31:   Instruction <= {32'had100014};
			//addi $t1,$zero,-1000
			8'd32:   Instruction <= {32'h2009fc18};
			//sw $t1,0($t0)
			8'd33:   Instruction <= {32'had090000};
			//add $t1,$zero, $zero
			8'd34:   Instruction <= {32'h00004820};
			//addi $t1,$t1,-1
			8'd35:   Instruction <= {32'h2129ffff};
			//sw $t1,4($t0)
			8'd39:   Instruction <= {32'had090004};
			//addi $t1,$zero,3
			8'd40:   Instruction <= {32'h20090003};
			//sw $t1,8($t0)
			8'd41:   Instruction <= {32'had090008};
			//Loop:
			//beq $zero, $zero, Loop
			8'd42:   Instruction <= {32'h1000ffff};

        default: Instruction <= 32'h00000000;
		endcase
        
endmodule