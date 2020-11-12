#define SC_INCLUDE_DYNAMIC_PROCESSES
#include <stdio.h>
#include <iostream>
#include <sys/times.h>
#include <sys/stat.h>

#include "systemc.h"
#include "verilated.h"
#include "verilated_vcd_sc.h"

#include "Vidct.h"
#include "mon.h"
#include "drv.h"

int sc_main(int argc, char* argv[]) {
   Verilated::randReset(2);
   Verilated::debug(0);

   sc_clock clk("clock", 10, SC_NS);
   sc_signal<bool>        rst;
   sc_signal<bool>        rdy_in;
   sc_signal<sc_bv< 8> >  idct_2d;
   sc_signal<sc_bv<12> >  dct_2d;

   sc_fifo<pkt*> drv_f(1),pkt_f(1);


   //_DUT
   Vidct* top = new Vidct("top");
   top-> CLK(clk);
   top-> RST(rst);
   top-> idct_2d(idct_2d);
   top-> dct_2d(dct_2d);
   top-> rdy_in(rdy_in);

   //_drv
   drv* drv_t = new drv("drv_t");
   drv_t -> clk(clk);
   drv_t -> rst(rst);
   drv_t -> dct_2d(dct_2d);
   drv_t -> rdy_i(rdy_in);

   //_mon
   mon* mon_t = new mon("mon_t");
   mon_t -> clk(clk);
   mon_t -> rst(rst);
   mon_t -> idct_2d(idct_2d);
   mon_t -> dct(dct_2d);
   mon_t -> rdy_i(rdy_in);

   //_gen
   gen* gen_t = new gen("gen_t");

   //_connections
   gen_t->pkt_f(pkt_f);
   gen_t->drv_f(drv_f);
   drv_t->drv_f(drv_f);
   mon_t->pkt_f(pkt_f);

   srand(time(0));
   //_WAVES
   Verilated::traceEverOn(true);

   rst= 1;
   cout<<gen_t->pkt_v.size();
   cout<<gen_t->done;
   sc_start(20,SC_NS);
   rst= 0;

   cout<<"Enabling waves...\n";
   cout<<"main: "<<gen_t->done;
   VerilatedVcdSc* tfp = new VerilatedVcdSc;
   top->trace (tfp, 9);
   tfp->open ("./vl.vcd");

   while(!gen_t->done){
      tfp->flush();

      sc_start(1,SC_NS);
   }

   top->final();
   tfp->close();

   delete top;
   top = NULL;

   return 0;
}
