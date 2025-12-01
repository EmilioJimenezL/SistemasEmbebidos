`timescale 1ns/1ps

module fibonacci_tb;

    reg clk;
    reg reset;
    reg [1:0] irq;

    wire vma;
    wire rw;
    wire [3:0] datout;

    // Instancia del procesador
    procesador uut (
        .clk(clk),
        .reset(reset),
        .irq(irq),
        .vma(vma),
        .datout(datout),
        .rw(rw)
    );

    // Generador de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Estímulos
    initial begin
        $dumpfile("fibonacci_tb.vcd");
        $dumpvars(0, fibonacci_tb);

        reset = 1; irq = 0;
        #20 reset = 0;

        // Simulación de programa Fibonacci
        // Inicializar A=0, B=1
        uut.regA.a = 4'b0000;
        uut.regB.b = 4'b0001;

        // Calcular 8 términos
        repeat (8) begin
            #10; // esperar ciclo
            $display("t=%0t | A=%b B=%b re=%b datout=%b",
                     $time, uut.a, uut.b, uut.re, datout);

            // Rotar valores: A <- B, B <- re
            uut.regA.a = uut.b;
            uut.regB.b = uut.re;
        end

        #100 $finish;
    end

endmodule
