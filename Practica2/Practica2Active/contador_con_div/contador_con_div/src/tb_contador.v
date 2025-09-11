module tb_contador_con_divisor;
    reg clk_50MHz = 0;
    reg rst = 1;
    reg en = 1;
    wire [3:0] count;

    contador_con_divisor uut (
        .clk(clk_50MHz),
        .rst(rst),
        .en(en),
        .count(count)
    );

    // Genera reloj de 50MHz (20ns periodo)
    always #1 clk_50MHz = ~clk_50MHz;

    initial begin
        $display("Iniciando simulación...");
        #10 rst = 0;

        // Simula por 1 segundo (50M ciclos)
        #1_000_000_000;
        $finish;
    end
endmodule
