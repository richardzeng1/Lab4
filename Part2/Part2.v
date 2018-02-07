// new shit
module Part2(SW, KEY, HEX0, HEX4, HEX5, LEDR);
    // declaring variables
    input [9:0] SW;
	 input [9:0] LEDR;
	 input [6:0] HEX0;
	 input [6:0] HEX4;
	 input [6:0] HEX5;
	 input [2:0] KEY;
	 
	 wire [7:0] wirein; //input for register
	 wire [7:0] wireout; // output of register
	 
	 // clock is key 0 
	 // reset_n is sw 9
	 
	 // declaring register
	 register r1(
	     .d(wirein),
		  .clock(KEY[0]),
		  .reset_n(SW[9]),
		  .q(wireout)
	 );
	 
	 // calling ALU
	 ALU alu(
	     .a(SW[3:0]),
		  .b(wireout[3:0]),
		  .SW(SW[7:0]),
		  .out(wirein)
	 );
	 
	 // seven seg
	 seven_seg_decoder B(
	     .SW(SW[3:0]),
		  .HEX0(HEX0[6:0])
	 );
	 
	 seven_seg_decoder C(
	     .SW(wirein[3:0]),
		  .HEX0(HEX4[6:0])
	 );
	 
	 seven_seg_decoder D(
	     .SW(wirein[7:4]),
		  .HEX0(HEX5[6:0])
	 );
	 assign LEDR[0] = wirein[0];
	 assign LEDR[1] = wirein[1];
	 assign LEDR[2] = wirein[2];
	 assign LEDR[3] = wirein[3];
	 assign LEDR[4] = wirein[4];
	 assign LEDR[5] = wirein[5];
	 assign LEDR[6] = wirein[6];
	 assign LEDR[7] = wirein[7];
	 assign LEDR[8] = 1'b0;
	 assign LEDR[9] = 1'b0;
endmodule

module register(d, clock, reset_n, q);
    input clock, reset_n;
	 input [7:0]d;
	 output reg [7:0]q;
	 
    always @(posedge clock)
	 begin 
	     if (reset_n == 1'b0)
		      q <=1'b0;
		  else
		      q <=d;
	 end
endmodule

module ALU(a, b, SW, out);
    input [7:0] SW;
	 input [3:0] a;
	 input [3:0] b;
	 
	 output reg [7:0] out;
	 
	 wire [7:0] WIRE0, WIRE1;
	 
	 wire [7:0] adderIn;
	 assign adderIn[3:0] = b;
	 assign adderIn[7:4] = a;
	 
	 AddOne poo(
	     .LEDR(WIRE0),
		  .SW(a)
	 );
	 
	 Adder poo1(
	     .LEDR(WIRE1),
		  .SW(adderIn)
	 );
	 
	 always @(*)
	 begin
		case(SW[7:5])
			3'b000: out = WIRE0;
			3'b001: out = WIRE1;
			3'b010: out = {4'b0000, SW[7:4] + SW[3:0]};
			3'b011: out = {SW[7:4] | SW[3:0], SW[7:4] ^ SW[3:0]};
			3'b100: out = {7'b0000000, SW[7] | SW[6] | SW[5] | SW[4] | SW[3] | SW[2] | SW[1] | SW[0]};
			3'b101: out = SW[3:0] << SW[7:4];
			3'b110: out = SW[3:0] >> SW[7:4];
			3'b111: out = {SW[7:4] * SW[3:0]};
			default: out = 8'b00000000;
		endcase
    end

endmodule

module seven_seg_decoder(SW, HEX0);

    input [3:0] SW;
    output [6:0] HEX0;

    assign HEX0[0] = (~SW[3]&~SW[2]&~SW[1]&SW[0]) | (~SW[3]&SW[2]&~SW[1]&~SW[0]) | (SW[3]&SW[2]&~SW[1]&SW[0]) | (SW[3]&~SW[2]&SW[1]&SW[0]);
    assign HEX0[1] = (~SW[3]&SW[2]&~SW[1]&SW[0]) | (SW[3]&SW[2]&~SW[1]&~SW[0]) | (SW[3]&SW[1]&SW[0]) | (SW[2]&SW[1]&~SW[0]) | (SW[3]&SW[2]&SW[1]);
    assign HEX0[2] = (SW[3]&SW[2]&~SW[1]&~SW[0]) | (~SW[3]&~SW[2]&SW[1]&~SW[0]) | (SW[3]&SW[2]&SW[1]);
    assign HEX0[3] = (~SW[3]&SW[2]&~SW[1]&~SW[0]) | (~SW[3]&~SW[2]&~SW[1]&SW[0]) | (SW[2]&SW[1]&SW[0]) | (SW[3]&~SW[2]&SW[1]&~SW[0]); 
    assign HEX0[4] = (~SW[3]&SW[0]) | (~SW[3]&SW[2]&~SW[1]) | (~SW[2]&~SW[1]&SW[0]);
    assign HEX0[5] = (SW[3]&SW[2]&~SW[1]&SW[0]) | (~SW[3]&SW[1]&SW[0]) | (~SW[3]&~SW[2]&SW[0]) | (~SW[3]&~SW[2]&SW[1]);
    assign HEX0[6] = (SW[3]&SW[2]&~SW[1]&~SW[0]) | (~SW[3]&SW[2]&SW[1]&SW[0]) | (~SW[3]&~SW[2]&~SW[1]); 

endmodule

module Adder(LEDR, SW);
    input [7:0] SW; // 1-4 FIRST DIGIT, 5-8 SECOND DIGIT,0 FIRST CARRY
    output [7:0] LEDR;
    wire WIRE0;
         wire WIRE1;
         wire WIRE2;

         fullAdder1 bo(
             .A(SW[0]),
                  .B(SW[4]),
                  .cin(1'b0),
                  .S(LEDR[0]),
                  .cout(WIRE0)
         );

         fullAdder1 b1(
             .A(SW[1]),
                  .B(SW[5]),
                  .cin(WIRE0),
                  .S(LEDR[1]),
                  .cout(WIRE1)
         );

         fullAdder1 b2(
             .A(SW[2]),
                  .B(SW[6]),
                  .cin(WIRE1),
                  .S(LEDR[2]),
                  .cout(WIRE2)
         );

         fullAdder1 b3(
             .A(SW[3]),
                  .B(SW[7]),
                  .cin(WIRE2),
                  .S(LEDR[3]),
                  .cout(LEDR[4])
         );

         assign LEDR[5] = 1'b0;
         assign LEDR[6] = 1'b0;
         assign LEDR[7] = 1'b0;
endmodule

module AddOne(LEDR, SW);
    input [3:0] SW; // 1-4 FIRST DIGIT, 5-8 SECOND DIGIT,0 FIRST CARRY
    output [7:0] LEDR;
    wire WIRE0;
         wire WIRE1;
         wire WIRE2;

         fullAdder1 bo(
             .A(SW[0]),
                  .B(1'b1),
                  .cin(1'b0),
                  .S(LEDR[0]),
                  .cout(WIRE0)
         );

         fullAdder1 b1(
             .A(SW[1]),
                  .B(1'b0),
                  .cin(WIRE0),
                  .S(LEDR[1]),
                  .cout(WIRE1)
         );

         fullAdder1 b2(
             .A(SW[2]),
                  .B(1'b0),
                  .cin(WIRE1),
                  .S(LEDR[2]),
                  .cout(WIRE2)
         );

         fullAdder1 b3(
             .A(SW[3]),
				 .B(1'b0),
				 .cin(WIRE2),
				 .S(LEDR[3]),
				 .cout(LEDR[4])
			);
			
			assign LEDR[5] = 1'b0;
         assign LEDR[6] = 1'b0;
         assign LEDR[7] = 1'b0;
endmodule

module fullAdder1(A, B, cin, S, cout);
    input A; // bits to add
    input B;
    input cin; // carry value
         output cout; // carry out
    output S; //output value

    assign S = A ^ B^ cin;
         assign cout = (A&B) | (A&cin) | (B&cin);

endmodule