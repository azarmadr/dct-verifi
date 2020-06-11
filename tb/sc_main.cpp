#include "systemc.h"
#include "verilated_vcd_sc.h"

#include "Vdct.h"
#include "sc_tb.h"

int sc_main(int argc, char* argv[]) {
   Verilated::randReset(2);
   Verilated::debug(0);

   sc_clock clk("clock", 10, SC_NS);
   sc_signal<bool> rst;

   sc_signal<sc_uint<12> > dct_2d;
   sc_signal<bool> rdy_out;
   sc_signal<sc_uint< 8> > xin;

   //DUT
   Vdct* top = new Vdct("top");
   top-> CLK(clk);
   top-> RST(rst);
   top-> xin(xin);
   top-> dct_2d(dct_2d);
   top-> rdy_out(rdy_out);
