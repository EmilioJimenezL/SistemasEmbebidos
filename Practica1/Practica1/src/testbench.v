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
