module procesador (
    input  wire        clk,
    input  wire        reset,
    input  wire [1:0]  irq,
    output wire        vma,
    inout  wire [3:0]  datout,
    output wire        rw
);

    // Señales internas
    wire [7:0] pcontrol, pcout, pila, ix, direccion;
    wire [4:0] cs;
    wire [3:0] operacion, datoin, re, a, b;

    // -------------------------
    // Instanciación de módulos
    // -------------------------

    // Selección de datos
    sel_dato u4 (
        .cs(cs),
        .datoin(datoin),
        .datout(datout),
        .operacion(operacion),
        .clk(clk)
    );

    // Tri-state buffer
    tri_est u5 (
		.clk(clk),
        .cs(cs),
        .operacion(operacion),
        .datout(datout)
    );

    // Program Counter (PE en tu libro)
    pc u6 (
        .clk(clk),
        .pcontrol(pcontrol),
        .cs(cs),
        .pcout(pcout),
        .pila(pila),
        .reset(reset)   // añadí reset para consistencia
    );

    // Registro índice
    indice u7 (
        .cs(cs),
        .clk(clk),
        .pcontrol(pcontrol),
        .ix(ix),
        .reset(reset)
    );

    // Pila
    stack u8 (
        .cs(cs),
        .clk(clk),
        .pcout(pcout),
        .pila(pila),
        .reset(reset)
    );

    // Selector de dirección
    sel_dir u9 (
        .clk(clk),
        .pcout(pcout),
        .ix(ix),
        .direccion(direccion),
        .cs(cs)
    );

    // Validación de dirección
    dir_val u10 (
        .vma(vma),
        .cs(cs)
    );

    // Unidad de control
    control u11 (
        .clk(clk),
        .reset(reset),
        .irq(irq),
        .rw(rw),
        .datoin(datoin),
        .pcontrol(pcontrol),
        .re(re),
        .pcout(pcout),
        .cs(cs)
    );

    // ALU
    alu u12 (
        .clk(clk),
        .a(a),
        .b(b),
        .cs(cs),
        .operacion(operacion),
        .re(re)
    );

    // Registros A y B
    rega5 u13 (
        .cs(cs),
        .reset(reset),
        .clk(clk),
        .datoin(datoin),
        .a(a)
    );

    regb5 u14 (
        .cs(cs),
        .reset(reset),
        .clk(clk),
        .datoin(datoin),
        .b(b)
    );

endmodule
