module indice (
    input clk,
    input [7:0] pcontrol,
    input [4:0] cs,
    input reset,
    output reg [7:0] ix
);

// Versión combinacional - comportamiento más similar al VHDL
always @(*) begin
    if (reset) begin
        ix = 8'b00000000;
    end else begin
        case (cs)
            5'b11010: ix = pcontrol;
            5'b11011: ix = ix + 1;  // CUIDADO: Esto crea un bucle combinatorio
            default: ix = ix;       // Mantiene el valor actual
        endcase
    end
end

endmodule