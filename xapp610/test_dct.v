`timescale 1ns/1ps
module test_dct;

parameter CLK_PERIOD = 10;

wire[11:0] dct_2d;
reg CLK,RST;
reg[7:0] xin;
wire rdy;
integer i=0,j=-1;

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
begin/*
   #15 xin <= 8'h48;#10 xin <= 8'h67;#10 xin <= 8'h0a;#10 xin <= 8'h14;
   #10 xin <= 8'h02;#10 xin <= 8'h20;#10 xin <= 8'h0b;#10 xin <= 8'h2d;

   #10 xin <= 8'h3a;#10 xin <= 8'h2e;#10 xin <= 8'h3b;#10 xin <= 8'h4c;
   #10 xin <= 8'h23;#10 xin <= 8'h0c;#10 xin <= 8'h54;#10 xin <= 8'h47;

   #10 xin <= 8'h6d;#10 xin <= 8'h33;#10 xin <= 8'h65;#10 xin <= 8'h49;
   #10 xin <= 8'h3c;#10 xin <= 8'h39;#10 xin <= 8'h68;#10 xin <= 8'h5e;

   #10 xin <= 8'h57;#10 xin <= 8'h1b;#10 xin <= 8'h6f;#10 xin <= 8'h54;
   #10 xin <= 8'h64;#10 xin <= 8'h30;#10 xin <= 8'h5a;#10 xin <= 8'h2b;

   #10 xin <= 8'h27;#10 xin <= 8'h53;#10 xin <= 8'h2e;#10 xin <= 8'h18;
   #10 xin <= 8'h02;#10 xin <= 8'h39;#10 xin <= 8'h34;#10 xin <= 8'h3b;

   #10 xin <= 8'h56;#10 xin <= 8'h6e;#10 xin <= 8'h06;#10 xin <= 8'h08;
   #10 xin <= 8'h69;#10 xin <= 8'h4a;#10 xin <= 8'h3f;#10 xin <= 8'h65;

   #10 xin <= 8'h6c;#10 xin <= 8'h33;#10 xin <= 8'h2e;#10 xin <= 8'h37;
   #10 xin <= 8'h5c;#10 xin <= 8'h25;#10 xin <= 8'h25;#10 xin <= 8'h42;

   #10 xin <= 8'h2f;#10 xin <= 8'h13;#10 xin <= 8'h25;#10 xin <= 8'h12;
   #10 xin <= 8'h42;#10 xin <= 8'h0e;#10 xin <= 8'h3d;#10 xin <= 8'h68;

   #930;//
   #15 xin <= 8'h67;#10 xin <= 8'hc6;#10 xin <= 8'h69;#10 xin <= 8'h73;
   #10 xin <= 8'h51;#10 xin <= 8'hff;#10 xin <= 8'h4a;#10 xin <= 8'hec;

   #10 xin <= 8'h29;#10 xin <= 8'hcd;#10 xin <= 8'hba;#10 xin <= 8'hab;
   #10 xin <= 8'hf2;#10 xin <= 8'hfb;#10 xin <= 8'he3;#10 xin <= 8'h46;

   #10 xin <= 8'h7c;#10 xin <= 8'hc2;#10 xin <= 8'h54;#10 xin <= 8'hf8;
   #10 xin <= 8'h1b;#10 xin <= 8'he8;#10 xin <= 8'he7;#10 xin <= 8'h8d;

   #10 xin <= 8'h76;#10 xin <= 8'h5a;#10 xin <= 8'h2e;#10 xin <= 8'h63;
   #10 xin <= 8'h33;#10 xin <= 8'h9f;#10 xin <= 8'hc9;#10 xin <= 8'h9a;

   #10 xin <= 8'h66;#10 xin <= 8'h32;#10 xin <= 8'h0d;#10 xin <= 8'hb7;
   #10 xin <= 8'h31;#10 xin <= 8'h58;#10 xin <= 8'ha3;#10 xin <= 8'h5a;

   #10 xin <= 8'h25;#10 xin <= 8'h5d;#10 xin <= 8'h05;#10 xin <= 8'h17;
   #10 xin <= 8'h58;#10 xin <= 8'he9;#10 xin <= 8'h5e;#10 xin <= 8'hd4;

   #10 xin <= 8'hab;#10 xin <= 8'hb2;#10 xin <= 8'hcd;#10 xin <= 8'hc6;
   #10 xin <= 8'h9b;#10 xin <= 8'hb4;#10 xin <= 8'h54;#10 xin <= 8'h11;

   #10 xin <= 8'h0e;#10 xin <= 8'h82;#10 xin <= 8'h74;#10 xin <= 8'h41;
   #10 xin <= 8'h21;#10 xin <= 8'h3d;#10 xin <= 8'hdc;#10 xin <= 8'h87;

   #930;*/

		  #15 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;
		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;

		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;
		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;

		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;
		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;

		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;
		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;

		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;
		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;

		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;
		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;

		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;
		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;

		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;
		  #10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;#10 xin <= 8'h01;

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

   #930;/*

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

//initial $monitor($time, " xin = %h",xin," dct=%d",dct_2d);
always @(dct_2d)begin
   if((j%8)==1) $display();
   if(j==0) $display();
   if(j>=-10) $write(" %d ",dct_2d);
   /*if(i==53)begin
      i=i+1;
      $write("37\t");
   end*/
   j=j+1;
end
always @(xin)begin
   if((i%8)==0) $display();
   $write("%d\t",xin);
   if(i==53)begin
      i=i+1;
      $write("37\t");
   end
   i=i+1;
end
endmodule
