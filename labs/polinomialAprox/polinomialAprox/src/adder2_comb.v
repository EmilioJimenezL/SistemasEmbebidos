module adder2_comb #(parameter n = 32)(
	input wire [n-1:0] a,
	input wire [n-1:0] b,
	output reg [n-1:0] out
	);					   
	
	assign out = $signed (a) + $signed (b);
	
endmodule