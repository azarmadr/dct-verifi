#include "pkt.h"
SC_MODULE(mon){
   sc_in<bool> clk;
   sc_in<bool> rst;
   sc_in<sc_bv< 8> > xin;
   sc_in<sc_bv<12> > dct;
   sc_in<bool> rdy_o;

   sc_event mrdy,drdy;
   sc_event_or_list mts;
   std::vector<pkt*> pkt_q;
   std::vector<sc_process_handle> m_thread;

   sc_port<sc_fifo_out_if<pkt*> > mon_f;

   sc_int<11> z_out_[64];
   sc_int<19> z_[64];
   sc_int<8> x_[64];

   void monitor();
   void dct_m();

   SC_CTOR(mon){
      SC_THREAD(dct_m);
      reset_signal_is(rst, true);
      SC_THREAD(monitor);
      reset_signal_is(rst, true);
   }
};
void mon::monitor(){
  pkt* p = NULL;
  wait(clk.posedge_event());
  for(;;){
    p = new pkt;
    for(int i = 0;i<64;i++){
      wait(clk.posedge_event());
      p->xin[i] = xin->read();
    }
    pkt_q.push_back(p);
  }
}
void mon::dct_m(){
  wait(rdy_o.posedge_event());
  for(;;){
    for(int i=0;i<64;i++){
      wait(clk.posedge_event());
      pkt_q.front()->dct[(i%8)*8+i/8]= dct->read();
    }
    mon_f->write(pkt_q.front());
    pkt_q.erase(pkt_q.begin());
  }
}
