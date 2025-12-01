module stack (
    input clk,
    input [7:0] pcout,
    output reg [7:0] pila,
    input reset,
    input [4:0] cs
);

// Versión combinacional - comportamiento más similar al VHDL
always @(*) begin
    if (reset) begin
        pila = 8'b00000000;
    end else begin
        case (cs)
            5'b11100: pila = pcout;
            default: pila = pila;  // Mantiene el valor actual
        endcase
    end
end

endmodule