module Puerta_Mealy (
    input clk,         // Reloj principal (50MHz)
    input rst,         // Reset
    input sense,       // Sensor de presencia
    input obs,         // Sensor de obst�culo
    output reg [1:0] motor, // Salida del motor
    output reg alarm, // Alarma
	output reg led_clk
);
	parameter SECONDS = 5;
	parameter SECONDS_MULTIPLIER = 50000000; // 1Hz si clk = 50MHz
	parameter DIVISOR = SECONDS*SECONDS_MULTIPLIER;

    // ========================
    // Divisor de frecuencia
    // ========================
    reg [$clog2(DIVISOR)-1:0] contador = 0;
    reg clk_fsm = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            contador <= 0;
            clk_fsm <= 0;
        end else begin
            if (contador == DIVISOR/2 - 1) begin
                clk_fsm <= ~clk_fsm;
                contador <= 0;
            end else begin
                contador <= contador + 1;
            end
        end
    end

    // Estados
    parameter [1:0] Cerrado  = 2'b00,
                    Abierto  = 2'b01,
                    Cerrando = 2'b10;

    reg [1:0] actual = Cerrado, siguiente;
    reg [3:0] open_counter = 0; // hasta 10
    reg waiting = 0;

    // L�gica secuencial
    always @(posedge clk_fsm or posedge rst) begin
        if (rst) begin
            actual <= Cerrado;
        end else begin
				led_clk <= ~led_clk;
				actual <= siguiente;
        end
    end

    // L�gica combinacional
    always @(*) begin
        case (actual)
            Cerrado: begin
                if (!sense && !obs) begin
                    siguiente = Cerrado;
					motor = 2'b00;
                    alarm = 0;
                end else if (!sense && obs) begin
                    siguiente = Cerrado; 
					motor = 2'b00;
                    alarm = 0;
                end else if (sense && !obs) begin
                    siguiente = Abierto;
					motor = 2'b01;
                    alarm = 0;
                end	else begin
					siguiente = Abierto;
					motor = 2'b01;
                    alarm = 0;
				end
            end

            Abierto: begin
                if (!sense && !obs) begin
                    siguiente = Cerrando;
					motor = 2'b10;
                    alarm = 0;
                end else if (!sense && obs) begin
                    siguiente = Abierto; 
					motor = 2'b00;
                    alarm = 0;
                end else if (sense && !obs) begin
                    siguiente = Abierto;
					motor = 2'b00;
                    alarm = 0;
                end	else begin
					siguiente = Abierto;
					motor = 2'b00;
                    alarm = 0;
				end
            end

            Cerrando: begin
                if (!sense && !obs) begin
                    siguiente = Cerrado;
					motor = 2'b10;
                    alarm = 0;
                end else if (!sense && obs) begin
                    siguiente = Abierto; 
					motor = 2'b01;
                    alarm = 1;
                end else if (sense && !obs) begin
                    siguiente = Cerrado;
					motor = 2'b10;
                    alarm = 0;
                end	else begin
					siguiente = Abierto;
					motor = 2'b01;
                    alarm = 1;
				end
            end

            default: begin
                siguiente = Cerrado;
                alarm = 0;
                motor = 2'b00;
            end
        endcase
    end

endmodule	 