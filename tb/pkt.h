#ifndef PKT_H
#define PKT_H
#include <iomanip>
#include "systemc.h"
struct pkt{
   //int id;
   sc_int< 8> xin [64];
   sc_int<12> dct [64];
   inline bool operator == (const pkt& rhs) const{
      for(int i=0;i<64;i++){
	 if((xin[i]!=rhs.xin[i]) || (dct[i]!=rhs.dct[i])) {
           cout<<"error @: "<<i;
           return false;
         }
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
   int xin [64] = {
     127, 127, 99,  76,  76,  75,  64,  89,
     87,  61,  39,  38,  32,  7,   39,  116,
     41, -13, -29, -29, -29, -46, -1,   92,
     18, -38, -42, -40, -44, -65,  67,  61,
     127, 127, 103, 111, 112, 54,  123, 104,
     127, 127,-107, 117, 98,  41,  101, 119,
     127, 127, 94,  123, 46,  81,  46,  35,
     127, 127, 93,  56,  77,  120, 121, 92
   };
   //for (int i=0;i<64;i++) xin[i] = 0;
   //for (int i=0;i<8;i++) xin[i+0] = -3;
   //for (int i=0;i<8;i++) xin[i+8] = -3;
   //for (int i=0;i<8;i++) xin[8*i+0] = -3;
   //for (int i=0;i<8;i++) xin[8*i+1] = -27;
   //xin[0] = -11;

   //_init_matrices
   for(int i=0;i<64;i++){
      temp[i] = 0;
      z[i] = 0;
      p->dct[i] = 0;
      p->xin[i] = xin[i];
      p->xin[i] =(rand() % 255 -128);
   }
   //_1D_DCT
   for(int i=0;i<64;i++){
      for(int j=0;j<8;j++) z[i] += c_t[j*8+i%8]*p->xin[(i/8)*8+j];
      z_out[i] = z[i].range(18,8);
      if(z[i][7]) z_out[i]++;
   }
   //_2D_DCT
   for(int i=0;i<64;i++){
      for(int j=0;j<8;j++) temp[i] += c_t[j*8+i/8]*z_out[j*8+i%8];
      p->dct[i] = temp[i].range(19,8);
      if(temp[i][7]) p->dct[i]++;
   }
   //cout<<"pkt-z"<<z;
   //cout<<"pkt-z_out"<<z_out;
   //cout<<temp;
}
#endif
