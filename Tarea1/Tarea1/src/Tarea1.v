//Emilio Ivan Jimenez Lopez 179543	   
//LA DOCUMENTACION SE REALIZO PARCIALMENTE CON APOYO DE HERRAMIENTAS DE INTELIGENCIA ARTIFICIAL	

//Problema 1: Registro paralelo-paralelo
module corrimiento_paralelo(                       
    input wire [7:0] data_in,     // Entrada paralela de 8 bits
    input wire control,           // Control: 0 = carga, 1 = corrimiento
    input wire clk,               // Señal de reloj
    input wire rst,               // Reset asíncrono
    output reg [7:0] data_out     // Salida de 8 bits
);        

    // Activacion del ciclo por flanco positivo de reloj o estimulo reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reinicia la salida a cero
            data_out <= 8'b0;
        end else begin
            // Selección de operación según control
            case (control)
                1'b0: begin
                    // Carga directa del dato de entrada
                    data_out <= data_in;
                end
                1'b1: begin
                    // Corrimiento lógico a la derecha
                    data_out <= data_out[7:1];
                end
            endcase 
        end
    end
endmodule         

//Problema 2: Registro paralelo-serial
module registro_paralelo_serie (
    input wire clk,              // Señal de reloj
    input wire rst,              // Reset asíncrono
    input wire start,            // Señal de inicio de conversión
    input wire [3:0] data_in,    // Entrada paralela de 4 bits
    output reg data_out,         // Salida serial de 1 bit
    output reg data_ready        // Señal de conversión completa
);

    // Registros internos
    reg [3:0] shift_reg;         // Registro de desplazamiento
    reg [2:0] bit_count;         // Contador de bits enviados
    reg sending;                 // Estado de transmisión

    // Ciclo activado por flanco positivo del reloj o estimulo reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reinicio de todos los registros
            shift_reg <= 4'b0000;
            bit_count <= 3'b000;
            data_out <= 1'b0;
            data_ready <= 1'b0;
            sending <= 1'b0;
        end else begin
            if (start && !sending) begin
                // Inicio de transmisión: carga de datos
                shift_reg <= data_in;
                bit_count <= 3'b000;
                sending <= 1'b1;
                data_ready <= 1'b0;
            end else if (sending) begin
                // Transmision bit a bit
                data_out <= shift_reg[bit_count];
                bit_count <= bit_count + 1;

                if (bit_count == 3) begin
                    // Ultimo bit transmitido
                    sending <= 1'b0;
                    data_ready <= 1'b1;
                end
            end else begin
                // Limpieza de registro de listo cuando no se transmite
                data_ready <= 1'b0;
            end
        end
    end
endmodule
