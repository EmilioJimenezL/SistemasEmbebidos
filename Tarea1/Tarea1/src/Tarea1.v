module corrimiento_paralelo(					   
	input wire [7:0] data_in,	 
	input wire control,	 
	input wire clk,
	input wire rst,
	output reg [7:0] data_out
	);
	begin 		  
		always @(posedge clk or posedge rst) begin
			if (rst) begin
				assign data_out = 8'b0;
			end else begin
				case (control)
					1'b0: assign data_out = data_in;
					1'b1: assign data_out = data_out[7:1];
				endcase	
			end
		end
	end
endmodule		  

module corrimiento_serial(
	input wire [3:0] data_in,
	input wire control,
	input wire clk,
	input wire rst,
	output reg data_out
	output reg data_ready
	);
	reg [3:0] shifted;
	reg [1:0] count;
	begin
		always @(posedge clk or posedge rst) begin
			if (rst) begin
				assign data_out = 1'b0;
				assign shifted = 4'b0;
				assign data_ready = 1'b0;
			end else begin
				if (control) begin
					
				end else begin
					assign shifted = data_in[3:1];
				end
			end
		end
	end
endmodule