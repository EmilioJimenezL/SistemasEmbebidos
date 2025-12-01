module rega5 (
    input [4:0] cs,
    input clk,
    input [3:0] datoin,
    input reset,
    output reg [3:0] a
);

reg [3:0] ares;

// Versión que replica el comportamiento del VHDL corregido
always @(posedge clk or posedge reset) begin
    if (reset) begin
        a <= 4'b0000;
        ares <= 4'b0000;
    end else begin
        case (cs)
            5'b10001: a <= datoin;     // Carga datoin en a
            5'b11100: ares <= a;       // Guarda a en ares (registro temporal)
            5'b11101: a <= ares;       // Carga ares en a
            default: ;                 // No hace nada
        endcase
    end
end

endmodule