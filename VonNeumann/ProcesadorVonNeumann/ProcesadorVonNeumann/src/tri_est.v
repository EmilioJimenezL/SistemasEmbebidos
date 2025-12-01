module tri_est (
    input [4:0] cs,
    input clk,
    input [3:0] operacion,
    inout [3:0] datout
);

reg [3:0] datout_reg;
reg output_enable;

// Asignación tri-state
assign datout = output_enable ? datout_reg : 4'bZZZZ;

always @(posedge clk) begin
    case (cs)
        5'b11000: begin
            datout_reg <= operacion;  // Registra el valor
            output_enable <= 1'b1;    // Habilita salida
        end
        default: begin
            output_enable <= 1'b0;    // Alta impedancia
            // Nota: datout_reg mantiene su último valor
        end
    endcase
end

endmodule