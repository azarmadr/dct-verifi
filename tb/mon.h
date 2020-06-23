#include "pkt.h"
SC_MODULE(mon){
   sc_in<bool> clk;
   sc_in<bool> rst;
   sc_in<sc_bv< 8> > xin;
   sc_in<sc_bv<12> > dct;
   sc_in<bool> rdy_o;

   sc_event mrdy,drdy;
   sc_event_or_list mts;
   std::vector<sc_process_handle> m_thread;

   sc_port<sc_fifo_out_if<pkt*> > mon_f;

   void monitor();
   void dct_m(pkt* p);

   SC_CTOR(mon){
      SC_CTHREAD(monitor,clk.pos());
      reset_signal_is(rst, true);
   }
};
void mon::monitor(){
      wait();
   while(true){
      pkt* p =new(pkt);
      for(int i=0;i<64;i++){
	 wait();
	 p->xin[i]= xin->read();
      }
      m_thread.push_back(
	    sc_spawn(
	       sc_bind(&mon::dct_m,this, sc_ref(p))
	       ));
   }
}
void mon::dct_m(pkt* p){
   wait(310,SC_NS);
   for(int i=0;i<64;i++){
      p->dct[(i%8)*8+i/8]= dct->read();
      wait(10,SC_NS);
   }
   mon_f->write(p);
}
