#ifndef PKT_H
#define PKT_H
#include "systemc.h"
struct pkt{
   //int id;
   sc_int< 8> xin [8][8];
   sc_int<12> dct [8][8];
   inline bool operator == (const pkt& rhs) const{
      return(dct == rhs.dct && xin == rhs.xin);
   }
};
inline ostream& operator << ( ostream& os, const pkt& p){
   os<<endl<<"xin\t\t\t\t\t\t\t\t\tdct"<<endl;
   for(int i=0;i<17;i++){
      os<<"---\t";
   }
   os<<endl;
   for(int i=0;i<8;i++){
      for(int j=0;j<8;j++){
         os<<std::dec<<p.xin[i][j]<<"\t";
      }
      cout<<"||\t";
      for(int j=0;j<8;j++){
	 os<<p.dct[i][j]<<"\t";
      }
      os<<endl;
   }
   return os;
}
template<int T>
inline 
ostream& operator << ( ostream& os, const sc_uint<T> (&a)[8][8]){
   os<<endl;
   for(int i=0;i<64;i++){
      os<<std::hex <<a[i/8][i%8]<<"\t";
      if(i%8==7) os<<endl;
   }
   return os;
}/*
template<int T>
inline 
ostream& operator << ( ostream& os, const sc_int<T> (&a)[8][8]){
   os<<endl;
   for(int i=0;i<64;i++){
      os<<a[i/8][i%8]<<"\t";
      if(i%8==7) os<<endl;
   }
   return os;
}*/
void dct_calc(pkt* p){
   sc_int<19> z[8][8];
   sc_int<20> temp [8][8];
   
   int c_t [8][8] = {
      {91, 126, 118, 106,  91,  71,  49,  25},
      {91, 106,  49, -25, -91,-126,-118, -71},
      {91,  71, -49,-126, -91,  25, 118, 106},
      {91,  25,-118, -71,  91, 106, -49,-126},
      {91, -25,-118,  71,  91,-106, -49, 126},
      {91, -71, -49, 126, -91, -25, 118,-106},
      {91,-106,  49,  25, -91, 126,-118,  71},
      {91,-126, 118,-106,  91, -71,  49, -25},
   };

   for(int k=0;k<8;k++){
      for(int i=0;i<8;i++){
	 temp[k][i] = 0;
	 z[k][i] = 0;
	 p->dct[k][i] = 0;
	 p->xin[k][i] = 2;//+(rand() % 52);
	 for(int j=0;j<8;j++){
	    z[k][i] += p->xin[k][j]*c_t[j][i];
	 }
	 for(int l=0;l<8;l++){
	    temp[k][i] += c_t[l][k]*z[l][i];
	    p->dct[k][i] = temp[k][i];
	 }/*
	 p->dct[k][i] = temp[k][i].range(19,8);
	 if(temp[k][i][7]) p->dct[k][i]++;*/
      }
   }
}
#endif
