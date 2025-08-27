module half_adder(		
	input wire A,     
    input wire B,     
    output wire SUM, 
    output wire CARRY
	);
	
	assign SUM = A ^ B;
	assign CARRY = A & B;
endmodule

module full_adder(
	input wire A,   
    input wire B,   
    input wire Cin, 
    output wire SUM,
    output wire Cout
);

    wire sum1, carry1, carry2;

    half_adder HA1 (
        .A(A),
        .B(B),
        .SUM(sum1),
        .CARRY(carry1)
    );

    half_adder HA2 (
        .A(sum1),
        .B(Cin),
        .SUM(SUM),
        .CARRY(carry2)
    );

    assign Cout = carry1 | carry2;
endmodule

module four_bit_adder(
    input wire [3:0] A,     
    input wire [3:0] B,     
    input wire Cin,      
    output wire [3:0] SUM,  
    output wire Cout        
);

    wire c1, c2, c3;

    half_adder HA0 (
        .A(A[0]),
        .B(B[0]),
        .SUM(SUM[0]),
        .CARRY(c1)
    );

    full_adder FA1 (
        .A(A[1]),
        .B(B[1]),
        .Cin(c1),
        .SUM(SUM[1]),
        .Cout(c2)
    );

    full_adder FA2 (
        .A(A[2]),
        .B(B[2]),
        .Cin(c2),
        .SUM(SUM[2]),
        .Cout(c3)
    );

    full_adder FA3 (
        .A(A[3]),
        .B(B[3]),
        .Cin(c3),
        .SUM(SUM[3]),
        .Cout(Cout)
    );
	
endmodule
