module mili	(  
	input clk,
	input rst,
	input m,
	output reg s
	);
	parameter [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
	reg [1:0] actual, siguiente;
	
	//Start of sequential logic
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			actual <= S0;
		end else begin
		actual <= siguiente;
		end
	end	
	always @(*) begin
		case (actual)
			S0: begin
				if (m == 1'b0) begin
					siguiente = S0;   
					s = 1'b0;
				end else begin
					siguiente = S1;
					s = 1'b0;
				end
			end
			S1: begin
				if (m == 1'b0) begin
					siguiente = S2;   
					s = 1'b0;
				end else begin
					siguiente = S1;
					s = 1'b0;
				end
			end
			S2: begin
				if (m == 1'b0) begin
					siguiente = S0;   
					s = 1'b0;
				end else begin
					siguiente = S1;
					s = 1'b1;
				end
			end
			endcase
		end
		
endmodule

module mur (  
    input clk,
    input rst,
    input m,
    output reg s
    );
    parameter [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3=2'b11;
    reg [1:0] actual, siguiente;
    
 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            actual <= S0;
        end else begin
            actual <= siguiente;
        end
    end  

 
    always @(*) begin
        case (actual)
            S0: begin
                s = 1'b0;                 // salida por estado
                if (m == 1'b0) begin
                    siguiente = S0;   
                end else begin
                    siguiente = S1;
                end
            end
            S1: begin
                s = 1'b0;
                if (m == 1'b0) begin
                    siguiente = S2;   
                end else begin
                    siguiente = S1;
                end
            end
            S2: begin
                s = 1'b0;
                if (m == 1'b0) begin
                    siguiente = S0;   
                end else begin
                    siguiente = S3;  
                end
            end   
            S3: begin
                s = 1'b1;            
                if (m == 1'b0) begin
                    siguiente = S2;  
                end else begin
                    siguiente = S1;  
                end
            end
        endcase
    end
endmodule