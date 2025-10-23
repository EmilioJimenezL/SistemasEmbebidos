module Puerta_Moore (
    input clk,         // Reloj principal (50MHz)
    input rst,         // Reset
    input sense,       // Sensor de presencia
    input obs,         // Sensor de obst�culo
    output reg [1:0] motor, // Salida del motor
    output reg alarm,        // Alarma
	output reg led_clk
);
	parameter MAX_SECONDS = 5;
	parameter MULTIPLIER = 50000000;
	parameter DIVISOR = MAX_SECONDS*MULTIPLIER; // 1Hz si clk = 50MHz
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
    parameter [2:0] Cerrado  = 3'b000,
                    Abriendo  = 3'b001,
                    Abierto = 3'b010,
					Cerrando = 3'b011,
					Alarma = 3'b100;

    reg [2:0] actual = Cerrado, siguiente;
    reg [3:0] open_counter = 0; // hasta 10
    reg waiting = 0;

    // L�gica secuencial
    always @(posedge clk_fsm or posedge rst) begin
        if (rst)
            actual <= Cerrado;
        else begin
				led_clk <= ~led_clk;
            actual <= siguiente;
        end
    end

    // L�gica combinacional
    always @(*) begin
		case (actual)
			Cerrado: begin
				motor = 2'b00;
				alarm = 0;	 
			end
			Abriendo: begin
				motor = 2'b01;
				alarm = 0;	 
			end
			Abierto: begin
				motor = 2'b00;
				alarm = 0;	 
			end			  
			Cerrando: begin
				motor = 2'b10;
				alarm = 0;	 
			end			  
			Alarma: begin
				motor = 2'b00;
				alarm = 1;	 
			end
		endcase
		
        case (actual)
            Cerrado: begin
                if (!sense && !obs)
                    siguiente = Cerrado;
                else if (!sense && obs)
                    siguiente = Cerrado;
                else if (sense && !obs)
					siguiente = Abriendo;
				else
					siguiente = Abriendo;
			end
			Abriendo: begin
				if (!sense && !obs)
                    siguiente = Abierto;
                else if (!sense && obs)
                    siguiente = Alarma;
                else if (sense && !obs)
					siguiente = Abierto;
				else
					siguiente = Alarma;
			end		

            Abierto: begin
                if (!sense && !obs)
                    siguiente = Cerrando;
                else if (!sense && obs)
                    siguiente = Abierto;
                else if (sense && !obs)
					siguiente = Abierto;
				else
					siguiente = Abierto;
            end

            Cerrando: begin
                if (!sense && !obs)
                    siguiente = Cerrado;
                else if (!sense && obs)
                    siguiente = Abriendo;
                else if (sense && !obs)
					siguiente = Cerrado;
				else
					siguiente = Abriendo;
            end	
			
			Alarma: begin
                if (!sense && !obs)
                    siguiente = Abriendo;
                else if (!sense && obs)
                    siguiente = Alarma;
                else if (sense && !obs)
					siguiente = Abriendo;
				else
					siguiente = Alarma;
            end

            default: begin
                siguiente = Cerrado;
                alarm = 0;
                motor = 2'b00;
            end
        endcase
    end

endmodule