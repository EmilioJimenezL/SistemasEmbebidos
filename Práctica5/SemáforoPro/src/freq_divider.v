module freq_divider(
	input wire clk,
	input wire rst,
	output reg pulse
	);		 
	localparam MAX_COUNT = 50000000;
	reg[31:0] counter;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			counter <= 0;
			pulse <= 0;
		end else begin
			if (counter >= MAX_COUNT-1) begin	 
				counter <= 0;
				pulse <= 1;
			end else begin 
				counter <= counter+1;
				pulse <= 0;
			end
		end
	end
endmodule