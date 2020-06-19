#include "pkt.h"

SC_MODULE(drv){
   sc_in<bool> clk;
   sc_in<bool> rst;
   sc_out<uint32_t> xin;
   sc_in<bool> rdy_o;
   
   sc_port<sc_fifo_out_if<pkt*> > drv_f;
   
   void driver();

   SC_CTOR(drv){
      SC_CTHREAD(driver, clk.pos());
      reset_signal_is(rst, true);
   }
};
void drv::driver(){
   wait();
   while(true){
      pkt* p = new (pkt);
      dct_calc(p);
      cout<<"@"<<sc_time_stamp()<<" of drv "<<*p<<endl;
      for(int i=0;i<64;i++){
	 xin->write((uint32_t)p->xin[i/8][i%8]);
	 wait();
      }
      drv_f->write(p);
      while(!rdy_o) wait();
      while(rdy_o) wait();
   }
}
