module lorenz_osc #(parameter n = 32, init = 32'b00000000000100000000000000000000)(
	input wire clk, rst,
	output wire [n-1:0] x,y,z
	);
	
	parameter rho = 32'b00000001110000000000000000000000;
	wire [n-1:0] xi,yi,zi,x_aux,y_aux,z_aux,evalx,evaly,evalz,aux1_x,aux2_x,aux1_y,aux2_y,aux3_y,aux1_z,aux2_z,aux3_z; 
	wire en;
	//dx = sigma*(y(2)-y(1))
	restador #(.n(n)) subs1 (.clk(clk), .rst(rst),.a(yi),.b(xi),.out1(aux1_x));//y(2)-y(1)	
	scm_10 scm1 (.clk(clk), .rst(rst),.X(aux1_x),.Y(evalx));//sigma*resta
	scm_0_01 scm2 (.clk(clk), .rst(rst),.X(evalx),.Y(aux2_x));//y(1)+h*resultado scm1
	adder #(.n(n)) adder1 (.clk(clk), .rst(rst),.a(aux2_x),.b(xi),.out1(x_aux));
	//dy=y(1)*(rho-y(3)) - y(2)	 
	restador #(.n(n)) subs2 (.clk(clk), .rst(rst),.a(rho),.b(zi),.out1(aux1_y));//y(2)-y(1)	 
	multiplier #(.n(n)) mult1 (.clk(clk), .rst(rst), .a(aux1_y), .b(xi), .out1(aux2_y));
	restador #(.n(n)) subs3 (.clk(clk), .rst(rst),.a(aux2_y),.b(yi),.out1(evaly));//y(2)-y(1)
	scm_0_01 scm3 (.clk(clk), .rst(rst),.X(evaly),.Y(aux3_y));//y(1)+h*resultado scm1
	adder #(.n(n)) adder2 (.clk(clk), .rst(rst),.a(aux3_y),.b(yi),.out1(y_aux)); 
	//
	multiplier #(.n(n)) mult2 (.clk(clk), .rst(rst), .a(xi), .b(yi), .out1(aux1_z));
	scm_2_66 scm4 (.clk(clk), .rst(rst),.X(zi),.Y(aux2_z));
	restador #(.n(n)) subs4 (.clk(clk), .rst(rst),.a(aux1_z),.b(aux2_z),.out1(evalz));
	scm_0_01 scm5 (.clk(clk), .rst(rst),.X(evalz),.Y(aux3_z));
	adder #(.n(n)) adder3 (.clk(clk), .rst(rst),.a(aux3_z),.b(xi),.out1(z_aux));
	//
	counter #(.n(1000)) counter1(.clk(clk),.rst(rst),.en(en));
	register #(.n(n),.INIT_VAL(init)) registrox (.clk(clk),.rst(rst),.en(en),.d(x_aux),.q(xi));
	register #(.n(n),.INIT_VAL(init)) registroy (.clk(clk),.rst(rst),.en(en),.d(y_aux),.q(yi));
	register #(.n(n),.INIT_VAL(init)) registroz (.clk(clk),.rst(rst),.en(en),.d(z_aux),.q(zi));
	
	assign x=xi,y=yi,z=zi;
endmodule													   