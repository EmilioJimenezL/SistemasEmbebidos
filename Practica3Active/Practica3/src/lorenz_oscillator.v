module lorenz_osc #(
    parameter n = 32,
    parameter init = 32'b00000000000100000000000000000000
)(
    input wire clk, rst,
    output wire [n-1:0] x, y, z
);

    // Parámetro del sistema
    parameter rho = 32'b00000001110000000000000000000000;

    // Señales internas
    wire [n-1:0] xi, yi, zi;
    wire [n-1:0] x_aux, y_aux, z_aux;
    wire [n-1:0] evalx, evaly, evalz;
    wire [n-1:0] aux1_x, aux2_x;
    wire [n-1:0] aux1_y, aux2_y, aux3_y;
    wire [n-1:0] aux1_z, aux2_z, aux3_z;
    wire en;

    // --- Cálculo de dx = sigma * (y - x) ---
    restador #(.n(n)) subs1 (
        .clk(clk), .rst(rst),
        .a(yi), .b(xi),
        .out1(aux1_x) // aux1_x = yi - xi
    );

    scm_10 scm1 (
        .clk(clk), .rst(rst),
        .X(aux1_x),
        .Y(evalx) // evalx = sigma * (yi - xi)
    );

    scm_0_01 scm2 (
        .clk(clk), .rst(rst),
        .X(evalx),
        .Y(aux2_x) // aux2_x = h * evalx
    );

    adder #(.n(n)) adder1 (
        .clk(clk), .rst(rst),
        .a(aux2_x), .b(xi),
        .out1(x_aux) // x_aux = xi + h * sigma * (yi - xi)
    );

    // --- Cálculo de dy = x * (rho - z) - y ---
    restador #(.n(n)) subs2 (
        .clk(clk), .rst(rst),
        .a(rho), .b(zi),
        .out1(aux1_y) // aux1_y = rho - zi
    );

    multiplier #(.n(n)) mult1 (
        .clk(clk), .rst(rst),
        .a(aux1_y), .b(xi),
        .out1(aux2_y) // aux2_y = xi * (rho - zi)
    );

    restador #(.n(n)) subs3 (
        .clk(clk), .rst(rst),
        .a(aux2_y), .b(yi),
        .out1(evaly) // evaly = xi * (rho - zi) - yi
    );

    scm_0_01 scm3 (
        .clk(clk), .rst(rst),
        .X(evaly),
        .Y(aux3_y) // aux3_y = h * evaly
    );

    adder #(.n(n)) adder2 (
        .clk(clk), .rst(rst),
        .a(aux3_y), .b(yi),
        .out1(y_aux) // y_aux = yi + h * (xi * (rho - zi) - yi)
    );

    // --- Cálculo de dz = x * y - beta * z ---
    multiplier #(.n(n)) mult2 (
        .clk(clk), .rst(rst),
        .a(xi), .b(yi),
        .out1(aux1_z) // aux1_z = xi * yi
    );

    scm_2_66 scm4 (
        .clk(clk), .rst(rst),
        .X(zi),
        .Y(aux2_z) // aux2_z = beta * zi
    );

    restador #(.n(n)) subs4 (
        .clk(clk), .rst(rst),
        .a(aux1_z), .b(aux2_z),
        .out1(evalz) // evalz = xi * yi - beta * zi
    );

    scm_0_01 scm5 (
        .clk(clk), .rst(rst),
        .X(evalz),
        .Y(aux3_z) // aux3_z = h * evalz
    );

    adder #(.n(n)) adder3 (
        .clk(clk), .rst(rst),
        .a(aux3_z), .b(zi),
        .out1(z_aux) // z_aux = zi + h * (xi * yi - beta * zi)
    );

    // --- Control de tiempo y registros ---
    counter #(.n(1000)) counter1 (
        .clk(clk), .rst(rst),
        .en(en)
    );

    register #(.n(n), .INIT_VAL(init)) registrox (
        .clk(clk), .rst(rst), .en(en),
        .d(x_aux), .q(xi)
    );

    register #(.n(n), .INIT_VAL(init)) registroy (
        .clk(clk), .rst(rst), .en(en),
        .d(y_aux), .q(yi)
    );

    register #(.n(n), .INIT_VAL(init)) registroz (
        .clk(clk), .rst(rst), .en(en),
        .d(z_aux), .q(zi)
    );

    // --- Salidas ---
    assign x = xi;
    assign y = yi;
    assign z = zi;

endmodule
											   