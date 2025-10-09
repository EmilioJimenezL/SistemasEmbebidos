`timescale 1ns / 1ps

module register_tb;

    // Parámetros
    localparam n = 32;
    localparam INIT_VAL = 32'b00000000000100000000000000000000;

    // Señales
    reg clk;
    reg rst;
    reg en;
    reg [n-1:0] d;
    wire [n-1:0] q;

    // Instancia del módulo bajo prueba
    register #(.n(n), .INIT_VAL(INIT_VAL)) uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .d(d),
        .q(q)
    );

    // Generador de reloj: periodo de 10 ns
    initial clk = 0;
    always #5 clk = ~clk;

    // Secuencia de prueba
    initial begin
        $display("Inicio de simulación");
        $monitor("Tiempo=%0t | rst=%b en=%b d=%h q=%h", $time, rst, en, d, q);

        // Inicialización
        rst = 1; en = 0; d = 32'hDEADBEEF;
        #12;  // Espera más de un ciclo de reloj

        // Desactiva reset, espera sin enable
        rst = 0;
        #10;

        // Activa enable y carga nuevo dato
        en = 1; d = 32'hCAFEBABE;
        #10;

        // Cambia dato con enable activo
        d = 32'h12345678;
        #10;

        // Desactiva enable, dato no debe cambiar
        en = 0; d = 32'hFFFFFFFF;
        #10;

        // Activa reset nuevamente
        rst = 1;
        #8;

        // Finaliza simulación
        $finish;
    end

endmodule		

module tb_counter;

    // Parámetros
    parameter n = 11;

    // Señales
    reg clk;
    reg rst;
    wire en;

    // Instancia del módulo bajo prueba (DUT)
    counter #(.n(n)) dut (
        .clk(clk),
        .rst(rst),
        .en(en)
    );

    // Generador de reloj: periodo de 10 ns (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Estímulos
    initial begin
        $display("Inicio del testbench");
        $dumpfile("tb_counter.vcd");     // Para simulación con GTKWave
        $dumpvars(0, tb_counter);

        // Reset inicial
        rst = 1;
        #20;
        rst = 0;

        // Ejecutar por varios ciclos
        #500;

        // Finalizar simulación
        $display("Fin del testbench");
        $finish;
    end

endmodule
