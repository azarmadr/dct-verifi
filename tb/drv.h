#include "pkt.h"

SC_MODULE(drv){
   sc_in<bool> clk;
   sc_out<sc_int<8> > xin;
   sc_in<bool> rdy_o;
   
   sc_port<sc_fifo_out_if<pkt*> > drv_ap;
   
   void driver();

   SC_CTOR(mon){
      SC_CTHREAD(driver, clk.pos());
   }
}
void mon::monitor(){
   sc_int<6> count = 0;
   wait();
   while(true){
      pkt* p;
      p=new(pkt);
      p->dct_calc();
      for(int i=0;i<64;i++){
	 xin=p->xin[i/8][i%8];
	 wait();
      }
      drv_ap.write(p);
      wait(rdy_o);
      wait(!rdy_o);
   }
}
