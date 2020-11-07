// Verilated -*- SystemC -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdct.h for the primary calling header

#include "Vdct.h"
#include "Vdct__Syms.h"

//==========

VL_SC_CTOR_IMP(Vdct)
    : CLK("CLK"), RST("RST"), rdy_out("rdy_out"), dct_2d("dct_2d"), 
      xin("xin")
 {
    Vdct__Syms* __restrict vlSymsp = __VlSymsp = new Vdct__Syms(this, name());
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Sensitivities on all clocks and combo inputs
    SC_METHOD(eval);
    sensitive << CLK;
    sensitive << RST;
    sensitive << xin;
    
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vdct::__Vconfigure(Vdct__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-9);
    Verilated::timeprecision(-12);
}

Vdct::~Vdct() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = nullptr);
}

void Vdct::_settle__TOP__2(Vdct__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_settle__TOP__2\n"); );
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    VL_ASSIGN_ISI(1,vlTOPp->__Vcellinp__dct__CLK, vlTOPp->CLK);
    VL_ASSIGN_SII(1,vlTOPp->rdy_out, (0x5eU == (IData)(vlTOPp->dct__DOT__cntr92)));
    VL_ASSIGN_SWI(12,vlTOPp->dct_2d, (0xfffU & ((0x80U 
                                                 & vlTOPp->dct__DOT__dct_2d_int)
                                                 ? 
                                                ((IData)(1U) 
                                                 + 
                                                 (vlTOPp->dct__DOT__dct_2d_int 
                                                  >> 8U))
                                                 : 
                                                (vlTOPp->dct__DOT__dct_2d_int 
                                                 >> 8U))));
    vlTOPp->dct__DOT__z_out_rnd = (0x7ffU & ((0x80U 
                                              & vlTOPp->dct__DOT__z_out_int)
                                              ? ((IData)(1U) 
                                                 + 
                                                 (vlTOPp->dct__DOT__z_out_int 
                                                  >> 8U))
                                              : (vlTOPp->dct__DOT__z_out_int 
                                                 >> 8U)));
    vlTOPp->dct__DOT__p1a_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub1a_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory1a))))));
    vlTOPp->dct__DOT__p2a_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub2a_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory2a))))));
    vlTOPp->dct__DOT__p3a_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub3a_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory3a))))));
    vlTOPp->dct__DOT__p4a_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub4a_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory4a))))));
    vlTOPp->dct__DOT__p1b_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub1b_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory1a))))));
    vlTOPp->dct__DOT__p2b_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub2b_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory2a))))));
    vlTOPp->dct__DOT__p3b_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub3b_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory3a))))));
    vlTOPp->dct__DOT__p4b_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub4b_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory4a))))));
    VL_ASSIGN_ISW(8,vlTOPp->__Vcellinp__dct__xin, vlTOPp->xin);
    vlTOPp->dct__DOT__en_dct2d = ((~ (IData)(vlTOPp->__Vcellinp__dct__RST)) 
                                  & ((0x4fU == (IData)(vlTOPp->dct__DOT__cntr79)) 
                                     | (IData)(vlTOPp->dct__DOT__en_dct2d)));
    VL_ASSIGN_ISI(1,vlTOPp->__Vcellinp__dct__RST, vlTOPp->RST);
    vlTOPp->dct__DOT__en_ram1 = ((~ (IData)(vlTOPp->__Vcellinp__dct__RST)) 
                                 & ((0xdU == (IData)(vlTOPp->dct__DOT__cntr12)) 
                                    | (IData)(vlTOPp->dct__DOT__en_ram1)));
}

void Vdct::_initial__TOP__3(Vdct__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_initial__TOP__3\n"); );
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->dct__DOT__ram1_mem[0U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[1U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[1U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[2U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[2U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[3U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[3U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[4U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[4U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[5U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[5U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[6U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[6U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[7U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[7U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[8U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[8U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[9U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[9U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0xaU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0xaU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0xbU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0xbU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0xcU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0xcU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0xdU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0xdU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0xeU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0xeU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0xfU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0xfU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x10U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x10U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x11U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x11U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x12U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x12U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x13U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x13U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x14U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x14U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x15U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x15U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x16U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x16U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x17U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x17U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x18U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x18U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x19U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x19U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x1aU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x1aU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x1bU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x1bU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x1cU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x1cU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x1dU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x1dU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x1eU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x1eU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x1fU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x1fU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x20U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x20U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x21U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x21U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x22U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x22U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x23U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x23U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x24U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x24U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x25U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x25U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x26U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x26U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x27U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x27U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x28U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x28U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x29U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x29U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x2aU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x2aU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x2bU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x2bU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x2cU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x2cU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x2dU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x2dU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x2eU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x2eU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x2fU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x2fU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x30U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x30U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x31U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x31U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x32U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x32U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x33U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x33U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x34U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x34U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x35U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x35U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x36U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x36U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x37U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x37U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x38U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x38U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x39U] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x39U] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x3aU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x3aU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x3bU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x3bU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x3cU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x3cU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x3dU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x3dU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x3eU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x3eU] = 0U;
    vlTOPp->dct__DOT__ram1_mem[0x3fU] = 0U;
    vlTOPp->dct__DOT__ram2_mem[0x3fU] = 0U;
    vlTOPp->dct__DOT__unnamedblk1__DOT__itemp = 0x40U;
}

void Vdct::_eval_initial(Vdct__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_eval_initial\n"); );
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_initial__TOP__3(vlSymsp);
    vlTOPp->__Vm_traceActivity[3U] = 1U;
    vlTOPp->__Vm_traceActivity[2U] = 1U;
    vlTOPp->__Vm_traceActivity[1U] = 1U;
    vlTOPp->__Vm_traceActivity[0U] = 1U;
    vlTOPp->__Vclklast__TOP____Vcellinp__dct__CLK = vlTOPp->__Vcellinp__dct__CLK;
    vlTOPp->__Vclklast__TOP____VinpClk__TOP____Vcellinp__dct__RST 
        = vlTOPp->__VinpClk__TOP____Vcellinp__dct__RST;
}

void Vdct::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::final\n"); );
    // Variables
    Vdct__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vdct::_eval_settle(Vdct__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_eval_settle\n"); );
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_settle__TOP__2(vlSymsp);
    vlTOPp->__Vm_traceActivity[3U] = 1U;
    vlTOPp->__Vm_traceActivity[2U] = 1U;
    vlTOPp->__Vm_traceActivity[1U] = 1U;
    vlTOPp->__Vm_traceActivity[0U] = 1U;
}

void Vdct::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_ctor_var_reset\n"); );
    // Body
    __Vcellinp__dct__xin = VL_RAND_RESET_I(8);
    __Vcellinp__dct__RST = VL_RAND_RESET_I(1);
    __Vcellinp__dct__CLK = VL_RAND_RESET_I(1);
    dct__DOT__memory1a = VL_RAND_RESET_I(8);
    dct__DOT__memory2a = VL_RAND_RESET_I(8);
    dct__DOT__memory3a = VL_RAND_RESET_I(8);
    dct__DOT__memory4a = VL_RAND_RESET_I(8);
    dct__DOT__xa0_in = VL_RAND_RESET_I(8);
    dct__DOT__xa1_in = VL_RAND_RESET_I(8);
    dct__DOT__xa2_in = VL_RAND_RESET_I(8);
    dct__DOT__xa3_in = VL_RAND_RESET_I(8);
    dct__DOT__xa4_in = VL_RAND_RESET_I(8);
    dct__DOT__xa5_in = VL_RAND_RESET_I(8);
    dct__DOT__xa6_in = VL_RAND_RESET_I(8);
    dct__DOT__xa7_in = VL_RAND_RESET_I(8);
    dct__DOT__xa0_reg = VL_RAND_RESET_I(9);
    dct__DOT__xa1_reg = VL_RAND_RESET_I(9);
    dct__DOT__xa2_reg = VL_RAND_RESET_I(9);
    dct__DOT__xa3_reg = VL_RAND_RESET_I(9);
    dct__DOT__xa4_reg = VL_RAND_RESET_I(9);
    dct__DOT__xa5_reg = VL_RAND_RESET_I(9);
    dct__DOT__xa6_reg = VL_RAND_RESET_I(9);
    dct__DOT__xa7_reg = VL_RAND_RESET_I(9);
    dct__DOT__add_sub1a = VL_RAND_RESET_I(9);
    dct__DOT__add_sub2a = VL_RAND_RESET_I(9);
    dct__DOT__add_sub3a = VL_RAND_RESET_I(9);
    dct__DOT__add_sub4a = VL_RAND_RESET_I(9);
    dct__DOT__addsub1a_comp = VL_RAND_RESET_I(8);
    dct__DOT__addsub2a_comp = VL_RAND_RESET_I(8);
    dct__DOT__addsub3a_comp = VL_RAND_RESET_I(8);
    dct__DOT__addsub4a_comp = VL_RAND_RESET_I(8);
    dct__DOT__save_sign1a = VL_RAND_RESET_I(1);
    dct__DOT__save_sign2a = VL_RAND_RESET_I(1);
    dct__DOT__save_sign3a = VL_RAND_RESET_I(1);
    dct__DOT__save_sign4a = VL_RAND_RESET_I(1);
    dct__DOT__p1a = VL_RAND_RESET_I(19);
    dct__DOT__p2a = VL_RAND_RESET_I(19);
    dct__DOT__p3a = VL_RAND_RESET_I(19);
    dct__DOT__p4a = VL_RAND_RESET_I(19);
    dct__DOT__p1a_all = VL_RAND_RESET_Q(36);
    dct__DOT__p2a_all = VL_RAND_RESET_Q(36);
    dct__DOT__p3a_all = VL_RAND_RESET_Q(36);
    dct__DOT__p4a_all = VL_RAND_RESET_Q(36);
    dct__DOT__i_wait = VL_RAND_RESET_I(2);
    dct__DOT__toggleA = VL_RAND_RESET_I(1);
    dct__DOT__z_out_int1 = VL_RAND_RESET_I(19);
    dct__DOT__z_out_int2 = VL_RAND_RESET_I(19);
    dct__DOT__z_out_int = VL_RAND_RESET_I(19);
    dct__DOT__z_out_rnd = VL_RAND_RESET_I(11);
    dct__DOT__indexi = VL_RAND_RESET_I(32);
    dct__DOT__cntr12 = VL_RAND_RESET_I(4);
    dct__DOT__cntr8 = VL_RAND_RESET_I(4);
    dct__DOT__cntr79 = VL_RAND_RESET_I(7);
    dct__DOT__wr_cntr = VL_RAND_RESET_I(7);
    dct__DOT__rd_cntr = VL_RAND_RESET_I(7);
    dct__DOT__cntr92 = VL_RAND_RESET_I(7);
    dct__DOT__data_out = VL_RAND_RESET_I(11);
    dct__DOT__en_ram1 = VL_RAND_RESET_I(1);
    dct__DOT__en_dct2d = VL_RAND_RESET_I(1);
    dct__DOT__en_ram1reg = VL_RAND_RESET_I(1);
    dct__DOT__en_dct2d_reg = VL_RAND_RESET_I(1);
    for (int __Vi0=0; __Vi0<64; ++__Vi0) {
        dct__DOT__ram1_mem[__Vi0] = VL_RAND_RESET_I(11);
    }
    for (int __Vi0=0; __Vi0<64; ++__Vi0) {
        dct__DOT__ram2_mem[__Vi0] = VL_RAND_RESET_I(11);
    }
    dct__DOT__xb0_in = VL_RAND_RESET_I(11);
    dct__DOT__xb1_in = VL_RAND_RESET_I(11);
    dct__DOT__xb2_in = VL_RAND_RESET_I(11);
    dct__DOT__xb3_in = VL_RAND_RESET_I(11);
    dct__DOT__xb4_in = VL_RAND_RESET_I(11);
    dct__DOT__xb5_in = VL_RAND_RESET_I(11);
    dct__DOT__xb6_in = VL_RAND_RESET_I(11);
    dct__DOT__xb7_in = VL_RAND_RESET_I(11);
    dct__DOT__xb0_reg = VL_RAND_RESET_I(12);
    dct__DOT__xb1_reg = VL_RAND_RESET_I(12);
    dct__DOT__xb2_reg = VL_RAND_RESET_I(12);
    dct__DOT__xb3_reg = VL_RAND_RESET_I(12);
    dct__DOT__xb4_reg = VL_RAND_RESET_I(12);
    dct__DOT__xb5_reg = VL_RAND_RESET_I(12);
    dct__DOT__xb6_reg = VL_RAND_RESET_I(12);
    dct__DOT__xb7_reg = VL_RAND_RESET_I(12);
    dct__DOT__add_sub1b = VL_RAND_RESET_I(12);
    dct__DOT__add_sub2b = VL_RAND_RESET_I(12);
    dct__DOT__add_sub3b = VL_RAND_RESET_I(12);
    dct__DOT__add_sub4b = VL_RAND_RESET_I(12);
    dct__DOT__addsub1b_comp = VL_RAND_RESET_I(11);
    dct__DOT__addsub2b_comp = VL_RAND_RESET_I(11);
    dct__DOT__addsub3b_comp = VL_RAND_RESET_I(11);
    dct__DOT__addsub4b_comp = VL_RAND_RESET_I(11);
    dct__DOT__save_sign1b = VL_RAND_RESET_I(1);
    dct__DOT__save_sign2b = VL_RAND_RESET_I(1);
    dct__DOT__save_sign3b = VL_RAND_RESET_I(1);
    dct__DOT__save_sign4b = VL_RAND_RESET_I(1);
    dct__DOT__p1b = VL_RAND_RESET_I(20);
    dct__DOT__p2b = VL_RAND_RESET_I(20);
    dct__DOT__p3b = VL_RAND_RESET_I(20);
    dct__DOT__p4b = VL_RAND_RESET_I(20);
    dct__DOT__p1b_all = VL_RAND_RESET_Q(36);
    dct__DOT__p2b_all = VL_RAND_RESET_Q(36);
    dct__DOT__p3b_all = VL_RAND_RESET_Q(36);
    dct__DOT__p4b_all = VL_RAND_RESET_Q(36);
    dct__DOT__toggleB = VL_RAND_RESET_I(1);
    dct__DOT__dct2d_int1 = VL_RAND_RESET_I(20);
    dct__DOT__dct2d_int2 = VL_RAND_RESET_I(20);
    dct__DOT__dct_2d_int = VL_RAND_RESET_I(20);
    dct__DOT__unnamedblk1__DOT__itemp = VL_RAND_RESET_I(32);
    __Vdly__dct__DOT__rd_cntr = VL_RAND_RESET_I(7);
    __Vdly__dct__DOT__wr_cntr = VL_RAND_RESET_I(7);
    __VinpClk__TOP____Vcellinp__dct__RST = VL_RAND_RESET_I(1);
    __Vchglast__TOP____Vcellinp__dct__RST = VL_RAND_RESET_I(1);
    for (int __Vi0=0; __Vi0<4; ++__Vi0) {
        __Vm_traceActivity[__Vi0] = VL_RAND_RESET_I(1);
    }
}
