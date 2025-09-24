`timescale 1ns/1ps
module tb_adder2_nbits();
	parameter n=32;
	reg clk;
	reg rst;  
	reg [n-1:0] a;
	reg [n-1:0] b;
	wire [n-1:0] out1;
	
	substractor2_nbits #(.n(n)) adder1(
	.clk(clk),
	.rst(rst),
	.a(a),
	.b(b),
	.out1(out1));
	
	always #10 clk = ~clk;
		
		initial begin
			clk = 0;
			rst = 1;
			a = 0;
			b = 0;
			
			//apply rst
			#15 rst = 0;
			#30 rst = 1;
			
			//sum 1
			
			#20;
			a = 32'b00100000000000000000000000000000;	  
			b = 32'b00100000000000000000000000000000;	 
			#20;
			
			//sum 2	
			
			#20;
			a = 32'b00100000000000000000000000000000;	  
			b = 32'b00100000000000000000000000000000;	 
			#20;
			
			//sum 3	 
			
			#20;
			a = 32'b11110000000000000000000000000000;	  
			b = 32'b11110000000000000000000000000000;	 
			#20;	 
			
			#50;
			$finish;   
		end
	endmodule
	
			