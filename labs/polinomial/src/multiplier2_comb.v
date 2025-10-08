module adder2_comb #(parameter n = 32)(
	input wire [n-1:0] a,
	input wire [n-1:0] b,
	output reg [n-1:0] out,
	);	
	
	reg [n+n-1:0] aux;
	
	assign aux = $signed (a) * $signed (b);	  
	assign out = aux[55:24];
	
endmodule
