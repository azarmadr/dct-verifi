#include "pkt.h"
SC_MODULE(mon){
   sc_in<bool> clk;
   sc_in<bool> rst;
   sc_in<sc_bv< 8> > xin;
   sc_in<sc_bv<12> > dct;
   sc_in<sc_bv<11> > z_out;
   sc_in<sc_bv<19> > z;
   sc_in<bool> rdy_o;

   sc_event mrdy,drdy;
   sc_event_or_list mts;
   std::vector<sc_process_handle> m_thread;

   sc_port<sc_fifo_out_if<pkt*> > mon_f;

   sc_int<11> z_out_[64];
   sc_int<19> z_[64];
   sc_int<8> x_[64];

   void monitor();
   void zx();
   void zi();
   void dct_m(pkt* p);

   SC_CTOR(mon){
      SC_CTHREAD(zi,clk.pos());
      reset_signal_is(rst, true);
      SC_CTHREAD(monitor,clk.pos());
      reset_signal_is(rst, true);
   }
};
void mon::monitor(){
  wait();
  //while(true){
    pkt* p =new(pkt);
    for(int i=0;i<64;i++){
      wait();
      p->xin[i] = xin->read();
    }
    //cout<<"x from p"<<p->xin;
    m_thread.push_back(
        sc_spawn(
          sc_bind(&mon::dct_m,this, sc_ref(p))
          ));
  //}
}
void mon::zx(){
  wait();
  //while(1){
    int j=0;
    while(j>0){
      wait();
      j--;
    }
    for(int i=0;i<64;i++){
      wait();
      x_[i] = xin->read();
    }
    //cout<<"x"<<x_;
  //}
}
void mon::zi(){
  wait();
  //while(1){
    int j=15;
    while(j>0){
      wait();
      j--;
    }
    for(int i=0;i<64;i++){
      z_[i] = z->read();
      z_out_[i] = z_out->read();
      wait();
    }
    cout<<"z"<<z_;
    //cout<<"z_out"<<z_out_;
  //}
}
void mon::dct_m(pkt* p){
  wait(310,SC_NS);
  for(int i=0;i<64;i++){
    p->dct[(i%8)*8+i/8]= dct->read();
    wait(10,SC_NS);
  }
  mon_f->write(p);
}
