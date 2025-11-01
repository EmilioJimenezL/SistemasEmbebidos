module semaforo(   
	input wire clk, rst,
	output wire [3:0] semafOut0, semafOut1, semafOut2, semafOut3,
	output wire [1:0] peatonOut
	);
	reg blink;
	wire [2:0] aux0, aux1, aux2, aux3;
	wire [1:0] aux4;
	wire pulse;
	
	freq_divider 	clk1_seg 	(.clk(clk), .rst(rst), .pulse(pulse));
	semaforo_logica logica_1 	(.clk(pulse), .rst(rst), .semaforo0(aux0), .semaforo1(aux1), .semaforo2(aux2), .semaforo3(aux3), .peatonal(aux4));
	semaforo_a_leds sem_a_led_0 (.clk(pulse), .rst(rst), .semafIn(aux0), .semafOut(semafOut0));
	semaforo_a_leds sem_a_led_1 (.clk(pulse), .rst(rst), .semafIn(aux1), .semafOut(semafOut1));
	semaforo_a_leds sem_a_led_2 (.clk(pulse), .rst(rst), .semafIn(aux2), .semafOut(semafOut2));
	semaforo_a_leds sem_a_led_3 (.clk(pulse), .rst(rst), .semafIn(aux3), .semafOut(semafOut3));
	peaton_a_leds 	ped_a_led 	(.clk(pulse), .rst(rst), .peatonalIn(aux4), .peatonalOut(peatonOut));
endmodule
