#include "pkt.h"

SC_MODULE(drv){
   sc_in<bool> clk;
   sc_out<uint32_t> xin;
   sc_in<bool> rdy_o;
   
   sc_port<sc_fifo_out_if<pkt*> > drv_f;
   
   void driver();

   SC_CTOR(drv){
      SC_CTHREAD(driver, clk.pos());
   }
};
void drv::driver(){
   wait();
   while(true){
      pkt* p;
      p=new(pkt);
      dct_calc(p);
      for(int i=0;i<64;i++){
	 xin->write((uint32_t)p->xin[i/8][i%8]);
	 wait();
      }
      drv_f->write(p);
      wait(rdy_o);
      wait(!rdy_o);
   }
}
