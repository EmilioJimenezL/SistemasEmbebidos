module pc (
    input clk,
    input reset,
    input [7:0] pcontrol,
    input [7:0] pila,
    input [4:0] cs,
    output reg [7:0] pcout
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pcout <= 8'b00000000;
    end else begin
        case (cs)
            5'b11110: pcout <= pcontrol;  // Saltar a pcontrol
            5'b11111: pcout <= pcout + 1; // ? INCREMENTAR - COMO VHDL ORIGINAL
            5'b11101: pcout <= pila;      // Saltar a pila
            default: pcout <= pcout;      // Mantener valor
        endcase
    end
end

endmodule