
/**********************************************************************
Top Level Module
***********************************************************************/
`timescale 100ps/1ps

module dct_idct ( CLK, RST, xin,dct_2d);
output [11:0] dct_2d;
input CLK, RST;
input[7:0] xin;
wire[7:0] dct_2d;

//wire[8:0] dct_2d;
wire rdy_sig;

dct dct_1 (.CLK(CLK), .RST(RST), .xin(xin), .dct_2d(dct_2d), .rdy_out(rdy_sig));
//idct idct_2 (.CLK(CLK), .RST(RST), .dct_2d(dct_2d), .rdy_in(rdy_sig), .idct_2d(idct_2d));


endmodule

