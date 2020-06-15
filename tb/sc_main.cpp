#include "systemc.h"
#include "verilated_vcd_sc.h"

#include "Vdct.h"
#include "sb.h"
#include "mon.h"
#include "drv.h"

int sc_main(int argc, char* argv[]) {
   Verilated::randReset(2);
   Verilated::debug(0);

   sc_clock clk("clock", 10, SC_NS);
   sc_signal<bool> rst;
   sc_signal<bool> rdy_out;
   sc_signal<bool> checker_b;

   sc_signal<sc_uint< 8> > xin;
   sc_signal<sc_uint<12> > dct_2d;

   sc_fifo<*pkt> mon_f(2),drv_f(2);

   //_DUT
   Vdct* top = new Vdct("top");
   top-> CLK(clk);
   top-> RST(rst);
   top-> xin(xin);
   top-> dct_2d(dct_2d);
   top-> rdy_out(rdy_out);

   //_drv
   drv* drv_t = new drv("drv_t");
   drv_t -> clk(clk);
   drv_t -> xin(xin);
   drv_t -> rdy_o(rdy_out);

   //_mon
   mon* mon_t = new mon("mon_t");
   mon_t -> clk(clk);
   mon_t -> xin(xin);
   mon_t -> dct(dct_2d);
   mon_t -> rdy_o(rdy_out);

   //_sb
   sb* sb_t = new sb("sb_t");
   sb_t -> sb_out(checker_b);

   //_connections
   drv.drv_f(drv_f);
   mon.mon_f(mon_f);
   sb.mon_f(mon_f);
   sb.drv_f(drv_f);

   sc_start(0);
   return 0;
}
