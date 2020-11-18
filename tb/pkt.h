#ifndef PKT_H
#define PKT_H
#include <iomanip>
#include "systemc.h"
struct pkt{
   sc_int< 8> xin [64];
   sc_int<11> z1d [64];
   sc_int<12> dct [64];
   inline bool operator == (const pkt& rhs) const{
      for(int i=0;i<64;i++){
	 if(xin[i]!=rhs.xin[i]) {
           cout<<"pkt: error in xin @: "<<i;
           return false;
         }
      }
      for(int i=0;i<64;i++){
	 if(z1d[i]!=rhs.z1d[i]) {
           cout<<"pkt: error in z1d @: "<<i;
           return false;
         }
      }
      for(int i=0;i<64;i++){
	 if(dct[i]!=rhs.dct[i]) {
           cout<<"pkt: error in dct @: "<<i;
           return false;
         }
      }
      return true;
   }
};
inline ostream& operator << ( ostream& os, const pkt& p){
   os<<endl<<"xin\t\t\t\t\t\t\t\t\tz1d\t\t\t\t\t\t\t\t\tdct"<<endl;
   for(int i=0;i<17;i++)   os<<"---\t";
   os<<endl;
   for(int i=0;i<8;i++){
      for(int j=0;j<8;j++) os<<std::dec<<p.xin[j+i*8]<<"\t";
      cout<<"||\t";
      for(int j=0;j<8;j++) os<<p.z1d[j+i*8]<<"\t";
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
