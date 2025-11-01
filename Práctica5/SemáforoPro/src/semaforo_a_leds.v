module semaforo_a_leds(
	input wire clk, rst, 
	input wire [2:0] semafIn,
	output reg [3:0] semafOut
	);
	//Diccionario de inputs
	localparam [2:0] VF = 3'b000;
	localparam [2:0] VFb = 3'b001;
	localparam [2:0] VbFb = 3'b010;
	localparam [2:0] V = 3'b011;
	localparam [2:0] Vb = 3'b100;
	localparam [2:0] AMA = 3'b101;
	localparam [2:0] ROJ = 3'b110;
	//Diccionario de outputs
	localparam [3:0] VerdeFlecha = 4'b1100;
	localparam [3:0] Verde = 4'b0100;
	localparam [3:0] Amarillo = 4'b0010;
	localparam [3:0] Rojo = 4'b0001;
	localparam [3:0] Off = 4'b0000;
	localparam [3:0] Test = 4'b1111;
	//registros y wires locales
	reg blink = 1;
	//Logica secuencial
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			semafOut = Off;
			blink = 1;
		end else begin
			case (semafIn)
				VF: semafOut = VerdeFlecha;
				VFb: begin
					if (blink) begin
						semafOut = VerdeFlecha;
						blink = ~blink;
					end else begin
						semafOut = Verde;
						blink = ~blink;
					end
				end
				VbFb: begin
					if (blink) begin
						semafOut = VerdeFlecha;
						blink = ~blink;
					end else begin
						semafOut = Off;
						blink = ~blink;
					end
				end
				V: semafOut = Verde;
				Vb: begin
					if (blink) begin
						semafOut = Verde;
						blink = ~blink;
					end else begin
						semafOut = Off;
						blink = ~blink;
					end
				end
				AMA: semafOut = Amarillo;
				ROJ: semafOut = Rojo;
				default semafOut = Test;
			endcase
		end
	end
endmodule
