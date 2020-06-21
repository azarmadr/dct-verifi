#include "pkt.h"

SC_MODULE(mon){
   sc_in<bool> clk;
   sc_in<bool> rst;
   sc_in<sc_bv< 8> > xin;
   sc_in<sc_bv<12> > dct;
   sc_in<bool> rdy_o;
   
   sc_event mrdy;
   sc_process_handle m_thread;

   sc_port<sc_fifo_out_if<pkt*> > mon_f;
   
   bool done;

   void monitor();
   void xin_m();
   void dct_m();
   void Vrdy();

   SC_CTOR(mon){
      done = false;

      SC_CTHREAD(monitor,clk.pos());
      reset_signal_is(rst, true);
      m_thread=sc_get_current_process_handle();

      SC_THREAD(Vrdy);
      sensitive<<rdy_o.pos();
   }
};
void mon::monitor(){
   while(true){
      pkt* p =new(pkt);
	 wait();
      for(int i=0;i<64;i++){
	 wait();
	 p->xin[i]= xin->read();
      }
      //while(!rdy_o) wait();
      mrdy.notify();
      for(int i=0;i<64;i++){
	 wait();
	 p->dct[(i%8)*8+i/8]= dct->read();
      }
      mon_f->write(p);
      cout<<"@"<<sc_time_stamp()<<" "<<*p<<endl;
      wait();
      done = true;
   }
}
void mon::Vrdy(){
   wait(mrdy);
   m_thread.disable();
   wait();
   m_thread.enable();
}
