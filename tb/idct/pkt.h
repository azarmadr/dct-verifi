#ifndef PKT_H
#define PKT_H
#include <iomanip>
#include "systemc.h"
struct pkt{
   sc_int< 8> xin [64];
   sc_int<12> dct [64];
   inline bool operator == (const pkt& rhs) const{
      for(int i=0;i<64;i++){
	 if((xin[i]!=rhs.xin[i]) || (dct[i]!=rhs.dct[i])) {
           //cout<<"error @: "<<i;
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
#endif
