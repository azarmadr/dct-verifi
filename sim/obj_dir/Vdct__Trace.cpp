// Verilated -*- SystemC -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_sc.h"
#include "Vdct__Syms.h"


void Vdct::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    Vdct__Syms* __restrict vlSymsp = static_cast<Vdct__Syms*>(userp);
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void Vdct::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    Vdct__Syms* __restrict vlSymsp = static_cast<Vdct__Syms*>(userp);
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[0U])) {
            tracep->chgIData(oldp+0,(vlTOPp->dct__DOT__unnamedblk1__DOT__itemp),32);
        }
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[1U])) {
            tracep->chgBit(oldp+1,(vlTOPp->__Vcellinp__dct__CLK));
            tracep->chgBit(oldp+2,(vlTOPp->__Vcellinp__dct__RST));
            tracep->chgCData(oldp+3,(vlTOPp->__Vcellinp__dct__xin),8);
            tracep->chgBit(oldp+4,(vlTOPp->dct__DOT__en_ram1));
            tracep->chgBit(oldp+5,(vlTOPp->dct__DOT__en_dct2d));
        }
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[2U])) {
            tracep->chgSData(oldp+6,((0xfffU & ((0x80U 
                                                 & vlTOPp->dct__DOT__dct_2d_int)
                                                 ? 
                                                ((IData)(1U) 
                                                 + 
                                                 (vlTOPp->dct__DOT__dct_2d_int 
                                                  >> 8U))
                                                 : 
                                                (vlTOPp->dct__DOT__dct_2d_int 
                                                 >> 8U)))),12);
            tracep->chgBit(oldp+7,((0x5eU == (IData)(vlTOPp->dct__DOT__cntr92))));
            tracep->chgCData(oldp+8,(vlTOPp->dct__DOT__memory1a),8);
            tracep->chgCData(oldp+9,(vlTOPp->dct__DOT__memory2a),8);
            tracep->chgCData(oldp+10,(vlTOPp->dct__DOT__memory3a),8);
            tracep->chgCData(oldp+11,(vlTOPp->dct__DOT__memory4a),8);
            tracep->chgCData(oldp+12,(vlTOPp->dct__DOT__xa0_in),8);
            tracep->chgCData(oldp+13,(vlTOPp->dct__DOT__xa1_in),8);
            tracep->chgCData(oldp+14,(vlTOPp->dct__DOT__xa2_in),8);
            tracep->chgCData(oldp+15,(vlTOPp->dct__DOT__xa3_in),8);
            tracep->chgCData(oldp+16,(vlTOPp->dct__DOT__xa4_in),8);
            tracep->chgCData(oldp+17,(vlTOPp->dct__DOT__xa5_in),8);
            tracep->chgCData(oldp+18,(vlTOPp->dct__DOT__xa6_in),8);
            tracep->chgCData(oldp+19,(vlTOPp->dct__DOT__xa7_in),8);
            tracep->chgSData(oldp+20,(vlTOPp->dct__DOT__xa0_reg),9);
            tracep->chgSData(oldp+21,(vlTOPp->dct__DOT__xa1_reg),9);
            tracep->chgSData(oldp+22,(vlTOPp->dct__DOT__xa2_reg),9);
            tracep->chgSData(oldp+23,(vlTOPp->dct__DOT__xa3_reg),9);
            tracep->chgSData(oldp+24,(vlTOPp->dct__DOT__xa4_reg),9);
            tracep->chgSData(oldp+25,(vlTOPp->dct__DOT__xa5_reg),9);
            tracep->chgSData(oldp+26,(vlTOPp->dct__DOT__xa6_reg),9);
            tracep->chgSData(oldp+27,(vlTOPp->dct__DOT__xa7_reg),9);
            tracep->chgSData(oldp+28,(vlTOPp->dct__DOT__add_sub1a),9);
            tracep->chgSData(oldp+29,(vlTOPp->dct__DOT__add_sub2a),9);
            tracep->chgSData(oldp+30,(vlTOPp->dct__DOT__add_sub3a),9);
            tracep->chgSData(oldp+31,(vlTOPp->dct__DOT__add_sub4a),9);
            tracep->chgCData(oldp+32,(vlTOPp->dct__DOT__addsub1a_comp),8);
            tracep->chgCData(oldp+33,(vlTOPp->dct__DOT__addsub2a_comp),8);
            tracep->chgCData(oldp+34,(vlTOPp->dct__DOT__addsub3a_comp),8);
            tracep->chgCData(oldp+35,(vlTOPp->dct__DOT__addsub4a_comp),8);
            tracep->chgBit(oldp+36,(vlTOPp->dct__DOT__save_sign1a));
            tracep->chgBit(oldp+37,(vlTOPp->dct__DOT__save_sign2a));
            tracep->chgBit(oldp+38,(vlTOPp->dct__DOT__save_sign3a));
            tracep->chgBit(oldp+39,(vlTOPp->dct__DOT__save_sign4a));
            tracep->chgIData(oldp+40,(vlTOPp->dct__DOT__p1a),19);
            tracep->chgIData(oldp+41,(vlTOPp->dct__DOT__p2a),19);
            tracep->chgIData(oldp+42,(vlTOPp->dct__DOT__p3a),19);
            tracep->chgIData(oldp+43,(vlTOPp->dct__DOT__p4a),19);
            tracep->chgQData(oldp+44,(vlTOPp->dct__DOT__p1a_all),36);
            tracep->chgQData(oldp+46,(vlTOPp->dct__DOT__p2a_all),36);
            tracep->chgQData(oldp+48,(vlTOPp->dct__DOT__p3a_all),36);
            tracep->chgQData(oldp+50,(vlTOPp->dct__DOT__p4a_all),36);
            tracep->chgCData(oldp+52,(vlTOPp->dct__DOT__i_wait),2);
            tracep->chgBit(oldp+53,(vlTOPp->dct__DOT__toggleA));
            tracep->chgIData(oldp+54,(vlTOPp->dct__DOT__z_out_int1),19);
            tracep->chgIData(oldp+55,(vlTOPp->dct__DOT__z_out_int2),19);
            tracep->chgIData(oldp+56,(vlTOPp->dct__DOT__z_out_int),19);
            tracep->chgIData(oldp+57,(vlTOPp->dct__DOT__indexi),32);
            tracep->chgCData(oldp+58,(vlTOPp->dct__DOT__cntr12),4);
            tracep->chgCData(oldp+59,(vlTOPp->dct__DOT__cntr8),4);
            tracep->chgCData(oldp+60,(vlTOPp->dct__DOT__cntr79),7);
            tracep->chgCData(oldp+61,(vlTOPp->dct__DOT__cntr92),7);
            tracep->chgBit(oldp+62,(vlTOPp->dct__DOT__en_dct2d_reg));
            tracep->chgSData(oldp+63,(vlTOPp->dct__DOT__xb0_in),11);
            tracep->chgSData(oldp+64,(vlTOPp->dct__DOT__xb1_in),11);
            tracep->chgSData(oldp+65,(vlTOPp->dct__DOT__xb2_in),11);
            tracep->chgSData(oldp+66,(vlTOPp->dct__DOT__xb3_in),11);
            tracep->chgSData(oldp+67,(vlTOPp->dct__DOT__xb4_in),11);
            tracep->chgSData(oldp+68,(vlTOPp->dct__DOT__xb5_in),11);
            tracep->chgSData(oldp+69,(vlTOPp->dct__DOT__xb6_in),11);
            tracep->chgSData(oldp+70,(vlTOPp->dct__DOT__xb7_in),11);
            tracep->chgSData(oldp+71,(vlTOPp->dct__DOT__xb0_reg),12);
            tracep->chgSData(oldp+72,(vlTOPp->dct__DOT__xb1_reg),12);
            tracep->chgSData(oldp+73,(vlTOPp->dct__DOT__xb2_reg),12);
            tracep->chgSData(oldp+74,(vlTOPp->dct__DOT__xb3_reg),12);
            tracep->chgSData(oldp+75,(vlTOPp->dct__DOT__xb4_reg),12);
            tracep->chgSData(oldp+76,(vlTOPp->dct__DOT__xb5_reg),12);
            tracep->chgSData(oldp+77,(vlTOPp->dct__DOT__xb6_reg),12);
            tracep->chgSData(oldp+78,(vlTOPp->dct__DOT__xb7_reg),12);
            tracep->chgSData(oldp+79,(vlTOPp->dct__DOT__add_sub1b),12);
            tracep->chgSData(oldp+80,(vlTOPp->dct__DOT__add_sub2b),12);
            tracep->chgSData(oldp+81,(vlTOPp->dct__DOT__add_sub3b),12);
            tracep->chgSData(oldp+82,(vlTOPp->dct__DOT__add_sub4b),12);
            tracep->chgSData(oldp+83,(vlTOPp->dct__DOT__addsub1b_comp),11);
            tracep->chgSData(oldp+84,(vlTOPp->dct__DOT__addsub2b_comp),11);
            tracep->chgSData(oldp+85,(vlTOPp->dct__DOT__addsub3b_comp),11);
            tracep->chgSData(oldp+86,(vlTOPp->dct__DOT__addsub4b_comp),11);
            tracep->chgBit(oldp+87,(vlTOPp->dct__DOT__save_sign1b));
            tracep->chgBit(oldp+88,(vlTOPp->dct__DOT__save_sign2b));
            tracep->chgBit(oldp+89,(vlTOPp->dct__DOT__save_sign3b));
            tracep->chgBit(oldp+90,(vlTOPp->dct__DOT__save_sign4b));
            tracep->chgIData(oldp+91,(vlTOPp->dct__DOT__p1b),20);
            tracep->chgIData(oldp+92,(vlTOPp->dct__DOT__p2b),20);
            tracep->chgIData(oldp+93,(vlTOPp->dct__DOT__p3b),20);
            tracep->chgIData(oldp+94,(vlTOPp->dct__DOT__p4b),20);
            tracep->chgQData(oldp+95,(vlTOPp->dct__DOT__p1b_all),36);
            tracep->chgQData(oldp+97,(vlTOPp->dct__DOT__p2b_all),36);
            tracep->chgQData(oldp+99,(vlTOPp->dct__DOT__p3b_all),36);
            tracep->chgQData(oldp+101,(vlTOPp->dct__DOT__p4b_all),36);
            tracep->chgBit(oldp+103,(vlTOPp->dct__DOT__toggleB));
            tracep->chgIData(oldp+104,(vlTOPp->dct__DOT__dct2d_int1),20);
            tracep->chgIData(oldp+105,(vlTOPp->dct__DOT__dct2d_int2),20);
            tracep->chgIData(oldp+106,(vlTOPp->dct__DOT__dct_2d_int),20);
            tracep->chgSData(oldp+107,((0xfffU & (vlTOPp->dct__DOT__dct_2d_int 
                                                  >> 8U))),12);
        }
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[3U])) {
            tracep->chgSData(oldp+108,(vlTOPp->dct__DOT__z_out_rnd),11);
            tracep->chgCData(oldp+109,(vlTOPp->dct__DOT__wr_cntr),7);
            tracep->chgCData(oldp+110,(vlTOPp->dct__DOT__rd_cntr),7);
            tracep->chgBit(oldp+111,(vlTOPp->dct__DOT__en_ram1reg));
        }
        tracep->chgSData(oldp+112,(vlTOPp->dct__DOT__data_out),11);
    }
}

void Vdct::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    Vdct__Syms* __restrict vlSymsp = static_cast<Vdct__Syms*>(userp);
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
        vlTOPp->__Vm_traceActivity[1U] = 0U;
        vlTOPp->__Vm_traceActivity[2U] = 0U;
        vlTOPp->__Vm_traceActivity[3U] = 0U;
    }
}
