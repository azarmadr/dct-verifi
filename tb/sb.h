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

      while (count--){
        wait(mon_f->data_written_event() & drv_f->data_written_event());
        mon_p = mon_f->read();
        drv_p = drv_f->read();
        if(*mon_p == *drv_p) cout << "packets matched" <<endl;
        else cout<<"\nobserved values"<< *mon_p << *drv_p;
      }
      done = true;
    }
};
