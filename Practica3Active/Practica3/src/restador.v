module restador #( // Parámetros: el numero de bits
	parameter n=32
	)(
	
	input clk, rst, // clk es 1 bit 
	input wire [n-1:0] a,b,	
	output reg [n-1:0] out1
	);
	
	always @(posedge clk or posedge rst)begin 
		if (rst) begin
			out1 = {n{1'b0}} ;
		end else begin
		out1= $signed(a) - $signed(b); 
	end	
end
endmodule 

	
	
	