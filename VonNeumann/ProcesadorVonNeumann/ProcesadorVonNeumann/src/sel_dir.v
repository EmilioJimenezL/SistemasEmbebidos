module sel_dir (
    input [7:0] pcout,
    input clk,
    input [7:0] ix,
    output reg [7:0] direccion,
    input [4:0] cs
);

// Versión que incluye sensibilidad a cambios en es (aunque no se use en flanco)
reg [7:0] direccion_next;

always @(*) begin
    case (cs)
        5'b11000: direccion_next = ix;
        default: direccion_next = pcout;
    endcase
end

always @(posedge clk) begin
    direccion <= direccion_next;
end

endmodule