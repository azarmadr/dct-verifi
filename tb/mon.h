#include "pkt.h"
SC_MODULE(mon){
  SC_CTOR(mon){
    SC_THREAD(monitor);
    SC_THREAD(dct_1m);
    SC_THREAD(dct_m);
  }

  sc_in<bool>        clk;
  sc_in<bool>        rst;
  sc_in<sc_bv< 8> >  xin;
  sc_in<sc_bv<11> >  z1d;
  sc_in<sc_bv<12> >  dct;
  sc_in<bool>        rdy_o;

  std::vector<pkt*>               pkt_q;
  sc_port<sc_fifo_out_if<pkt*> >  pkt_f;

  void monitor(){
    pkt* p = NULL;
    wait(rst.negedge_event());
    for(;;){
      p = new pkt;
      pkt_q.push_back(p);
      for(int i = 0;i<64;i++){
        wait(clk.posedge_event());
        p->xin[i] = xin->read();
      }
    }
  }
  void dct_1m(){
    wait(rst.negedge_event());
    for(int i=0;i<14;i++) wait(clk.posedge_event());
    for(;;){
      pkt* p = pkt_q.back();
      for(int i=0;i<64;i++){
        wait(clk.posedge_event());
        p->z1d[i] = z1d->read();
      }
    }
  }
  void dct_m(){
    wait(rst.negedge_event());
    wait(rdy_o.posedge_event());
    for(;;){
      for(int i=0;i<64;i++){
        wait(clk.posedge_event());
        pkt_q.front()->dct[i]= dct->read();
      }
      pkt_f->write(pkt_q.front());
      pkt_q.erase(pkt_q.begin());
    }
  }
};
