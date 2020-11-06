`timescale 1ns/1ps
module test_dct_idct;

parameter CLK_PERIOD = 10;

wire[11:0] dct_2d;
reg CLK,RST;
wire rdy;
reg[7:0] xin;
integer i;bit [7:0] xarr [64];

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
  xarr[0]  = 8'h28; xarr[1]  = 8'h21; xarr[2]  = 8'h21; xarr[3]  = 8'h16;
  xarr[4]  = 8'h1A; xarr[5]  = 8'h28; xarr[6]  = 8'h24; xarr[7]  = 8'h1A;
  xarr[8]  = 8'h2B; xarr[9]  = 8'h1A; xarr[10] = 8'h21; xarr[11] = 8'h16;
  xarr[12] = 8'h1D; xarr[13] = 8'h2B; xarr[14] = 8'h16; xarr[15] = 8'h24;
  xarr[16] = 8'h2B; xarr[17] = 8'h28; xarr[18] = 8'h13; xarr[19] = 8'h24;
  xarr[20] = 8'h24; xarr[21] = 8'h21; xarr[22] = 8'h0F; xarr[23] = 8'h1A;
  xarr[24] = 8'h24; xarr[25] = 8'h2B; xarr[26] = 8'h1A; xarr[27] = 8'h21;
  xarr[28] = 8'h1D; xarr[29] = 8'h1D; xarr[30] = 8'h13; xarr[31] = 8'h04;
  xarr[32] = 8'h21; xarr[33] = 8'h21; xarr[34] = 8'h1D; xarr[35] = 8'h1A;
  xarr[36] = 8'h0F; xarr[37] = 8'h21; xarr[38] = 8'h1A; xarr[39] = 8'h04;
  xarr[40] = 8'h24; xarr[41] = 8'h21; xarr[42] = 8'h21; xarr[43] = 8'h1A;
  xarr[44] = 8'h16; xarr[45] = 8'h1D; xarr[46] = 8'h1A; xarr[47] = 8'h0C;
  xarr[48] = 8'h21; xarr[49] = 8'h28; xarr[50] = 8'h1D; xarr[51] = 8'h1A;
  xarr[52] = 8'h21; xarr[53] = 8'h0C; xarr[54] = 8'h0C; xarr[55] = 8'h04;
  xarr[56] = 8'h1A; xarr[57] = 8'h21; xarr[58] = 8'h1D; xarr[59] = 8'h16;
  xarr[60] = 8'h0C; xarr[61] = 8'h04; xarr[62] = 8'h08; xarr[63] = 8'h00;

  xarr[0]  = 8'h7f; xarr[1]  = 8'h7f; xarr[2]  = 8'h63; xarr[3]  = 8'h4c;
  xarr[4]  = 8'h4c; xarr[5]  = 8'h4b; xarr[6]  = 8'h40; xarr[7]  = 8'h59;
  xarr[8]  = 8'h57; xarr[9]  = 8'h3d; xarr[10] = 8'h27; xarr[11] = 8'h26;
  xarr[12] = 8'h20; xarr[13] = 8'h07; xarr[14] = 8'h27; xarr[15] = 8'h74;
  xarr[16] = 8'h29; xarr[17] = 8'hf3; xarr[18] = 8'he3; xarr[19] = 8'he3;
  xarr[20] = 8'he3; xarr[21] = 8'hd2; xarr[22] = 8'hff; xarr[23] = 8'h5c;
  xarr[24] = 8'h12; xarr[25] = 8'hda; xarr[26] = 8'hd6; xarr[27] = 8'hd8;
  xarr[28] = 8'hd4; xarr[29] = 8'hbf; xarr[30] = 8'h43; xarr[31] = 8'h3d;
  xarr[32] = 8'h7f; xarr[33] = 8'h7f; xarr[34] = 8'h67; xarr[35] = 8'h6f;
  xarr[36] = 8'h70; xarr[37] = 8'h36; xarr[38] = 8'h7b; xarr[39] = 8'h68;
  xarr[40] = 8'h7f; xarr[41] = 8'h7f; xarr[42] = 8'h95; xarr[43] = 8'h75;
  xarr[44] = 8'h62; xarr[45] = 8'h29; xarr[46] = 8'h65; xarr[47] = 8'h77;
  xarr[48] = 8'h7f; xarr[49] = 8'h7f; xarr[50] = 8'h5e; xarr[51] = 8'h7b;
  xarr[52] = 8'h2e; xarr[53] = 8'h51; xarr[54] = 8'h2e; xarr[55] = 8'h23;
  xarr[56] = 8'h7f; xarr[57] = 8'h7f; xarr[58] = 8'h5d; xarr[59] = 8'h38;
  xarr[60] = 8'h4d; xarr[61] = 8'h78; xarr[62] = 8'h79; xarr[63] = 8'h5c;

  #5;
  for (i=0; i<64; i++)begin
    #10 xin <= xarr[i];
    if((i%8)==0) $display();
    $write("%d\t",xin);
  end/*
  for (int i; i<64; i++) #10 xin <= xarr[i];
  for (int i; i<64; i++) #10 xin <= xarr[i];
  for (int i; i<64; i++) #10 xin <= xarr[i];*/

  #900 $finish;
end
always @(rdy)begin
  for (i=0; i<64; i++)begin
    if((i%8)==0) $display();
    #10 $write(" %d ",dct_2d);
  end
end
endmodule
