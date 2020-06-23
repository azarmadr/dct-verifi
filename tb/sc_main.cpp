#define SC_INCLUDE_DYNAMIC_PROCESSES
#include <stdio.h>
#include <iostream>
#include <sys/times.h>
#include <sys/stat.h>

#include "systemc.h"
#include "verilated.h"
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

   sc_signal<sc_bv< 8> > xin;
   sc_signal<sc_bv<12> > dct_2d;

   sc_fifo<pkt*> mon_f(3),drv_f(3);

   int count;

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
   drv_t -> rst(rst);
   drv_t -> xin(xin);
   drv_t -> rdy_o(rdy_out);

   //_mon
   mon* mon_t = new mon("mon_t");
   mon_t -> clk(clk);
   mon_t -> rst(rst);
   mon_t -> xin(xin);
   mon_t -> dct(dct_2d);
   mon_t -> rdy_o(rdy_out);

   //_sb
   sb* sb_t = new sb("sb_t");

   //_connections
   drv_t->drv_f(drv_f);
   mon_t->mon_f(mon_f);
   sb_t->mon_f(mon_f);
   sb_t->drv_f(drv_f);

   srand(time(0));
   //_WAVES
   Verilated::traceEverOn(true);

   rst= 1;
   count = 3;
   sb_t->count = count;
   sc_start(20,SC_NS);

   cout << "Enabling waves...\n";
   VerilatedVcdSc* tfp = new VerilatedVcdSc;
   top->trace (tfp, 99);
   tfp->open ("./vl.vcd");

   while(!sb_t->done){
      tfp->flush();

      rst= 0;
      sc_start(1,SC_NS);/*
      rst= 0;
      sc_start(2733,SC_NS);
      rst= 1;
      sc_start(2733,SC_NS);*/
   }
   
   top->final();
   tfp->close();
   
   delete top;
   top = NULL;

   return 0;
}
