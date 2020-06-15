#include "systemc.h"
#include "pkt.h"
class sb : public sc_module{
   sc_out<bool> sb_out;
   sc_port<sc_fifo_in_if<pkt*> > mon_f,drv_f;
   
   SC_HAS_PROCESS(checker);
   
   sb(sc_module_name name) : sc_module(sb){
      SC_THREAD(checker);
   }

   void checker(){
      pkt*     mon_p,drv_p;
      sc_event mon_in,drv_in;
      
      mon_p = new(pkt);
      drv_p = new(pkt);

      while (true){
	 wait(1, SC_NS);
	 SC_FORK
	    sc_spawn(mon_p,
		  sc_bind(&sb::get_pkt, this, mon_f));
	    sc_spawn(drv_p,
		  sc_bind(&sb::get_pkt, this, drv_f));
	 SC_JOIN
	 sb_out = mon_p == drv_p;
	 cout << sb_out << ": packets match status" <<endl;
	 wait(1, SC_NS);
      }
   }

   pkt* get_packet(sc_port<sc_fifo_in_if<pkt*> >& f){
      return(f -> read());
   }
};
