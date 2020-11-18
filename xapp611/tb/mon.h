#include "pkt.h"
SC_MODULE(mon){
  SC_CTOR(mon){
    SC_THREAD(dct_m);
    SC_THREAD(monitor);
  }
  sc_in<bool>        clk;
  sc_in<bool>        rst;
  sc_in<sc_bv< 8> >  idct_2d;
  sc_in<sc_bv<12> >  dct;
  sc_in<bool>        rdy_i;

  std::vector<pkt*>               pkt_q;
  sc_port<sc_fifo_out_if<pkt*> >  pkt_f;

  void monitor(){
    pkt* p = NULL;
    wait(rst.negedge_event());
    wait(rdy_i.posedge_event());
    for(;;){
      p = new pkt;
      for(int i = 0;i<64;i++){
        wait(clk.posedge_event());
        p->dct[i] = dct->read();
      }
      pkt_q.push_back(p);
    }
  }
  void dct_m(){
    wait(rst.negedge_event());
    wait(clk.posedge_event());
    wait(940,SC_NS);
    for(;;){
      cout<<"S";
      for(int i=0;i<64;i++){
        wait(clk.posedge_event());
        pkt_q.front()->xin[(i%8)*8+i/8]= idct_2d->read();
      }
      pkt_f->write(pkt_q.front());
      pkt_q.erase(pkt_q.begin());
    }
  }
};
