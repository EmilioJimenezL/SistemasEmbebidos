module semaforo_logica(	
	input wire clk, rst,
	output reg [2:0] semaforo0, semaforo1, semaforo2, semaforo3,
	output reg [1:0] peatonal
	);
	//Estados
	localparam [4:0] S0 = 5'b00000; 
	localparam [4:0] S1 = 5'b00001;
	localparam [4:0] S2 = 5'b00010; 
	localparam [4:0] S3 = 5'b00011;
	localparam [4:0] S4 = 5'b00100; 
	localparam [4:0] S5 = 5'b00101;
	localparam [4:0] S6 = 5'b00110; 
	localparam [4:0] S7 = 5'b00111; 
	localparam [4:0] S8 = 5'b01000; 
	localparam [4:0] S9 = 5'b01001;
	localparam [4:0] S10 = 5'b01010; 
	localparam [4:0] S11 = 5'b01011;
	localparam [4:0] S12 = 5'b01100;
   localparam [4:0] S13 = 5'b01101;
   localparam [4:0] S14 = 5'b01110;
   localparam [4:0] S15 = 5'b01111;
   localparam [4:0] S16 = 5'b10000;
   localparam [4:0] S17 = 5'b10001;
   localparam [4:0] S18 = 5'b10010;
   localparam [4:0] S19 = 5'b10011;
	//Luces
	localparam [2:0] VF = 3'b000;
	localparam [2:0] VFb = 3'b001;
	localparam [2:0] VbFb = 3'b010;
	localparam [2:0] V = 3'b011;
	localparam [2:0] Vb = 3'b100;
	localparam [2:0] AMA = 3'b101;
	localparam [2:0] ROJ = 3'b110;
	localparam [1:0] VER_P = 2'b00;
	localparam [1:0] VER_Pb = 2'b01;
	localparam [1:0] ROJ_P = 2'b10;	
	//Registros de current y next states
	reg [31:0] counter, time_out;
	reg [4:0]  actual, siguiente;
	//Logica secuencial
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			actual <= S0;
			counter <= 0;
		end else begin
			if (counter >= time_out) begin
			actual <= siguiente;
			counter <= 0;
			end else begin
			counter <= counter +1;
			end
		end
	end
	//Logica combinacional de timeout
	always @(*)begin 
		case (actual)
			S0: time_out = 10;
			S1: time_out = 5;
			S2: time_out = 10;
			S3: time_out = 5;
			S4: time_out = 5;
			S5: time_out = 10;
			S6: time_out = 5;
			S7: time_out = 5;
			S8: time_out = 10;
			S9: time_out = 5;
			S10: time_out = 10;
			S11: time_out = 5;	 
			S12: time_out = 10;
			S13: time_out = 5;
			S14: time_out = 5;
			S15: time_out = 10;
			S16: time_out = 5;
			S17: time_out = 5;
			S18: time_out = 10;
			S19: time_out = 5;
			default: time_out = 30;
		endcase
	end

	//Logica combinacional de estados
	always @(*) begin
    	case (actual)
        	S0:  siguiente = S1;
        	S1:  siguiente = S2;
        	S2:  siguiente = S3;
	      S3:  siguiente = S4;
	      S4:  siguiente = S5;
	      S5:  siguiente = S6;
	      S6:  siguiente = S7;
	      S7:  siguiente = S8;
	      S8:  siguiente = S9;
	      S9:  siguiente = S10;
	      S10: siguiente = S11;
	      S11: siguiente = S12;
	      S12: siguiente = S13;
	      S13: siguiente = S14;
	      S14: siguiente = S15;
	      S15: siguiente = S16;
	      S16: siguiente = S17;
	      S17: siguiente = S18;
	      S18: siguiente = S19;
	      S19: siguiente = S0;
			default siguiente = S0;
    	endcase
	end
	//Logica combinacional de luces
	always @(*) begin
		case (actual)
			S0: begin
				semaforo0 = VF;
				semaforo1 = ROJ;
				semaforo2 = ROJ;
				semaforo3 = ROJ;
				peatonal = ROJ_P;
			end
			S1: begin
				semaforo0 = VFb;
				semaforo1 = ROJ;
				semaforo2 = ROJ;
				semaforo3 = ROJ;
				peatonal = ROJ_P;
			end
			S2: begin
				semaforo0 = V;
				semaforo1 = V;
				semaforo2 = ROJ;
				semaforo3 = ROJ;
				peatonal = ROJ_P;
			end
			S3: begin
				semaforo0 = Vb;
				semaforo1 = V;
				semaforo2 = ROJ;
				semaforo3 = ROJ;
				peatonal = ROJ_P;
			end
			S4: begin
				semaforo0 = AMA;
				semaforo1 = V;
				semaforo2 = ROJ;
				semaforo3 = ROJ;
				peatonal = ROJ_P;
			end
			S5: begin
				semaforo0 = ROJ;
				semaforo1 = VF;
				semaforo2 = ROJ;
				semaforo3 = ROJ;
				peatonal = ROJ_P;
			end
			S6: begin
				semaforo0 = ROJ;
				semaforo1 = VbFb;
				semaforo2 = ROJ;
				semaforo3 = ROJ;
				peatonal = ROJ_P;
			end
			S7: begin
				semaforo0 = ROJ;
				semaforo1 = AMA;
				semaforo2 = ROJ;
				semaforo3 = ROJ;
				peatonal = ROJ_P;
			end
			S8: begin
				semaforo0 = ROJ;
				semaforo1 = ROJ;
				semaforo2 = ROJ;
				semaforo3 = ROJ;
				peatonal = VER_P;
			end
			S9: begin
				semaforo0 = ROJ;
				semaforo1 = ROJ;
				semaforo2 = ROJ;
				semaforo3 = ROJ;
				peatonal = VER_Pb;
			end
			S10: begin
				semaforo0 = ROJ;
				semaforo1 = ROJ;
				semaforo2 = VF;
				semaforo3 = ROJ;
				peatonal = ROJ_P;
			end
			S11: begin
				semaforo0 = ROJ;
				semaforo1 = ROJ;
				semaforo2 = VFb;
				semaforo3 = ROJ;
				peatonal = ROJ_P;
			end
			S12: begin
				semaforo0 = ROJ;
				semaforo1 = ROJ;
				semaforo2 = V;
				semaforo3 = V;
				peatonal = ROJ_P;
			end
			S13: begin
				semaforo0 = ROJ;
				semaforo1 = ROJ;
				semaforo2 = Vb;
				semaforo3 = V;
				peatonal = ROJ_P;
			end
			S14: begin
				semaforo0 = ROJ;
				semaforo1 = ROJ;
				semaforo2 = AMA;
				semaforo3 = V;
				peatonal = ROJ_P;
			end
			S15: begin
				semaforo0 = ROJ;
				semaforo1 = ROJ;
				semaforo2 = ROJ;
				semaforo3 = VF;
				peatonal = ROJ_P;
			end
			S16: begin
				semaforo0 = ROJ;
				semaforo1 = ROJ;
				semaforo2 = ROJ;
				semaforo3 = VbFb;
				peatonal = ROJ_P;
			end
			S17: begin
				semaforo0 = ROJ;
				semaforo1 = ROJ;
				semaforo2 = ROJ;
				semaforo3 = AMA;
				peatonal = ROJ_P;
			end
			S18: begin
				semaforo0 = ROJ;
				semaforo1 = ROJ;
				semaforo2 = ROJ;
				semaforo3 = ROJ;
				peatonal = VER_P;
			end
			S19: begin
				semaforo0 = ROJ;
				semaforo1 = ROJ;
				semaforo2 = ROJ;
				semaforo3 = ROJ;
				peatonal = VER_Pb;
			end
			default begin
				semaforo0 = ROJ;
				semaforo1 = ROJ;
				semaforo2 = ROJ;
				semaforo3 = ROJ;
				peatonal = ROJ_P;
			end
		endcase
	end
	
	
endmodule