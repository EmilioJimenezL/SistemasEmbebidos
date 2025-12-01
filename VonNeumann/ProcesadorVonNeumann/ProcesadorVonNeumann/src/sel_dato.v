module sel_dato (
    input clk,
    input [3:0] datout,
    output reg [3:0] datoin,
    input [3:0] operacion,
    input [4:0] cs
);

reg [3:0] datoin_next;

// Lógica combinacional sensible a cambios
always @(*) begin
    case (cs)
        5'b10110: datoin_next = datout;
        5'b10101: datoin_next = operacion;
        default: datoin_next = datoin;  // Mantiene valor actual
    endcase
end

// Registro en flanco de reloj
always @(posedge clk) begin
    datoin <= datoin_next;
end

endmodule