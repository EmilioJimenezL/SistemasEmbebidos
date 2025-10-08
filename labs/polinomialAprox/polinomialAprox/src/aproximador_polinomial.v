module aproximador_polinomial #(parameter n=32)
	(
	input wire [n-1:0] y,
	output reg [n-1:0] out1
	);					   
	
	parameter uno = 32'b00000001000000000000000000000000;	  
	wire [n-1:0] aux1, aux2, aux3, aux4, aux5, aux6, aux7, aux8, aux9; 
	
	adder2_comb adder1(.a(uno),.b(y),.out(aux1));
	multiplier2 mult1(.a(y),.b(y),.out(aux2));	  
	scm_0_5 scm1 (.X(aux2), .Y(aux3));
	adder2_comb adder2(.a(aux1), .b(aux3), .out(aux4));
	multiplier2 mult2(.a(y), .b(aux2), .out(aux5));		
	scm_0_1666 scm2 (.X(aux5), .Y(aux6));
	adder2_comb adder3(.a(aux4), .b(aux6), .out(aux7));  
	multiplier2 mult3(.a(y), .b(aux5), .out(aux8));
	scm_0_0416 scm3 (.X(aux8), .Y(aux9));
	adder2_comb adder4(.a(aux7), .b(aux9), .out(out1)); 	
endmodule
