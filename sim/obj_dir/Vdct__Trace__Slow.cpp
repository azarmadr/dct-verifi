// Verilated -*- SystemC -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_sc.h"
#include "Vdct__Syms.h"


//======================

void Vdct::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addInitCb(&traceInit, __VlSymsp);
    traceRegister(tfp->spTrace());
}

void Vdct::traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vdct__Syms* __restrict vlSymsp = static_cast<Vdct__Syms*>(userp);
    if (!Verilated::calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->module(vlSymsp->name());
    tracep->scopeEscape(' ');
    Vdct::traceInitTop(vlSymsp, tracep);
    tracep->scopeEscape('.');
}

//======================


void Vdct::traceInitTop(void* userp, VerilatedVcd* tracep) {
    Vdct__Syms* __restrict vlSymsp = static_cast<Vdct__Syms*>(userp);
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceInitSub0(userp, tracep);
    }
}

void Vdct::traceInitSub0(void* userp, VerilatedVcd* tracep) {
    Vdct__Syms* __restrict vlSymsp = static_cast<Vdct__Syms*>(userp);
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    const int c = vlSymsp->__Vm_baseCode;
    if (false && tracep && c) {}  // Prevent unused
    // Body
    {
        tracep->declBus(c+7,"dct dct_2d", false,-1, 11,0);
        tracep->declBit(c+2,"dct CLK", false,-1);
        tracep->declBit(c+3,"dct RST", false,-1);
        tracep->declBus(c+4,"dct xin", false,-1, 7,0);
        tracep->declBit(c+8,"dct rdy_out", false,-1);
        tracep->declBus(c+9,"dct memory1a", false,-1, 7,0);
        tracep->declBus(c+10,"dct memory2a", false,-1, 7,0);
        tracep->declBus(c+11,"dct memory3a", false,-1, 7,0);
        tracep->declBus(c+12,"dct memory4a", false,-1, 7,0);
        tracep->declBus(c+13,"dct xa0_in", false,-1, 7,0);
        tracep->declBus(c+14,"dct xa1_in", false,-1, 7,0);
        tracep->declBus(c+15,"dct xa2_in", false,-1, 7,0);
        tracep->declBus(c+16,"dct xa3_in", false,-1, 7,0);
        tracep->declBus(c+17,"dct xa4_in", false,-1, 7,0);
        tracep->declBus(c+18,"dct xa5_in", false,-1, 7,0);
        tracep->declBus(c+19,"dct xa6_in", false,-1, 7,0);
        tracep->declBus(c+20,"dct xa7_in", false,-1, 7,0);
        tracep->declBus(c+21,"dct xa0_reg", false,-1, 8,0);
        tracep->declBus(c+22,"dct xa1_reg", false,-1, 8,0);
        tracep->declBus(c+23,"dct xa2_reg", false,-1, 8,0);
        tracep->declBus(c+24,"dct xa3_reg", false,-1, 8,0);
        tracep->declBus(c+25,"dct xa4_reg", false,-1, 8,0);
        tracep->declBus(c+26,"dct xa5_reg", false,-1, 8,0);
        tracep->declBus(c+27,"dct xa6_reg", false,-1, 8,0);
        tracep->declBus(c+28,"dct xa7_reg", false,-1, 8,0);
        tracep->declBus(c+29,"dct add_sub1a", false,-1, 8,0);
        tracep->declBus(c+30,"dct add_sub2a", false,-1, 8,0);
        tracep->declBus(c+31,"dct add_sub3a", false,-1, 8,0);
        tracep->declBus(c+32,"dct add_sub4a", false,-1, 8,0);
        tracep->declBus(c+33,"dct addsub1a_comp", false,-1, 7,0);
        tracep->declBus(c+34,"dct addsub2a_comp", false,-1, 7,0);
        tracep->declBus(c+35,"dct addsub3a_comp", false,-1, 7,0);
        tracep->declBus(c+36,"dct addsub4a_comp", false,-1, 7,0);
        tracep->declBit(c+37,"dct save_sign1a", false,-1);
        tracep->declBit(c+38,"dct save_sign2a", false,-1);
        tracep->declBit(c+39,"dct save_sign3a", false,-1);
        tracep->declBit(c+40,"dct save_sign4a", false,-1);
        tracep->declBus(c+41,"dct p1a", false,-1, 18,0);
        tracep->declBus(c+42,"dct p2a", false,-1, 18,0);
        tracep->declBus(c+43,"dct p3a", false,-1, 18,0);
        tracep->declBus(c+44,"dct p4a", false,-1, 18,0);
        tracep->declQuad(c+45,"dct p1a_all", false,-1, 35,0);
        tracep->declQuad(c+47,"dct p2a_all", false,-1, 35,0);
        tracep->declQuad(c+49,"dct p3a_all", false,-1, 35,0);
        tracep->declQuad(c+51,"dct p4a_all", false,-1, 35,0);
        tracep->declBus(c+53,"dct i_wait", false,-1, 1,0);
        tracep->declBit(c+54,"dct toggleA", false,-1);
        tracep->declBus(c+55,"dct z_out_int1", false,-1, 18,0);
        tracep->declBus(c+56,"dct z_out_int2", false,-1, 18,0);
        tracep->declBus(c+57,"dct z_out_int", false,-1, 18,0);
        tracep->declBus(c+109,"dct z_out_rnd", false,-1, 10,0);
        tracep->declBus(c+109,"dct z_out", false,-1, 10,0);
        tracep->declBus(c+58,"dct indexi", false,-1, 31,0);
        tracep->declBus(c+59,"dct cntr12", false,-1, 3,0);
        tracep->declBus(c+60,"dct cntr8", false,-1, 3,0);
        tracep->declBus(c+61,"dct cntr79", false,-1, 6,0);
        tracep->declBus(c+110,"dct wr_cntr", false,-1, 6,0);
        tracep->declBus(c+111,"dct rd_cntr", false,-1, 6,0);
        tracep->declBus(c+62,"dct cntr92", false,-1, 6,0);
        tracep->declBus(c+113,"dct data_out", false,-1, 10,0);
        tracep->declBit(c+5,"dct en_ram1", false,-1);
        tracep->declBit(c+6,"dct en_dct2d", false,-1);
        tracep->declBit(c+112,"dct en_ram1reg", false,-1);
        tracep->declBit(c+63,"dct en_dct2d_reg", false,-1);
        tracep->declBus(c+113,"dct data_out_final", false,-1, 10,0);
        tracep->declBus(c+64,"dct xb0_in", false,-1, 10,0);
        tracep->declBus(c+65,"dct xb1_in", false,-1, 10,0);
        tracep->declBus(c+66,"dct xb2_in", false,-1, 10,0);
        tracep->declBus(c+67,"dct xb3_in", false,-1, 10,0);
        tracep->declBus(c+68,"dct xb4_in", false,-1, 10,0);
        tracep->declBus(c+69,"dct xb5_in", false,-1, 10,0);
        tracep->declBus(c+70,"dct xb6_in", false,-1, 10,0);
        tracep->declBus(c+71,"dct xb7_in", false,-1, 10,0);
        tracep->declBus(c+72,"dct xb0_reg", false,-1, 11,0);
        tracep->declBus(c+73,"dct xb1_reg", false,-1, 11,0);
        tracep->declBus(c+74,"dct xb2_reg", false,-1, 11,0);
        tracep->declBus(c+75,"dct xb3_reg", false,-1, 11,0);
        tracep->declBus(c+76,"dct xb4_reg", false,-1, 11,0);
        tracep->declBus(c+77,"dct xb5_reg", false,-1, 11,0);
        tracep->declBus(c+78,"dct xb6_reg", false,-1, 11,0);
        tracep->declBus(c+79,"dct xb7_reg", false,-1, 11,0);
        tracep->declBus(c+80,"dct add_sub1b", false,-1, 11,0);
        tracep->declBus(c+81,"dct add_sub2b", false,-1, 11,0);
        tracep->declBus(c+82,"dct add_sub3b", false,-1, 11,0);
        tracep->declBus(c+83,"dct add_sub4b", false,-1, 11,0);
        tracep->declBus(c+84,"dct addsub1b_comp", false,-1, 10,0);
        tracep->declBus(c+85,"dct addsub2b_comp", false,-1, 10,0);
        tracep->declBus(c+86,"dct addsub3b_comp", false,-1, 10,0);
        tracep->declBus(c+87,"dct addsub4b_comp", false,-1, 10,0);
        tracep->declBit(c+88,"dct save_sign1b", false,-1);
        tracep->declBit(c+89,"dct save_sign2b", false,-1);
        tracep->declBit(c+90,"dct save_sign3b", false,-1);
        tracep->declBit(c+91,"dct save_sign4b", false,-1);
        tracep->declBus(c+92,"dct p1b", false,-1, 19,0);
        tracep->declBus(c+93,"dct p2b", false,-1, 19,0);
        tracep->declBus(c+94,"dct p3b", false,-1, 19,0);
        tracep->declBus(c+95,"dct p4b", false,-1, 19,0);
        tracep->declQuad(c+96,"dct p1b_all", false,-1, 35,0);
        tracep->declQuad(c+98,"dct p2b_all", false,-1, 35,0);
        tracep->declQuad(c+100,"dct p3b_all", false,-1, 35,0);
        tracep->declQuad(c+102,"dct p4b_all", false,-1, 35,0);
        tracep->declBit(c+104,"dct toggleB", false,-1);
        tracep->declBus(c+105,"dct dct2d_int1", false,-1, 19,0);
        tracep->declBus(c+106,"dct dct2d_int2", false,-1, 19,0);
        tracep->declBus(c+107,"dct dct_2d_int", false,-1, 19,0);
        tracep->declBus(c+108,"dct dct_2d_rnd", false,-1, 11,0);
        tracep->declBus(c+1,"dct unnamedblk1 itemp", false,-1, 31,0);
    }
}

void Vdct::traceRegister(VerilatedVcd* tracep) {
    // Body
    {
        tracep->addFullCb(&traceFullTop0, __VlSymsp);
        tracep->addChgCb(&traceChgTop0, __VlSymsp);
        tracep->addCleanupCb(&traceCleanup, __VlSymsp);
    }
}

void Vdct::traceFullTop0(void* userp, VerilatedVcd* tracep) {
    Vdct__Syms* __restrict vlSymsp = static_cast<Vdct__Syms*>(userp);
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceFullSub0(userp, tracep);
    }
}

void Vdct::traceFullSub0(void* userp, VerilatedVcd* tracep) {
    Vdct__Syms* __restrict vlSymsp = static_cast<Vdct__Syms*>(userp);
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->fullIData(oldp+1,(vlTOPp->dct__DOT__unnamedblk1__DOT__itemp),32);
        tracep->fullBit(oldp+2,(vlTOPp->__Vcellinp__dct__CLK));
        tracep->fullBit(oldp+3,(vlTOPp->__Vcellinp__dct__RST));
        tracep->fullCData(oldp+4,(vlTOPp->__Vcellinp__dct__xin),8);
        tracep->fullBit(oldp+5,(vlTOPp->dct__DOT__en_ram1));
        tracep->fullBit(oldp+6,(vlTOPp->dct__DOT__en_dct2d));
        tracep->fullSData(oldp+7,((0xfffU & ((0x80U 
                                              & vlTOPp->dct__DOT__dct_2d_int)
                                              ? ((IData)(1U) 
                                                 + 
                                                 (vlTOPp->dct__DOT__dct_2d_int 
                                                  >> 8U))
                                              : (vlTOPp->dct__DOT__dct_2d_int 
                                                 >> 8U)))),12);
        tracep->fullBit(oldp+8,((0x5eU == (IData)(vlTOPp->dct__DOT__cntr92))));
        tracep->fullCData(oldp+9,(vlTOPp->dct__DOT__memory1a),8);
        tracep->fullCData(oldp+10,(vlTOPp->dct__DOT__memory2a),8);
        tracep->fullCData(oldp+11,(vlTOPp->dct__DOT__memory3a),8);
        tracep->fullCData(oldp+12,(vlTOPp->dct__DOT__memory4a),8);
        tracep->fullCData(oldp+13,(vlTOPp->dct__DOT__xa0_in),8);
        tracep->fullCData(oldp+14,(vlTOPp->dct__DOT__xa1_in),8);
        tracep->fullCData(oldp+15,(vlTOPp->dct__DOT__xa2_in),8);
        tracep->fullCData(oldp+16,(vlTOPp->dct__DOT__xa3_in),8);
        tracep->fullCData(oldp+17,(vlTOPp->dct__DOT__xa4_in),8);
        tracep->fullCData(oldp+18,(vlTOPp->dct__DOT__xa5_in),8);
        tracep->fullCData(oldp+19,(vlTOPp->dct__DOT__xa6_in),8);
        tracep->fullCData(oldp+20,(vlTOPp->dct__DOT__xa7_in),8);
        tracep->fullSData(oldp+21,(vlTOPp->dct__DOT__xa0_reg),9);
        tracep->fullSData(oldp+22,(vlTOPp->dct__DOT__xa1_reg),9);
        tracep->fullSData(oldp+23,(vlTOPp->dct__DOT__xa2_reg),9);
        tracep->fullSData(oldp+24,(vlTOPp->dct__DOT__xa3_reg),9);
        tracep->fullSData(oldp+25,(vlTOPp->dct__DOT__xa4_reg),9);
        tracep->fullSData(oldp+26,(vlTOPp->dct__DOT__xa5_reg),9);
        tracep->fullSData(oldp+27,(vlTOPp->dct__DOT__xa6_reg),9);
        tracep->fullSData(oldp+28,(vlTOPp->dct__DOT__xa7_reg),9);
        tracep->fullSData(oldp+29,(vlTOPp->dct__DOT__add_sub1a),9);
        tracep->fullSData(oldp+30,(vlTOPp->dct__DOT__add_sub2a),9);
        tracep->fullSData(oldp+31,(vlTOPp->dct__DOT__add_sub3a),9);
        tracep->fullSData(oldp+32,(vlTOPp->dct__DOT__add_sub4a),9);
        tracep->fullCData(oldp+33,(vlTOPp->dct__DOT__addsub1a_comp),8);
        tracep->fullCData(oldp+34,(vlTOPp->dct__DOT__addsub2a_comp),8);
        tracep->fullCData(oldp+35,(vlTOPp->dct__DOT__addsub3a_comp),8);
        tracep->fullCData(oldp+36,(vlTOPp->dct__DOT__addsub4a_comp),8);
        tracep->fullBit(oldp+37,(vlTOPp->dct__DOT__save_sign1a));
        tracep->fullBit(oldp+38,(vlTOPp->dct__DOT__save_sign2a));
        tracep->fullBit(oldp+39,(vlTOPp->dct__DOT__save_sign3a));
        tracep->fullBit(oldp+40,(vlTOPp->dct__DOT__save_sign4a));
        tracep->fullIData(oldp+41,(vlTOPp->dct__DOT__p1a),19);
        tracep->fullIData(oldp+42,(vlTOPp->dct__DOT__p2a),19);
        tracep->fullIData(oldp+43,(vlTOPp->dct__DOT__p3a),19);
        tracep->fullIData(oldp+44,(vlTOPp->dct__DOT__p4a),19);
        tracep->fullQData(oldp+45,(vlTOPp->dct__DOT__p1a_all),36);
        tracep->fullQData(oldp+47,(vlTOPp->dct__DOT__p2a_all),36);
        tracep->fullQData(oldp+49,(vlTOPp->dct__DOT__p3a_all),36);
        tracep->fullQData(oldp+51,(vlTOPp->dct__DOT__p4a_all),36);
        tracep->fullCData(oldp+53,(vlTOPp->dct__DOT__i_wait),2);
        tracep->fullBit(oldp+54,(vlTOPp->dct__DOT__toggleA));
        tracep->fullIData(oldp+55,(vlTOPp->dct__DOT__z_out_int1),19);
        tracep->fullIData(oldp+56,(vlTOPp->dct__DOT__z_out_int2),19);
        tracep->fullIData(oldp+57,(vlTOPp->dct__DOT__z_out_int),19);
        tracep->fullIData(oldp+58,(vlTOPp->dct__DOT__indexi),32);
        tracep->fullCData(oldp+59,(vlTOPp->dct__DOT__cntr12),4);
        tracep->fullCData(oldp+60,(vlTOPp->dct__DOT__cntr8),4);
        tracep->fullCData(oldp+61,(vlTOPp->dct__DOT__cntr79),7);
        tracep->fullCData(oldp+62,(vlTOPp->dct__DOT__cntr92),7);
        tracep->fullBit(oldp+63,(vlTOPp->dct__DOT__en_dct2d_reg));
        tracep->fullSData(oldp+64,(vlTOPp->dct__DOT__xb0_in),11);
        tracep->fullSData(oldp+65,(vlTOPp->dct__DOT__xb1_in),11);
        tracep->fullSData(oldp+66,(vlTOPp->dct__DOT__xb2_in),11);
        tracep->fullSData(oldp+67,(vlTOPp->dct__DOT__xb3_in),11);
        tracep->fullSData(oldp+68,(vlTOPp->dct__DOT__xb4_in),11);
        tracep->fullSData(oldp+69,(vlTOPp->dct__DOT__xb5_in),11);
        tracep->fullSData(oldp+70,(vlTOPp->dct__DOT__xb6_in),11);
        tracep->fullSData(oldp+71,(vlTOPp->dct__DOT__xb7_in),11);
        tracep->fullSData(oldp+72,(vlTOPp->dct__DOT__xb0_reg),12);
        tracep->fullSData(oldp+73,(vlTOPp->dct__DOT__xb1_reg),12);
        tracep->fullSData(oldp+74,(vlTOPp->dct__DOT__xb2_reg),12);
        tracep->fullSData(oldp+75,(vlTOPp->dct__DOT__xb3_reg),12);
        tracep->fullSData(oldp+76,(vlTOPp->dct__DOT__xb4_reg),12);
        tracep->fullSData(oldp+77,(vlTOPp->dct__DOT__xb5_reg),12);
        tracep->fullSData(oldp+78,(vlTOPp->dct__DOT__xb6_reg),12);
        tracep->fullSData(oldp+79,(vlTOPp->dct__DOT__xb7_reg),12);
        tracep->fullSData(oldp+80,(vlTOPp->dct__DOT__add_sub1b),12);
        tracep->fullSData(oldp+81,(vlTOPp->dct__DOT__add_sub2b),12);
        tracep->fullSData(oldp+82,(vlTOPp->dct__DOT__add_sub3b),12);
        tracep->fullSData(oldp+83,(vlTOPp->dct__DOT__add_sub4b),12);
        tracep->fullSData(oldp+84,(vlTOPp->dct__DOT__addsub1b_comp),11);
        tracep->fullSData(oldp+85,(vlTOPp->dct__DOT__addsub2b_comp),11);
        tracep->fullSData(oldp+86,(vlTOPp->dct__DOT__addsub3b_comp),11);
        tracep->fullSData(oldp+87,(vlTOPp->dct__DOT__addsub4b_comp),11);
        tracep->fullBit(oldp+88,(vlTOPp->dct__DOT__save_sign1b));
        tracep->fullBit(oldp+89,(vlTOPp->dct__DOT__save_sign2b));
        tracep->fullBit(oldp+90,(vlTOPp->dct__DOT__save_sign3b));
        tracep->fullBit(oldp+91,(vlTOPp->dct__DOT__save_sign4b));
        tracep->fullIData(oldp+92,(vlTOPp->dct__DOT__p1b),20);
        tracep->fullIData(oldp+93,(vlTOPp->dct__DOT__p2b),20);
        tracep->fullIData(oldp+94,(vlTOPp->dct__DOT__p3b),20);
        tracep->fullIData(oldp+95,(vlTOPp->dct__DOT__p4b),20);
        tracep->fullQData(oldp+96,(vlTOPp->dct__DOT__p1b_all),36);
        tracep->fullQData(oldp+98,(vlTOPp->dct__DOT__p2b_all),36);
        tracep->fullQData(oldp+100,(vlTOPp->dct__DOT__p3b_all),36);
        tracep->fullQData(oldp+102,(vlTOPp->dct__DOT__p4b_all),36);
        tracep->fullBit(oldp+104,(vlTOPp->dct__DOT__toggleB));
        tracep->fullIData(oldp+105,(vlTOPp->dct__DOT__dct2d_int1),20);
        tracep->fullIData(oldp+106,(vlTOPp->dct__DOT__dct2d_int2),20);
        tracep->fullIData(oldp+107,(vlTOPp->dct__DOT__dct_2d_int),20);
        tracep->fullSData(oldp+108,((0xfffU & (vlTOPp->dct__DOT__dct_2d_int 
                                               >> 8U))),12);
        tracep->fullSData(oldp+109,(vlTOPp->dct__DOT__z_out_rnd),11);
        tracep->fullCData(oldp+110,(vlTOPp->dct__DOT__wr_cntr),7);
        tracep->fullCData(oldp+111,(vlTOPp->dct__DOT__rd_cntr),7);
        tracep->fullBit(oldp+112,(vlTOPp->dct__DOT__en_ram1reg));
        tracep->fullSData(oldp+113,(vlTOPp->dct__DOT__data_out),11);
    }
}
