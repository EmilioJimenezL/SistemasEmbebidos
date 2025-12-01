module alu (
    input clk,
    input [3:0] a,
    input [3:0] b,
    input [4:0] cs,
    output reg [3:0] operacion,
    output reg [3:0] re
);

reg [1:0] cl;
reg Cout;

always @(posedge clk) begin
    case (cs)
        5'b00001: begin // Suma
            operacion <= a + b;
            cl[0] <= (a[1] & b[1]) | ((a[0] & b[0]) & (a[1] ^ b[1]));
            cl[1] <= (a[2] & b[2]) | (cl[0] & (a[2] ^ b[2]));
            Cout <= (a[3] & b[3]) | (cl[1] & (a[3] ^ b[3]));
        end
        
        5'b00010: begin // Resta
            operacion <= a - b;
            if (a >= b) begin
                Cout <= 1'b1;
                cl[0] <= 1'b1;
            end else begin
                Cout <= 1'b0;
                cl[0] <= 1'b0;
            end
        end
        
        5'b00011: begin // AND
            operacion <= a & b;
            Cout <= 1'b0;
            cl[0] <= 1'b0;
        end
        
        5'b00100: begin // OR
            operacion <= a | b;
            Cout <= 1'b0;
            cl[0] <= 1'b0;
        end
        
        5'b00101: begin // NOT A
            operacion <= ~a;
            Cout <= 1'b0;
            cl[0] <= 1'b0;
        end
        
        5'b00110: begin // XOR
            operacion <= a ^ b;
            Cout <= 1'b0;
            cl[0] <= 1'b0;
        end
        
        5'b00111: begin // AND con 1111 (mantener A)
            operacion <= a & 4'b1111;
            // Cout y cl mantienen su valor actual
        end
        
        default: begin
            // No cambia los registros
        end
    endcase
    
    // Cálculo de flags
    re[3] <= Cout ^ cl[1];        // Overflow
    re[2] <= ~(operacion[3] | operacion[2] | 
               operacion[1] | operacion[0]); // Zero
    re[1] <= operacion[3];        // Sign
    re[0] <= Cout;                // Carry
end

endmodule