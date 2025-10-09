// mira lo quye te pide en el pdf 
// cuando multiplicas tu salida es el doble de bits 
module multiplier #( // Parámetros: el numero de bits
	parameter n=32
	)(
	
	input clk, rst, // clk es 1 bit 
	input wire [n-1:0] a,b,
	output reg [n-1:0] out1
	);
	
	reg [n+n-1:0] aux;
	always @(posedge clk or posedge rst)begin 
		if (rst) begin	  
			aux = {n{1'b0}}; // ponlo igual a cero
			out1 = {n{1'b0}} ;	 
			
		end else begin
		aux = $signed(a) * $signed(b); 
		out1 = aux[51:20];
	end	
end
endmodule 

	
	
	