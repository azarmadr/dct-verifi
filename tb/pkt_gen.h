#ifndef GEN_H
#define GEN_H
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include "pkt.h"
using std::string;
using std::vector;
using std::stringstream;

SC_MODULE(gen){
  SC_CTOR(gen){
    done = 0;
    parse_img();
    SC_THREAD(drv_pkt);
    SC_THREAD(mon_pkt);
  }
  bool done;
  int error_p,matched_p,total_p,pkt_c;

  vector <pkt*> pkt_v;
  sc_port<sc_fifo_in_if <pkt*> > pkt_f;
  sc_port<sc_fifo_out_if<pkt*> > drv_f;

  void parse_img(){
    fstream gs;
    gs.open("../gs.txt",std::ios::in);

    sc_int<19> z[64];
    sc_int<11> z_out[64];
    sc_int<20> temp [64];

    int c_t [64] = {
      91, 126, 118, 106,  91,  71,  49,  25,
      91, 106,  49, -25, -91,-126,-118, -71,
      91,  71, -49,-126, -91,  25, 118, 106,
      91,  25,-118, -71,  91, 106, -49,-126,
      91, -25,-118,  71,  91,-106, -49, 126,
      91, -71, -49, 126, -91, -25, 118,-106,
      91,-106,  49,  25, -91, 126,-118,  71,
      91,-126, 118,-106,  91, -71,  49, -25,
    };
    if (gs.is_open()){
      string  xin;
      while(getline(gs, xin)){
        pkt* p = new pkt;
        stringstream stream(xin);
        //_init_matrices
        for(int i=0;i<64;i++){
          stream >> p->xin[i];
          //p->xin[i] = -27;
          temp[i] = 0;
          z[i] = 0;
          p->dct[i] = 0;
        }
        //_1D_DCT
        for(int i=0;i<64;i++){
          for(int j=0;j<8;j++) z[i] += c_t[j*8+i%8]*p->xin[(i/8)*8+j];
          //z_out[i] = z[i].range(18,8);
          //if(z[i][7]) z_out[i]++;
          z_out[i] = z[i]/256;
        }
        //_2D_DCT
        for(int i=0;i<64;i++){
          for(int j=0;j<8;j++) temp[i] += c_t[j*8+i/8]*z_out[j*8+i%8];
          p->dct[i] = temp[i].range(19,8);
          if(temp[i][7]) p->dct[i]++;
        }
        pkt_v.push_back(p);
      }
    }
    else{
      cout<<"gen: failed to open file"<<endl;
    }
  }
  void mon_pkt(){
    for (int i=0;i<pkt_v.size();i++){
      wait(pkt_f->data_written_event());
      pkt* p = new pkt;
        ++total_p;
      p = pkt_f->read();
      if(*p == *pkt_v[i]) cout<<total_p<<"--"<<++matched_p<<"\t";
      else cout<<total_p<<"--"<<++error_p<<"\t";
      if(*p == *pkt_v[i]) cout<<"seko"<<endl;
      cout<<*p << *pkt_v[i];
    }
    cout<<"sb: "<<matched_p<<" with errors "<<error_p<<endl;
    done = 1;
  }
  void drv_pkt(){
    for (int i=0;i<pkt_v.size();i++){
      drv_f->write(pkt_v[i]);
    }
  }
};
#endif
