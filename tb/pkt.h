#ifndef PKT_H
#define PKT_H
#include "systemc.h"
struct pkt{
   //int id;
   sc_uint<8>  xin [8][8];
   sc_uint<12> dct [8][8];
   inline bool operator == (const pkt& rhs) const{
      return(dct == rhs.dct && xin == rhs.xin);
   }
};
inline ostream& operator << ( ostream& os, const pkt& p){
   os<<endl<<"xin\t\t\t\t\t\t\t\tdct"<<endl;
   for(int i=0;i<8;i++){
      os<<"---\t---\t";
   }
   os<<endl;
   for(int i=0;i<8;i++){
      for(int j=0;j<8;j++){
         os<<p.xin[i][j]<<"\t";
      }
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
   sc_uint<20> temp [8][8];
   for(int k = 0; k<8;k++){
      for(int i=0;i<8;i++){
	 temp[k][i] = 0;
	 p->dct[k][i] = 0;
	 p->xin[k][i] = rand();
      }
   }
   for(int k = 0; k<8;k++){
      for(int i=0;i<8;i++){
	 temp[k][0] += 23170*p->xin[k][i];
      }
      temp[k][1] = 32138*(p->xin[k][0]-p->xin[k][7])
	 + 27246*(p->xin[k][1]-p->xin[k][6])
	 + 18205*(p->xin[k][2]-p->xin[k][5])
	 +  6393*(p->xin[k][3]-p->xin[k][4]);

      temp[k][2] = 30274*(p->xin[k][0]+p->xin[k][7])
	 + 12540*(p->xin[k][1]+p->xin[k][6])
	 - 12540*(p->xin[k][2]+p->xin[k][5])
	 - 30274*(p->xin[k][3]+p->xin[k][4]);

      temp[k][3] = 27246*(p->xin[k][0]-p->xin[k][7])
	 -  6393*(p->xin[k][1]-p->xin[k][6])
	 - 32128*(p->xin[k][2]-p->xin[k][5])
	 - 18205*(p->xin[k][3]-p->xin[k][4]);

      temp[k][4] = 23170*(p->xin[k][0]+p->xin[k][7])
	 - 23170*(p->xin[k][1]+p->xin[k][6])
	 - 23170*(p->xin[k][2]+p->xin[k][5])
	 + 23170*(p->xin[k][3]+p->xin[k][4]);

      temp[k][5] = 18205*(p->xin[k][0]-p->xin[k][7])
	 - 32128*(p->xin[k][1]-p->xin[k][6])
	 +  6393*(p->xin[k][2]-p->xin[k][5])
	 + 27246*(p->xin[k][3]-p->xin[k][4]);

      temp[k][6] = 12540*(p->xin[k][0]+p->xin[k][7])
	 - 30274*(p->xin[k][1]+p->xin[k][6])
	 + 30274*(p->xin[k][2]+p->xin[k][5])
	 - 12540*(p->xin[k][3]+p->xin[k][4]);

      temp[k][7] =  6393*(p->xin[k][0]-p->xin[k][7])
	 - 18205*(p->xin[k][1]-p->xin[k][6])
	 + 27246*(p->xin[k][2]-p->xin[k][5])
	 - 32128*(p->xin[k][3]-p->xin[k][4]);
   }
   //cout<<temp<<endl;
   for(int k=0;k<8;k++){
      for(int j=0;j<8;j++){
	 p->dct[0][k] += 23170*temp[j][k];
      }
      p->dct[1][k] = 32138*(temp[0][k] - temp[7][k])
	 + 27246*(temp[1][k] - temp[6][k])
	 + 18205*(temp[2][k] - temp[5][k])
	 +  6393*(temp[3][k] - temp[4][k]);

      p->dct[2][k] = 30274*(temp[0][k] + temp[7][k])
	 + 12540*(temp[1][k] + temp[6][k])
	 - 12540*(temp[2][k] + temp[5][k])
	 - 30274*(temp[3][k] + temp[4][k]);

      p->dct[3][k] = 27246*(temp[0][k] - temp[7][k])
	 -  6393*(temp[1][k] - temp[6][k])
	 - 32138*(temp[2][k] - temp[5][k])
	 - 18205*(temp[3][k] - temp[4][k]);

      p->dct[4][k] = 23170*(temp[0][k] + temp[7][k])
	 - 23170*(temp[1][k] + temp[6][k])
	 - 23170*(temp[2][k] + temp[5][k])
	 + 23170*(temp[3][k] + temp[4][k]);

      p->dct[5][k] = 18205*(temp[0][k] - temp[7][k])
	 - 32138*(temp[1][k] - temp[6][k])
	 +  6393*(temp[2][k] - temp[5][k])
	 + 27246*(temp[3][k] - temp[4][k]);

      p->dct[6][k] = 12540*(temp[0][k] + temp[7][k])
	 - 30274*(temp[1][k] + temp[6][k])
	 + 30274*(temp[2][k] + temp[5][k])
	 - 12540*(temp[3][k] + temp[4][k]);

      p->dct[7][k] =  6393*(temp[0][k] - temp[7][k])
	 - 18205*(temp[1][k] - temp[6][k])
	 + 27246*(temp[2][k] - temp[5][k])
	 - 32138*(temp[3][k] - temp[4][k]);
   }
}
#endif
