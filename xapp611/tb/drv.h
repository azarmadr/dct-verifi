#include "pkt_gen.h"
SC_MODULE(drv){
  SC_CTOR(drv){
    SC_THREAD(driver);
  }

  sc_in<bool> clk;
  sc_in<bool> rst;
  sc_out<bool> rdy_i;
  sc_out<sc_bv<12> > dct_2d;

  sc_port<sc_fifo_in_if <pkt*> > drv_f;
  void driver(){
    wait(rst.negedge_event());
    rdy_i->write(0);
    wait(clk.posedge_event());
    for(;;){
      rdy_i->write(1);
      pkt* p = new (pkt);
      //if(drv_f->nb_read(p)) delete(drv_f->read());
      p = drv_f->read();
      //cout<<sc_time_stamp()<<*p;
      for(int i=0;i<64;i++){
        dct_2d->write(p->dct[i]);
        wait(clk.posedge_event());
    //cout<<endl<<sc_time_stamp()<<" drv: taskeru "<<i;
      }
    }
  }
};
