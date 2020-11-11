#include "pkt.h"
class sb : public sc_module{
  public:

    bool done;
    int error_p,matched_p,total_p,pkt_c;

    sc_port<sc_fifo_in_if<pkt*> > mon_f,drv_f;

    SC_HAS_PROCESS(sb);

    sb(sc_module_name name) : sc_module(name){
      done = false;

      SC_THREAD(checker);
    }

    void checker(){
      pkt* mon_p = new(pkt);
      pkt* drv_p = new(pkt);

      wait(20,SC_NS);
      while(pkt_c--){
        wait(mon_f->data_written_event() & drv_f->data_written_event());
        mon_p = mon_f->read();
        drv_p = drv_f->read();
        ++total_p;
        if(*mon_p == *drv_p) cout<<total_p<<"--"<<++matched_p<<"\t";
          //cout << "packets matched" <<endl;
        else cout<<total_p<<"--"<<++error_p<<"\t";
        //if(error_p<3)
          cout<<"\nmon: "<< *mon_p<<"gen: "<< *drv_p;
      }
      //cout<<"sb: "<<matched_p<<" with errors "<<error_p<<endl;
      done = true;
    }
};
