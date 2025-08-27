`timescale 1ns / 1ps

module tb_half_adder;

    // Testbench signals
    reg A, B;
    wire SUM, CARRY;

    // Instantiate the half adder
    half_adder uut (
        .A(A),
        .B(B),
        .SUM(SUM),
        .CARRY(CARRY)
    );

    initial begin
        $display("A B | SUM CARRY");
        $display("--------------");

        // Test all input combinations
        A = 0; B = 0; #10;
        $display("%b %b |  %b    %b", A, B, SUM, CARRY);

        A = 0; B = 1; #10;
        $display("%b %b |  %b    %b", A, B, SUM, CARRY);

        A = 1; B = 0; #10;
        $display("%b %b |  %b    %b", A, B, SUM, CARRY);

        A = 1; B = 1; #10;
        $display("%b %b |  %b    %b", A, B, SUM, CARRY);

        $finish;
    end

endmodule

module tb_full_adder;

    // Testbench signals
    reg A, B, Cin;
    wire SUM, Cout;

    // Instantiate the full adder
    full_adder uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .SUM(SUM),
        .Cout(Cout)
    );

    initial begin
        $display("A B Cin | SUM Cout");
        $display("------------------");

        // Test all 8 input combinations
        A = 0; B = 0; Cin = 0; #10;
        $display("%b %b  %b  |  %b   %b", A, B, Cin, SUM, Cout);

        A = 0; B = 0; Cin = 1; #10;
        $display("%b %b  %b  |  %b   %b", A, B, Cin, SUM, Cout);

        A = 0; B = 1; Cin = 0; #10;
        $display("%b %b  %b  |  %b   %b", A, B, Cin, SUM, Cout);

        A = 0; B = 1; Cin = 1; #10;
        $display("%b %b  %b  |  %b   %b", A, B, Cin, SUM, Cout);

        A = 1; B = 0; Cin = 0; #10;
        $display("%b %b  %b  |  %b   %b", A, B, Cin, SUM, Cout);

        A = 1; B = 0; Cin = 1; #10;
        $display("%b %b  %b  |  %b   %b", A, B, Cin, SUM, Cout);

        A = 1; B = 1; Cin = 0; #10;
        $display("%b %b  %b  |  %b   %b", A, B, Cin, SUM, Cout);

        A = 1; B = 1; Cin = 1; #10;
        $display("%b %b  %b  |  %b   %b", A, B, Cin, SUM, Cout);

        $finish;
    end

endmodule	

module tb_four_bit_adder;

    // Testbench signals
    reg [3:0] A, B;
    reg Cin;
    wire [3:0] SUM;
    wire Cout;

    // Instantiate the 4-bit adder
    four_bit_adder uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .SUM(SUM),
        .Cout(Cout)
    );

    initial begin
        $display("A     B     Cin | SUM   Cout");
        $display("-----------------------------");

        // Test case 1: 0 + 0 + 0
        A = 4'b0000; B = 4'b0000; Cin = 0; #10;
        $display("%b %b   %b   | %b   %b", A, B, Cin, SUM, Cout);

        // Test case 2: 1 + 1 + 0
        A = 4'b0001; B = 4'b0001; Cin = 0; #10;
        $display("%b %b   %b   | %b   %b", A, B, Cin, SUM, Cout);

        // Test case 3: 15 + 1 + 0 (overflow)
        A = 4'b1111; B = 4'b0001; Cin = 0; #10;
        $display("%b %b   %b   | %b   %b", A, B, Cin, SUM, Cout);

        // Test case 4: 8 + 7 + 1
        A = 4'b1000; B = 4'b0111; Cin = 1; #10;
        $display("%b %b   %b   | %b   %b", A, B, Cin, SUM, Cout);

        // Test case 5: Alternating bits
        A = 4'b1010; B = 4'b0101; Cin = 0; #10;
        $display("%b %b   %b   | %b   %b", A, B, Cin, SUM, Cout);

        // Test case 6: Max + Max + 1 (overflow)
        A = 4'b1111; B = 4'b1111; Cin = 1; #10;
        $display("%b %b   %b   | %b   %b", A, B, Cin, SUM, Cout);

        $finish;
    end

endmodule
