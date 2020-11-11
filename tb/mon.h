#include "pkt.h"
SC_MODULE(mon){
   sc_in<bool>        clk;
   sc_in<bool>        rst;
   sc_in<sc_bv< 8> >  xin;
   sc_in<sc_bv<12> >  dct;
   sc_in<bool>        rdy_o;

   std::vector<pkt*>               pkt_q;
   sc_port<sc_fifo_out_if<pkt*> >  pkt_f;

   void monitor();
   void dct_m();

   SC_CTOR(mon){
      SC_THREAD(dct_m);
      SC_THREAD(monitor);
   }
};
void mon::monitor(){
  pkt* p = NULL;
  wait(rst.negedge_event());
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
  wait(rst.negedge_event());
  wait(rdy_o.posedge_event());
  for(;;){
    for(int i=0;i<64;i++){
      wait(clk.posedge_event());
      pkt_q.front()->dct[(i%8)*8+i/8]= dct->read();
    }
    pkt_f->write(pkt_q.front());
    pkt_q.erase(pkt_q.begin());
  }
}
