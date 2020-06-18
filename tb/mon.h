#include "pkt.h"

SC_MODULE(mon){
   sc_in<bool> clk;
   sc_in<uint32_t> xin;
   sc_in<uint32_t> dct;
   sc_in<bool> rdy_o;
   
   sc_event mrdy,vrdy;

   sc_port<sc_fifo_out_if<pkt*> > mon_f;
   
   void monitor();
   void xin_m();
   void dct_m();
   void Vrdy();

   SC_CTOR(mon){
      SC_THREAD(monitor);
      sensitive<<dct<<xin;
      SC_THREAD(Vrdy);
      sensitive<<rdy_o.pos();
   }
};
void mon::monitor(){
   while(true){
      pkt* p =new(pkt);
	 wait();
	 wait();
      for(int i=0;i<64;i++){
	 wait();
	 p->xin[i/8][i%8]=(sc_uint<8>) xin->read();
      }
      mrdy.notify();
      wait(vrdy);
      for(int i=0;i<64;i++){
	 p->dct[i/8][i%8]=(sc_uint<12>) dct->read();
	 p->dct[i/8][i%8]=dct;
	 wait();
      }
      mon_f->write(p);
      cout<<"@"<<sc_time_stamp()<<" "<<*p<<endl;
      wait();
   }
}
void mon::Vrdy(){
   wait(mrdy);
   wait();
   vrdy.notify();
}
