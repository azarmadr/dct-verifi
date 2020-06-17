#define SC_INCLUDE_DYNAMIC_PROCESSES
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

   sc_signal<uint32_t> xin;
   sc_signal<uint32_t> dct_2d;

   sc_fifo<pkt*> mon_f(2),drv_f(2);

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
   drv_t->drv_f(drv_f);
   mon_t->mon_f(mon_f);
   sb_t->mon_f(mon_f);
   sb_t->drv_f(drv_f);

   Verilated::traceEverOn(true);

   cout << "Enabling waves...\n";
   VerilatedVcdSc* tfp = new VerilatedVcdSc;
   top->trace (tfp, 99);
   tfp->open ("vl_dump.vcd");
   tfp->flush();
   tfp->close();

   sc_start(31,SC_NS);
   rst= 0;
   sc_start(2733,SC_NS);
   rst= 1;
   
   return 0;
}
