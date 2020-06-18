`timescale 1ns/1ps
module test_dct;

parameter CLK_PERIOD = 10;

wire[11:0] dct_2d;
reg CLK,RST;
reg[7:0] xin;
wire rdy;

dct test(.CLK(CLK), .RST(RST), .xin(xin), .dct_2d(dct_2d), .rdy_out(rdy));

initial 
begin
		  CLK <= 1'b0;
		  RST <= 1'b1;
		  #20 RST <= 1'b0;
end

always
		  #(CLK_PERIOD/2) CLK = ~CLK;

initial
begin
   #15 xin <= 8'h67;#10 xin <= 8'hc6;#10 xin <= 8'h69;#10 xin <= 8'h73;
   #10 xin <= 8'h51;#10 xin <= 8'hff;#10 xin <= 8'h4a;#10 xin <= 8'hec;
$display();
   #10 xin <= 8'h29;#10 xin <= 8'hcd;#10 xin <= 8'hba;#10 xin <= 8'hab;
   #10 xin <= 8'hf2;#10 xin <= 8'hfb;#10 xin <= 8'he3;#10 xin <= 8'h46;
$display();
   #10 xin <= 8'h7c;#10 xin <= 8'hc2;#10 xin <= 8'h54;#10 xin <= 8'hf8;
   #10 xin <= 8'h1b;#10 xin <= 8'he8;#10 xin <= 8'he7;#10 xin <= 8'h8d;
$display();
   #10 xin <= 8'h76;#10 xin <= 8'h5a;#10 xin <= 8'h2e;#10 xin <= 8'h63;
   #10 xin <= 8'h33;#10 xin <= 8'h9f;#10 xin <= 8'hc9;#10 xin <= 8'h9a;
$display();
   #10 xin <= 8'h66;#10 xin <= 8'h32;#10 xin <= 8'h0d;#10 xin <= 8'hb7;
   #10 xin <= 8'h31;#10 xin <= 8'h58;#10 xin <= 8'ha3;#10 xin <= 8'h5a;
$display();
   #10 xin <= 8'h25;#10 xin <= 8'h5d;#10 xin <= 8'h05;#10 xin <= 8'h17;
   #10 xin <= 8'h58;#10 xin <= 8'he9;#10 xin <= 8'h5e;#10 xin <= 8'hd4;
$display();
   #10 xin <= 8'hab;#10 xin <= 8'hb2;#10 xin <= 8'hcd;#10 xin <= 8'hc6;
   #10 xin <= 8'h9b;#10 xin <= 8'hb4;#10 xin <= 8'h54;#10 xin <= 8'h11;
$display();
   #10 xin <= 8'h0e;#10 xin <= 8'h82;#10 xin <= 8'h74;#10 xin <= 8'h41;
   #10 xin <= 8'h21;#10 xin <= 8'h3d;#10 xin <= 8'hdc;#10 xin <= 8'h87;
$display();
   #930;/*

		  #15 xin <= 8'h28;#10 xin <= 8'h21;#10 xin <= 8'h21;#10 xin <= 8'h16;
		  #10 xin <= 8'h1A;#10 xin <= 8'h28;#10 xin <= 8'h24;#10 xin <= 8'h1A;

		  #10 xin <= 8'h2B;#10 xin <= 8'h1A;#10 xin <= 8'h21;#10 xin <= 8'h16;
		  #10 xin <= 8'h1D;#10 xin <= 8'h2B;#10 xin <= 8'h16;#10 xin <= 8'h24;

		  #10 xin <= 8'h2B;#10 xin <= 8'h28;#10 xin <= 8'h13;#10 xin <= 8'h24;
		  #10 xin <= 8'h24;#10 xin <= 8'h21;#10 xin <= 8'h0F;#10 xin <= 8'h1A;

		  #10 xin <= 8'h24;#10 xin <= 8'h2B;#10 xin <= 8'h1A;#10 xin <= 8'h21;
		  #10 xin <= 8'h1D;#10 xin <= 8'h1D;#10 xin <= 8'h13;#10 xin <= 8'h04;

		  #10 xin <= 8'h21;#10 xin <= 8'h21;#10 xin <= 8'h1D;#10 xin <= 8'h1A;
		  #10 xin <= 8'h0F;#10 xin <= 8'h21;#10 xin <= 8'h1A;#10 xin <= 8'h04;

		  #10 xin <= 8'h24;#10 xin <= 8'h21;#10 xin <= 8'h21;#10 xin <= 8'h1A;
		  #10 xin <= 8'h16;#10 xin <= 8'h1D;#10 xin <= 8'h1A;#10 xin <= 8'h0C;

		  #10 xin <= 8'h21;#10 xin <= 8'h28;#10 xin <= 8'h1D;#10 xin <= 8'h1A;
		  #10 xin <= 8'h21;#10 xin <= 8'h0C;#10 xin <= 8'h0C;#10 xin <= 8'h04;

		  #10 xin <= 8'h1A;#10 xin <= 8'h21;#10 xin <= 8'h1D;#10 xin <= 8'h16;
		  #10 xin <= 8'h0C;#10 xin <= 8'h04;#10 xin <= 8'h08;#10 xin <= 8'h00;


		  #10 xin <= 8'h28;#10 xin <= 8'h21;#10 xin <= 8'h21;#10 xin <= 8'h16;
		  #10 xin <= 8'h1A;#10 xin <= 8'h28;#10 xin <= 8'h24;#10 xin <= 8'h1A;

		  #10 xin <= 8'h2B;#10 xin <= 8'h1A;#10 xin <= 8'h21;#10 xin <= 8'h16;
		  #10 xin <= 8'h1D;#10 xin <= 8'h2B;#10 xin <= 8'h16;#10 xin <= 8'h24;

		  #10 xin <= 8'h2B;#10 xin <= 8'h28;#10 xin <= 8'h13;#10 xin <= 8'h24;
		  #10 xin <= 8'h24;#10 xin <= 8'h21;#10 xin <= 8'h0F;#10 xin <= 8'h1A;

		  #10 xin <= 8'h24;#10 xin <= 8'h2B;#10 xin <= 8'h1A;#10 xin <= 8'h21;
		  #10 xin <= 8'h1D;#10 xin <= 8'h1D;#10 xin <= 8'h13;#10 xin <= 8'h04;

		  #10 xin <= 8'h21;#10 xin <= 8'h21;#10 xin <= 8'h1D;#10 xin <= 8'h1A;
		  #10 xin <= 8'h0F;#10 xin <= 8'h21;#10 xin <= 8'h1A;#10 xin <= 8'h04;

		  #10 xin <= 8'h24;#10 xin <= 8'h21;#10 xin <= 8'h21;#10 xin <= 8'h1A;
		  #10 xin <= 8'h16;#10 xin <= 8'h1D;#10 xin <= 8'h1A;#10 xin <= 8'h0C;

		  #10 xin <= 8'h21;#10 xin <= 8'h28;#10 xin <= 8'h1D;#10 xin <= 8'h1A;
		  #10 xin <= 8'h21;#10 xin <= 8'h0C;#10 xin <= 8'h0C;#10 xin <= 8'h04;

		  #10 xin <= 8'h1A;#10 xin <= 8'h21;#10 xin <= 8'h1D;#10 xin <= 8'h16;
		  #10 xin <= 8'h0C;#10 xin <= 8'h04;#10 xin <= 8'h08;#10 xin <= 8'h00;


		  #10 xin <= 8'h28;#10 xin <= 8'h21;#10 xin <= 8'h21;#10 xin <= 8'h16;
		  #10 xin <= 8'h1A;#10 xin <= 8'h28;#10 xin <= 8'h24;#10 xin <= 8'h1A;

		  #10 xin <= 8'h2B;#10 xin <= 8'h1A;#10 xin <= 8'h21;#10 xin <= 8'h16;
		  #10 xin <= 8'h1D;#10 xin <= 8'h2B;#10 xin <= 8'h16;#10 xin <= 8'h24;

		  #10 xin <= 8'h2B;#10 xin <= 8'h28;#10 xin <= 8'h13;#10 xin <= 8'h24;
		  #10 xin <= 8'h24;#10 xin <= 8'h21;#10 xin <= 8'h0F;#10 xin <= 8'h1A;

		  #10 xin <= 8'h24;#10 xin <= 8'h2B;#10 xin <= 8'h1A;#10 xin <= 8'h21;
		  #10 xin <= 8'h1D;#10 xin <= 8'h1D;#10 xin <= 8'h13;#10 xin <= 8'h04;

		  #10 xin <= 8'h21;#10 xin <= 8'h21;#10 xin <= 8'h1D;#10 xin <= 8'h1A;
		  #10 xin <= 8'h0F;#10 xin <= 8'h21;#10 xin <= 8'h1A;#10 xin <= 8'h04;

		  #10 xin <= 8'h24;#10 xin <= 8'h21;#10 xin <= 8'h21;#10 xin <= 8'h1A;
		  #10 xin <= 8'h16;#10 xin <= 8'h1D;#10 xin <= 8'h1A;#10 xin <= 8'h0C;

		  #10 xin <= 8'h21;#10 xin <= 8'h28;#10 xin <= 8'h1D;#10 xin <= 8'h1A;
		  #10 xin <= 8'h21;#10 xin <= 8'h0C;#10 xin <= 8'h0C;#10 xin <= 8'h04;

		  #10 xin <= 8'h1A;#10 xin <= 8'h21;#10 xin <= 8'h1D;#10 xin <= 8'h16;
		  #10 xin <= 8'h0C;#10 xin <= 8'h04;#10 xin <= 8'h08;#10 xin <= 8'h00;


		  #10 xin <= 8'h28;#10 xin <= 8'h21;#10 xin <= 8'h21;#10 xin <= 8'h16;
		  #10 xin <= 8'h1A;#10 xin <= 8'h28;#10 xin <= 8'h24;#10 xin <= 8'h1A;

		  #10 xin <= 8'h2B;#10 xin <= 8'h1A;#10 xin <= 8'h21;#10 xin <= 8'h16;
		  #10 xin <= 8'h1D;#10 xin <= 8'h2B;#10 xin <= 8'h16;#10 xin <= 8'h24;

		  #10 xin <= 8'h2B;#10 xin <= 8'h28;#10 xin <= 8'h13;#10 xin <= 8'h24;
		  #10 xin <= 8'h24;#10 xin <= 8'h21;#10 xin <= 8'h0F;#10 xin <= 8'h1A;

		  #10 xin <= 8'h24;#10 xin <= 8'h2B;#10 xin <= 8'h1A;#10 xin <= 8'h21;
		  #10 xin <= 8'h1D;#10 xin <= 8'h1D;#10 xin <= 8'h13;#10 xin <= 8'h04;

		  #10 xin <= 8'h21;#10 xin <= 8'h21;#10 xin <= 8'h1D;#10 xin <= 8'h1A;
		  #10 xin <= 8'h0F;#10 xin <= 8'h21;#10 xin <= 8'h1A;#10 xin <= 8'h04;

		  #10 xin <= 8'h24;#10 xin <= 8'h21;#10 xin <= 8'h21;#10 xin <= 8'h1A;
		  #10 xin <= 8'h16;#10 xin <= 8'h1D;#10 xin <= 8'h1A;#10 xin <= 8'h0C;

		  #10 xin <= 8'h21;#10 xin <= 8'h28;#10 xin <= 8'h1D;#10 xin <= 8'h1A;
		  #10 xin <= 8'h21;#10 xin <= 8'h0C;#10 xin <= 8'h0C;#10 xin <= 8'h04;

		  #10 xin <= 8'h1A;#10 xin <= 8'h21;#10 xin <= 8'h1D;#10 xin <= 8'h16;
		  #10 xin <= 8'h0C;#10 xin <= 8'h04;#10 xin <= 8'h08;#10 xin <= 8'h00;
*/

		  #100 $finish;
end

initial $monitor($time, " xin = %h",xin," dct=%h",dct_2d);
endmodule

