module counter #(
	parameter n=11
	)(
	input wire clk, rst, 
	output reg en
	);
	
	integer count; // variable de la cuenta 
	
	always @(posedge clk or posedge rst) begin 
		if (rst) begin
			count = 0;
			en = 1'b0;
		end else begin 
		if (count == n ) begin 
			en = 1'b1;// porque ya está mi cuenta maxima y quiero hacer una nueva iteracion 	
			count = 0;
		end else begin 		   
		en = 1'b0;
		count = count +1;
		
	end
end  
end
endmodule 


	