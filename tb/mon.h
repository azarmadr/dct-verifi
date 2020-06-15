#include "pkt.h"

SC_MODULE(mon){
   sc_in<bool> clk;
   sc_in<sc_int<8> > xin;
   sc_in<sc_int<12> > dct;
   sc_in<bool> rdy_o;
   
   sc_port<sc_fifo_out_if<pkt*> > mon_f;
   
   void monitor();

   SC_CTOR(mon){
      SC_THREAD(monitor);
      sensitive<<xin<<dct<<rdy_o<<clk.pos();
   }
};
void mon::monitor(){
   wait();
   while(true){
      pkt* p;p=new(pkt);
      for(int i=0;i<64;i++){
	 p->xin[i/8][i%8]=xin;
	 wait();
      }
      if(rdy_o){
	 wait(dct);
	 for(int i=0;i<64;i++){
	    p->dct[i/8][i%8]=dct;
	    wait();
	 }
      }
      mon_ap->write(p);
      wait();
   }
}
