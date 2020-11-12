#include "pkt_gen.h"
SC_MODULE(drv){
  sc_in<bool> clk;
  sc_in<bool> rst;
  sc_out<sc_bv< 8> > xin;
  sc_in<bool> rdy_o;

  sc_port<sc_fifo_in_if <pkt*> > drv_f;

  void driver();

  SC_CTOR(drv){
    SC_THREAD(driver);
  }
};
void drv::driver(){
  wait(rst.negedge_event());
  wait(clk.posedge_event());
  for(;;){
    pkt* p = new (pkt);
    p = drv_f->read();
    //cout<<sc_time_stamp()<<*p;
    for(int i=0;i<64;i++){
      xin->write(p->xin[i]);
      wait(clk.posedge_event());
    }
  }
}
