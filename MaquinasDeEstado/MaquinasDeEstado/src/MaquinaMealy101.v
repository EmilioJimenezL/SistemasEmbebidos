module mealy101	(  
	input clk,
	input rst,
	input in,
	output reg out
	);
	parameter [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
	reg [1:0] current_state = 2'b00, next_state;
	
	//Start of sequential logic
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			current_state <= S0;
		end else begin
		current_state <= next_state;
		end
	end	
	always @* begin
		case (current_state)
			S0: begin
				if (in == 1'b1) begin
					next_state = S1;   
					out = 1'b0;
				end else begin
					next_state = S0;
					out = 1'b0;
				end
			end
			S1: begin
				if (in == 1'b1) begin
					next_state = S1;   
					out = 1'b0;
				end else begin
					next_state = S2;
					out = 1'b0;
				end
			end
			S2: begin
				if (in == 1'b1) begin
					next_state = S1;   
					out = 1'b1;
				end else begin
					next_state = S0;
					out = 1'b0;
				end
			end
			endcase
		end
		
endmodule  

module moore101	(  
	input clk,
	input rst,
	input in,
	output reg out
	);
	parameter [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
	reg [1:0] current_state = 2'b00, next_state;
	
	//Start of sequential logic
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			current_state <= S0;
		end else begin
		current_state <= next_state;
		end
		if (current_state == S3) begin
			out = 1'b1;
		end else begin
			out = 1'b0;
		end
	end	
	always @* begin
		case (current_state)
			S0: begin
				if (in == 1'b1) begin
					next_state = S1;   
				end else begin
					next_state = S0;
				end
			end
			S1: begin
				if (in == 1'b1) begin
					next_state = S1;   
				end else begin
					next_state = S2;
				end
			end
			S2: begin
				if (in == 1'b1) begin
					next_state = S3;   
				end else begin
					next_state = S0;
				end
			end	 
			S3: begin
				if (in == 1'b1) begin
					next_state = S1;
				end else begin
					next_state = S2;
				end
			end
			endcase
		end
		
endmodule