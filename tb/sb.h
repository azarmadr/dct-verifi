#include "systemc.h"
#include "pkt.h"
enum check_t {PASS, FAIL, WAIT};
class sb : public sc_module{
   public:
      SC_HAS_PROCESS(checker);
      
      sb(sc_module_name name) : sc_module(sb){
	 SC_THREAD(checker);
      }
      void checker(){
	 pkt*     mon_p,drv_p;
	 sc_event mon_in,drv_in;
	 
	 mon_p = new(pkt);
	 drv_p = new(pkt);

	 sc_out<check_t> sb_out;
	 sc_port<sc_fifo_in_if<pkt*> > mon_f,drv_f;
	 while (true){
	    wait();
	    SC_FORK
	       sc_spawn(mon_p,
	    mon_f -> read(mon_p);
	    drv_f -> read(drv_p);

