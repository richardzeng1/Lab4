module Part3(SW, KEY, LEDR);
    // SW 7 to 0 for loadVal 7 to 0
	 // SW 9 for reset_n
	 // KEY 1 for load_n
	 // KEY 2 for shift right
	 // KEY 3 for ASR 
	 // KEY 0 for clock
	 // Q to LEDR
	 input [9:0] SW;
	 input [3:0] KEY;
	 output [7:0] LEDR;
	 
	 wire w6, w5, w4, w3, w2, w1, w0;
	 
	 reg firstIn;
		  
	 always @(*)
	 begin
	     case(KEY[3])
		      1'b0: firstIn = 1'b0;
				1'b1: firstIn = SW[7];
				default: firstIn = 1'b0;
			endcase
	 end
	 
	 // left to right bits
	 shifterBit s7(
	     .LV(SW[7]),
		  .IN(firstIn),
		  .LN(KEY[1]),
		  .SR(KEY[2]),
		  .R(SW[9]),
		  .CLK(KEY[0]),
		  .Q(w6)
	 );
	 
	 shifterBit s6(
	     .LV(SW[6]),
		  .IN(w6),
		  .LN(KEY[1]),
		  .SR(KEY[2]),
		  .R(SW[9]),
		  .CLK(KEY[0]),
		  .Q(w5)
	 );
	 
	 shifterBit s5(
	     .LV(SW[5]),
		  .IN(w5),
		  .LN(KEY[1]),
		  .SR(KEY[2]),
		  .R(SW[9]),
		  .CLK(KEY[0]),
		  .Q(w4)
	 );
	 
	 shifterBit s4(
	     .LV(SW[4]),
		  .IN(w4),
		  .LN(KEY[1]),
		  .SR(KEY[2]),
		  .R(SW[9]),
		  .CLK(KEY[0]),
		  .Q(w3)
	 );
	 
	 shifterBit s3(
	     .LV(SW[3]),
		  .IN(w3),
		  .LN(KEY[1]),
		  .SR(KEY[2]),
		  .R(SW[9]),
		  .CLK(KEY[0]),
		  .Q(w2)
	 );
	 
	 shifterBit s2(
	     .LV(SW[2]),
		  .IN(w2),
		  .LN(KEY[1]),
		  .SR(KEY[2]),
		  .R(SW[9]),
		  .CLK(KEY[0]),
		  .Q(w1)
	 );
	 
	 shifterBit s1(
	     .LV(SW[1]),
		  .IN(w1),
		  .LN(KEY[1]),
		  .SR(KEY[2]),
		  .R(SW[9]),
		  .CLK(KEY[0]),
		  .Q(w0)
	 );
	 
	 shifterBit s0(
	     .LV(SW[0]),
		  .IN(w0),
		  .LN(KEY[1]),
		  .SR(KEY[2]),
		  .R(SW[9]),
		  .CLK(KEY[0]),
		  .Q(LEDR[0])
	 );
	 
	 assign LEDR[1] = w0;
	 assign LEDR[2] = w1;
	 assign LEDR[3] = w2;
	 assign LEDR[4] = w3;
	 assign LEDR[5] = w4;
	 assign LEDR[6] = w5;
	 assign LEDR[7] = w6;
	 

endmodule

module shifterBit(LV, IN, LN, SR, R, CLK, Q);
    input LV, IN, LN, SR, R, CLK;
	 output Q;
	 
    wire toMux1;
	 wire toLatch;
	 wire out;
	 
    mux2to1 mux0(
	     .x(out),
		  .y(IN),
		  .s(SR),
		  .m(toMux1)
	 );
	 
	 mux2to1 mux1(
	     .x(LV),
		  .y(toMux1),
		  .s(LN),
		  .m(toLatch)
	 );
	 
	 flipFlop a(
	     .d(toLatch),
		  .clk(CLK),
		  .reset_n(R),
		  .q(out)
	 );
	 
	 assign Q = out;
endmodule

module flipFlop(d, clk, reset_n, q);
    input d;
	 input clk;
	 input reset_n;
	 output reg q;
	 
	 always @(posedge clk)
	 begin
	     if (reset_n == 1'b0)
		      q <= 1'b0;
		  else
		      q <= d;
	 end
endmodule

module mux2to1(x, y, s, m);
    input x, y, s; // s is selector
	 output m; 
	 
	 assign m = s & y | ~s & x;
		  
endmodule
