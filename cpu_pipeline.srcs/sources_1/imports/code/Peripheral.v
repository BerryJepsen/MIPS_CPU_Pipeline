module Peripheral (RST,CLK,rd,wr,Address,Write_Data, Read_Data, IRQ, Digi_Tube);
input RST,CLK;
input rd,wr;
input [31:0] Address;
input [31:0] Write_Data;
output reg [31:0] Read_Data;
output reg [11:0]Digi_Tube;
output IRQ;

reg [31:0] display;
reg [3:0] display_partial;
reg [31:0] systick;
reg [7:0] led;
reg [31:0] TH,TL;
reg [2:0] TCON;
wire [6:0] digi_tube;
assign IRQ = TCON[2];

assign	digi_tube[6:0]=(display_partial==4'h0)?7'b1000000:
             (display_partial==4'h1)?7'b1111001:
             (display_partial==4'h2)?7'b0100100:
             (display_partial==4'h3)?7'b0110000:
             (display_partial==4'h4)?7'b0011001:
             (display_partial==4'h5)?7'b0010010:
             (display_partial==4'h6)?7'b0000010:
             (display_partial==4'h7)?7'b1111000:
             (display_partial==4'h8)?7'b0000000:
             (display_partial==4'h9)?7'b0010000:
			 (display_partial==4'ha)?7'b0001000:
			 (display_partial==4'hb)?7'b0000011:
			 (display_partial==4'hc)?7'b1000110:
			 (display_partial==4'hd)?7'b0100001:
			 (display_partial==4'he)?7'b0000110:
			 (display_partial==4'hf)? 7'b0001110:
			 7'b1111111;

always@(*) begin
	if(rd) begin
		case(Address)
			32'h40000000: Read_Data <= TH;			
			32'h40000004: Read_Data <= TL;			
			32'h40000008: Read_Data <= {29'b0,TCON};				
			32'h4000000C: Read_Data <= {24'b0,led};			
			32'h40000010: Read_Data <= {20'b0,Digi_Tube};
			32'h40000014: Read_Data <= systick;
			default: Read_Data <= 32'b0;
		endcase
	end
	else
		Read_Data <= 32'b0;
end

always@(posedge RST or posedge CLK) begin

    systick <= systick+1;

	if(RST) begin
		TH <= 32'b0;
		TL <= 32'b0;
		TCON <= 3'b0;
		Digi_Tube <= 12'b0;
		led <= 8'b0;
        systick<=32'b0;
		display<=32'b0;
		display_partial<=4'b0000 ;
	end
	else begin
		if(TCON[0]) begin	//计时状�??
			if(TL==32'hffffffff) begin
				TL <= TH;
				if(TCON[1])begin
				 	TCON[2] <= 1'b1;	//中断允许状�??
					//显示数字
					Digi_Tube[6:0]=digi_tube;
					case(Digi_Tube[11:8])
					4'b0001: display_partial<=display[3:0];
					4'b0010: display_partial<=display[7:4];
					4'b0100: display_partial<=display[11:8];
					4'b1000: display_partial<=display[15:12];
					default :display_partial<=4'b0000 ;
					endcase
					//显示位置
					case(Digi_Tube[11:8])
					4'b0000: Digi_Tube[11:8]<=4'b0001;
					4'b0001: Digi_Tube[11:8]<=4'b0010;
					4'b0010: Digi_Tube[11:8]<=4'b0100;
					4'b0100: Digi_Tube[11:8]<=4'b1000;
					4'b1000: Digi_Tube[11:8]<=4'b0001;
					default :Digi_Tube[11:8]<=4'b0000 ;
					endcase

				end

			end
			else TL <= TL + 1;
		end
		
		if(wr) begin
			case(Address)
				32'h40000000: TH <= Write_Data;
				32'h40000004: TL <= Write_Data;
				32'h40000008: TCON <= Write_Data[2:0];		
				32'h4000000C: led <= Write_Data[7:0];			
				32'h40000010: Digi_Tube <= Write_Data[11:0];
				32'h40000014: display <= Write_Data;
				default: ;
			endcase
		end

	end
end
endmodule