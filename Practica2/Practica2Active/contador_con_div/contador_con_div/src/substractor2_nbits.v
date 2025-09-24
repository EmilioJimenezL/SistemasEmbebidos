module substractor2_nbits #(parameter n = 32)( 
	input wire clk,
	input wire rst,
	input wire [n-1:0] a,
	input wire [n-1:0] b,
	output reg [n-1:0] out1
	);
	
always @(posedge clk or posedge rst) begin
	if (!rst) begin
		out1 <= {n{1'b0}};
	end else begin
	out1 <= $signed(a) - $signed(b);
	end
end
endmodule