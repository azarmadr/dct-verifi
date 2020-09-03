#ifndef PKT_H
#define PKT_H
#include <iomanip>
#include "systemc.h"
struct pkt{
   //int id;
   sc_uint< 8> xin [64];
   sc_uint<12> dct [64];
   inline bool operator == (const pkt& rhs) const{
      for(int i=0;i<64;i++){
	 if((xin[i]!=rhs.xin[i]) || (dct[i]!=rhs.dct[i])) return false;
      }
      return true;
   }
};
inline ostream& operator << ( ostream& os, const pkt& p){
   os<<endl<<"xin\t\t\t\t\t\t\t\t\tdct"<<endl;
   for(int i=0;i<17;i++)   os<<"---\t";
   os<<endl;
   for(int i=0;i<8;i++){
      for(int j=0;j<8;j++) os<<std::dec<<p.xin[j+i*8]<<"\t";
      cout<<"||\t";
      for(int j=0;j<8;j++) os<<p.dct[j+i*8]<<"\t";
      os<<endl;
   }
   return os;
}
template<int T>
inline
ostream& operator << ( ostream& os, const sc_uint<T> (&a)[64]){
   os<<endl;
   for(int i=0;i<64;i++){
      os<<std::hex <<a[i]<<"\t";
      if(i%8==7) os<<endl;
   }
   return os;
}
template<int T>
inline
ostream& operator << ( ostream& os, const sc_int<T> (&a)[64]){
   os<<endl;
   for(int i=0;i<64;i++){
      os<<a[i]<<"\t";
      if(i%8==7) os<<endl;
   }
   return os;
}
void dct_calc(pkt* p){
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

   //_init_matrices
   for(int i=0;i<64;i++){
      temp[i] = 0;
      z[i] = 0;
      p->dct[i] = 0;
      p->xin[i] =(rand() % 127);
   }
   //_1D_DCT
   for(int i=0;i<64;i++){
      for(int j=0;j<8;j++) z[i] += c_t[j*8+i%8]*p->xin[(i/8)*8+j];
      z_out[i] = z[i].range(18,8);
      if(z[i][7]) z_out[i]++;
   }
   //_2D_DCT
   for(int i=0;i<64;i++){
      for(int l=0;l<8;l++) temp[i] += c_t[l*8+i/8]*z_out[l*8+i%8];
      p->dct[i] = temp[i].range(19,8);
      if(temp[i][7]) p->dct[i]++;
   }
}
#endif
