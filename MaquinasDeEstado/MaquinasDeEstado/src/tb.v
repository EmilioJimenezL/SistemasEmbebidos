`timescale 1ns/1ps

module tbMealy;
	reg clk;
	reg rst;
	reg in;
	wire out; 
	
	mealy101 mealy1 (.clk(clk), .rst(rst), .in(in), .out(out));		
	
	always #10 clk = ~clk;
		
	initial begin
		clk = 0;
		rst = 0;
		in = 0;
		
		#10 in = 1;	 
		#20 in = 0;
		#20 in = 1;	
		
		#20 in = 0;	 
		#20 in = 0;
		#20 in = 0;	
		
		#20 in = 1;	 
		#20 in = 0;
		#20 in = 1;
		
		#20 in = 0;	 
		#20 in = 0;
		#20 in = 0;
		$finish;
	end
endmodule

module tbMoore;
	reg clk;
	reg rst;
	reg in;
	wire out; 
	
	moore101 moore1 (.clk(clk), .rst(rst), .in(in), .out(out));		
	
	always #10 clk = ~clk;
		
	initial begin
		clk = 0;
		rst = 0;
		in = 0;	 
		
		#10 in = 1;	 
		#20 in = 0;
		#20 in = 1;	
		
		#20 in = 0;	 
		#20 in = 0;
		#20 in = 0;	
		
		#20 in = 1;	 
		#20 in = 0;
		#20 in = 1;
		
		#20 in = 0;	 
		#20 in = 0;
		#20 in = 0;
		$finish;
	end
endmodule	

module tb;
	reg clk;
	reg rst;
	reg m;
	wire outMealy;
	wire outMoore;
	
	mili mili_101 (.clk(clk), .rst(rst), .m(m), .s(outMealy));		
	mur mur_101 (.clk(clk), .rst(rst), .m(m), .s(outMoore));

	always #10 clk = ~clk;
		
	initial begin
		clk = 0;
		rst = 0;
		m = 0;	 
		
		#5 rst = 1;
		#5 rst = 0;
		
		//Correcta
		#10 m = 1;	 
		#20 m = 0;
		#20 m = 1;	 
		//Incorrecta
		#20 m = 1;	 
		#20 m = 0;
		#20 m = 0;	
		
		#20 m = 0;	 
		#20 m = 0;
		#20 m = 0;
		
		//Correcta
		#20 m = 1;	 
		#20 m = 0;
		#20 m = 1;	 
		
		#20 m = 0;	 
		#20 m = 0;
		#20 m = 1;
		$finish;
	end
endmodule