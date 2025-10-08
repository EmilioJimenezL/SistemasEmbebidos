module multiplier #(parameter n = 32)( 
	input wire [n-1:0] a,
	input wire [n-1:0] b,
	output reg [n-1:0] out1
	);
	
	reg [n+n-1:0] aux;
	
	assign aux = $signed (a) * $signed (b);
	assign out1 = aux[55:24];
	
endmodule