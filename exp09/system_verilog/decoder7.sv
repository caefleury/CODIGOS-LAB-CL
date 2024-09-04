module decoder7 (In, Out);
	input [3:0] In;
	output reg[6:0] Out;

	always @(*)	
		case (In)
			4'b0000 : Out = ~7'b1111110; 
			4'b0001 : Out = ~7'b0110000;
			4'b0010 : Out = ~7'b1101101; 
			4'b0011 : Out = ~7'b1111001; 

			4'b0100 : Out = ~7'b0110011; 
			4'b0101 : Out = ~7'b1011011; 
			4'b0110 : Out = ~7'b1011111; 
			4'b0111 : Out = ~7'b1110000; 
 
			4'b1000 : Out = ~7'b1111111; 
			4'b1001 : Out = ~7'b1111011;
			4'b1010 : Out = ~7'b1110111; 
			4'b1011 : Out = ~7'b0011111; 

			4'b1100 : Out = ~7'b1001110; 
			4'b1101 : Out = ~7'b0111101; 
			4'b1110 : Out = ~7'b1001111; 
			4'b1111 : Out = ~7'b1000111; 
	
			default : Out = ~7'b0000000;
		endcase
		
endmodule