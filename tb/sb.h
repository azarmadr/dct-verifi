#include "pkt.h"
class sb : public sc_module{
  public:

    bool done;
    int count;

    sc_port<sc_fifo_in_if<pkt*> > mon_f,drv_f;

    SC_HAS_PROCESS(sb);

    sb(sc_module_name name) : sc_module(name){
      done = false;

      SC_THREAD(checker);
    }

    void checker(){
      pkt* mon_p = new(pkt);
      pkt* drv_p = new(pkt);

      while (count>0){
        wait(1, SC_NS);
        SC_FORK
          sc_spawn(&mon_p,
              sc_bind(&sb::get_pkt, this, sc_ref(mon_f))),
          sc_spawn(&drv_p,
              sc_bind(&sb::get_pkt, this, sc_ref(drv_f))),
        SC_JOIN
        if(*mon_p == *drv_p) cout << "packets matched" <<endl;
        cout <<"\nobserved values"<< *mon_p << *drv_p;
        wait(1, SC_NS);
        count--;
      }
      done = true;
    }

    pkt* get_pkt(sc_port<sc_fifo_in_if<pkt*> >& f){
      return(f -> read());
    }
};
