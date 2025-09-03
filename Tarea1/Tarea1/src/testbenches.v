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
