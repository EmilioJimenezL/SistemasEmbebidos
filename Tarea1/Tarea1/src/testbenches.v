//Emilio Ivan Jimenez Lopez 179543
//----------------------IMPORTANTE----------------------------
//TESTBENCHES REALIZADOS CON APOYO DE HERRAMIENTAS DE INTELIGENCIA ARTIFICIAL
`timescale 1ns / 1ps

module corrimiento_paralelo_tb;

    // Entradas
	reg clk;
	reg rst;
    reg [7:0] data_in;
	reg control;

    // Salida
    wire [7:0] data_out;

    // Instancia del módulo bajo prueba (DUT)
    corrimiento_paralelo CorPar (  
		.clk(clk),
		.rst(rst),
		.control(control),
        .data_in(data_in),
        .data_out(data_out)
    );				
	
	initial clk = 0; always #10 clk = ~clk;

    // Secuencia de prueba
    initial begin
        // Inicialización
        rst = 0; control = 0; data_in = 8'b00000000;
		#10 control = 0; data_in = 8'b00001111;		
		#10
		#10 control = 1;
		#10 control = 0;
		#10 rst = 1; 
		#10 rst = 0;
        #10 $finish;
    end

endmodule		 

module tb_registro_paralelo_serie;

  reg clk, rst, start;
  reg [3:0] data_in;
  wire data_out, data_ready;

  registro_paralelo_serie dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .data_in(data_in),
    .data_out(data_out),
    .data_ready(data_ready)
  );

  // Generador de reloj
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Procedimiento de prueba
  initial begin
    $display("Inicio del testbench");
    $monitor("t=%0dns | rst=%b start=%b data_in=%b | data_out=%b data_ready=%b", $time, rst, start, data_in, data_out, data_ready);

    // Reset inicial
    rst = 1; start = 0; data_in = 4'b0000;
    #10 rst = 0;

    // Probar todas las combinaciones de entrada
    for (integer i = 0; i < 16; i = i + 1) begin
      data_in = i[3:0];
      start = 1;
      #10 start = 0;

      // Esperar 4 ciclos de reloj para transmisión
      #40;

      if (!data_ready)
        $display("? Error: data_ready no se activó para entrada %b", data_in);

      #10;
    end

    // Probar reset durante transmisión
    data_in = 4'b1010;
    start = 1;
    #10 start = 0;
    #10 rst = 1;
    #10 rst = 0;
    #20;

    $display("? Testbench finalizado");
    $finish;
  end

endmodule
