// Registro de 32 bits con condiciones iniciales
// Formato: 1 bit signo, 11 bits enteros, 20 bits fraccionarios

module register #(
    parameter n = 32,
    parameter INIT_VAL = 32'b00000000000100000000000000000000  // Valor inicial
)(
    input wire clk,
    input wire rst,   // Reset asíncrono negativo
    input wire en,    // Enable
    input wire [n-1:0] d,  // Entrada de datos tipo D
    output reg [n-1:0] q   // Salida del registro
);

    // Lógica secuencial con reset asíncrono
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= INIT_VAL;  // Carga valor inicial
        else if (en)
            q <= d;         // Carga nuevo dato si enable está activo
    end

endmodule
