// Verilated -*- SystemC -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdct.h for the primary calling header

#include "Vdct.h"
#include "Vdct__Syms.h"

//==========

void Vdct::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vdct::eval\n"); );
    Vdct__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        vlSymsp->__Vm_activity = true;
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("../xapp610/dct.v", 86, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vdct::_eval_initial_loop(Vdct__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    vlSymsp->__Vm_activity = true;
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("../xapp610/dct.v", 86, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void Vdct::_combo__TOP__1(Vdct__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_combo__TOP__1\n"); );
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    VL_ASSIGN_ISI(1,vlTOPp->__Vcellinp__dct__CLK, vlTOPp->CLK);
}

VL_INLINE_OPT void Vdct::_sequent__TOP__4(Vdct__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_sequent__TOP__4\n"); );
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    CData/*3:0*/ __Vdly__dct__DOT__cntr8;
    CData/*0:0*/ __Vdly__dct__DOT__toggleA;
    CData/*1:0*/ __Vdly__dct__DOT__i_wait;
    CData/*0:0*/ __Vdly__dct__DOT__toggleB;
    IData/*31:0*/ __Vdly__dct__DOT__indexi;
    // Body
    __Vdly__dct__DOT__toggleB = vlTOPp->dct__DOT__toggleB;
    __Vdly__dct__DOT__toggleA = vlTOPp->dct__DOT__toggleA;
    __Vdly__dct__DOT__i_wait = vlTOPp->dct__DOT__i_wait;
    __Vdly__dct__DOT__indexi = vlTOPp->dct__DOT__indexi;
    __Vdly__dct__DOT__cntr8 = vlTOPp->dct__DOT__cntr8;
    vlTOPp->__Vdly__dct__DOT__wr_cntr = vlTOPp->dct__DOT__wr_cntr;
    vlTOPp->__Vdly__dct__DOT__rd_cntr = vlTOPp->dct__DOT__rd_cntr;
    __Vdly__dct__DOT__toggleB = (1U & ((~ (IData)(vlTOPp->__Vcellinp__dct__RST)) 
                                       & (~ (IData)(vlTOPp->dct__DOT__toggleB))));
    __Vdly__dct__DOT__toggleA = (1U & ((~ (IData)(vlTOPp->__Vcellinp__dct__RST)) 
                                       & (~ (IData)(vlTOPp->dct__DOT__toggleA))));
    if (vlTOPp->__Vcellinp__dct__RST) {
        __Vdly__dct__DOT__i_wait = 1U;
        vlTOPp->dct__DOT__cntr92 = 0U;
    } else {
        __Vdly__dct__DOT__i_wait = ((0U != (IData)(vlTOPp->dct__DOT__i_wait))
                                     ? (3U & ((IData)(vlTOPp->dct__DOT__i_wait) 
                                              - (IData)(1U)))
                                     : 0U);
        vlTOPp->dct__DOT__cntr92 = (0x7fU & ((0x5eU 
                                              > (IData)(vlTOPp->dct__DOT__cntr92))
                                              ? ((IData)(1U) 
                                                 + (IData)(vlTOPp->dct__DOT__cntr92))
                                              : (IData)(vlTOPp->dct__DOT__cntr92)));
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        __Vdly__dct__DOT__indexi = 7U;
    } else {
        if ((0U == (IData)(vlTOPp->dct__DOT__i_wait))) {
            __Vdly__dct__DOT__indexi = ((7U == vlTOPp->dct__DOT__indexi)
                                         ? 0U : ((IData)(1U) 
                                                 + vlTOPp->dct__DOT__indexi));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        __Vdly__dct__DOT__cntr8 = 0U;
        vlTOPp->dct__DOT__cntr79 = 0U;
        vlTOPp->dct__DOT__cntr12 = 0U;
        vlTOPp->__Vdly__dct__DOT__wr_cntr = 0x7fU;
    } else {
        __Vdly__dct__DOT__cntr8 = ((8U > (IData)(vlTOPp->dct__DOT__cntr8))
                                    ? (0xfU & ((IData)(1U) 
                                               + (IData)(vlTOPp->dct__DOT__cntr8)))
                                    : 1U);
        vlTOPp->dct__DOT__cntr79 = (0x7fU & ((IData)(1U) 
                                             + (IData)(vlTOPp->dct__DOT__cntr79)));
        vlTOPp->dct__DOT__cntr12 = (0xfU & ((IData)(1U) 
                                            + (IData)(vlTOPp->dct__DOT__cntr12)));
        vlTOPp->__Vdly__dct__DOT__wr_cntr = ((IData)(vlTOPp->dct__DOT__en_ram1reg)
                                              ? (0x7fU 
                                                 & ((IData)(1U) 
                                                    + (IData)(vlTOPp->dct__DOT__wr_cntr)))
                                              : 0U);
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->__Vdly__dct__DOT__rd_cntr = (0x38U 
                                             | (IData)(vlTOPp->__Vdly__dct__DOT__rd_cntr));
    } else {
        if (vlTOPp->dct__DOT__en_ram1reg) {
            vlTOPp->__Vdly__dct__DOT__rd_cntr = ((0x47U 
                                                  & (IData)(vlTOPp->__Vdly__dct__DOT__rd_cntr)) 
                                                 | (0x38U 
                                                    & (((IData)(1U) 
                                                        + 
                                                        ((IData)(vlTOPp->dct__DOT__rd_cntr) 
                                                         >> 3U)) 
                                                       << 3U)));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->__Vdly__dct__DOT__rd_cntr = (7U | (IData)(vlTOPp->__Vdly__dct__DOT__rd_cntr));
    } else {
        if (((IData)(vlTOPp->dct__DOT__en_ram1reg) 
             & (7U == (7U & ((IData)(vlTOPp->dct__DOT__rd_cntr) 
                             >> 3U))))) {
            vlTOPp->__Vdly__dct__DOT__rd_cntr = ((0x78U 
                                                  & (IData)(vlTOPp->__Vdly__dct__DOT__rd_cntr)) 
                                                 | (7U 
                                                    & ((IData)(1U) 
                                                       + (IData)(vlTOPp->dct__DOT__rd_cntr))));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->__Vdly__dct__DOT__rd_cntr = (0x40U 
                                             | (IData)(vlTOPp->__Vdly__dct__DOT__rd_cntr));
    } else {
        if (((IData)(vlTOPp->dct__DOT__en_ram1reg) 
             & (0x3fU == (0x3fU & (IData)(vlTOPp->dct__DOT__rd_cntr))))) {
            vlTOPp->__Vdly__dct__DOT__rd_cntr = ((0x3fU 
                                                  & (IData)(vlTOPp->__Vdly__dct__DOT__rd_cntr)) 
                                                 | (0x40U 
                                                    & ((~ 
                                                        ((IData)(vlTOPp->dct__DOT__rd_cntr) 
                                                         >> 6U)) 
                                                       << 6U)));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__addsub1a_comp = 0U;
    } else {
        if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub1a))) {
            if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub1a))) {
                vlTOPp->dct__DOT__addsub1a_comp = (0xffU 
                                                   & (- (IData)(vlTOPp->dct__DOT__add_sub1a)));
            }
        } else {
            vlTOPp->dct__DOT__addsub1a_comp = (0xffU 
                                               & (IData)(vlTOPp->dct__DOT__add_sub1a));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__addsub4a_comp = 0U;
    } else {
        if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub4a))) {
            if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub4a))) {
                vlTOPp->dct__DOT__addsub4a_comp = (0xffU 
                                                   & (- (IData)(vlTOPp->dct__DOT__add_sub4a)));
            }
        } else {
            vlTOPp->dct__DOT__addsub4a_comp = (0xffU 
                                               & (IData)(vlTOPp->dct__DOT__add_sub4a));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__addsub3a_comp = 0U;
    } else {
        if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub3a))) {
            if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub3a))) {
                vlTOPp->dct__DOT__addsub3a_comp = (0xffU 
                                                   & (- (IData)(vlTOPp->dct__DOT__add_sub3a)));
            }
        } else {
            vlTOPp->dct__DOT__addsub3a_comp = (0xffU 
                                               & (IData)(vlTOPp->dct__DOT__add_sub3a));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__addsub2a_comp = 0U;
    } else {
        if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub2a))) {
            if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub2a))) {
                vlTOPp->dct__DOT__addsub2a_comp = (0xffU 
                                                   & (- (IData)(vlTOPp->dct__DOT__add_sub2a)));
            }
        } else {
            vlTOPp->dct__DOT__addsub2a_comp = (0xffU 
                                               & (IData)(vlTOPp->dct__DOT__add_sub2a));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__addsub1b_comp = 0U;
    } else {
        if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub1b))) {
            if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub1b))) {
                vlTOPp->dct__DOT__addsub1b_comp = (0x7ffU 
                                                   & (- (IData)(vlTOPp->dct__DOT__add_sub1b)));
            }
        } else {
            vlTOPp->dct__DOT__addsub1b_comp = (0x7ffU 
                                               & (IData)(vlTOPp->dct__DOT__add_sub1b));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__addsub4b_comp = 0U;
    } else {
        if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub4b))) {
            if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub4b))) {
                vlTOPp->dct__DOT__addsub4b_comp = (0x7ffU 
                                                   & (- (IData)(vlTOPp->dct__DOT__add_sub4b)));
            }
        } else {
            vlTOPp->dct__DOT__addsub4b_comp = (0x7ffU 
                                               & (IData)(vlTOPp->dct__DOT__add_sub4b));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__addsub3b_comp = 0U;
    } else {
        if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub3b))) {
            if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub3b))) {
                vlTOPp->dct__DOT__addsub3b_comp = (0x7ffU 
                                                   & (- (IData)(vlTOPp->dct__DOT__add_sub3b)));
            }
        } else {
            vlTOPp->dct__DOT__addsub3b_comp = (0x7ffU 
                                               & (IData)(vlTOPp->dct__DOT__add_sub3b));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__addsub2b_comp = 0U;
    } else {
        if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub2b))) {
            if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub2b))) {
                vlTOPp->dct__DOT__addsub2b_comp = (0x7ffU 
                                                   & (- (IData)(vlTOPp->dct__DOT__add_sub2b)));
            }
        } else {
            vlTOPp->dct__DOT__addsub2b_comp = (0x7ffU 
                                               & (IData)(vlTOPp->dct__DOT__add_sub2b));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__z_out_int = 0U;
        vlTOPp->dct__DOT__dct_2d_int = 0U;
    } else {
        vlTOPp->dct__DOT__z_out_int = (0x7ffffU & (vlTOPp->dct__DOT__z_out_int1 
                                                   + vlTOPp->dct__DOT__z_out_int2));
        vlTOPp->dct__DOT__dct_2d_int = (0xfffffU & 
                                        (vlTOPp->dct__DOT__dct2d_int1 
                                         + vlTOPp->dct__DOT__dct2d_int2));
    }
    VL_ASSIGN_SII(1,vlTOPp->rdy_out, (0x5eU == (IData)(vlTOPp->dct__DOT__cntr92)));
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__z_out_int1 = 0U;
        vlTOPp->dct__DOT__z_out_int2 = 0U;
    } else {
        vlTOPp->dct__DOT__z_out_int1 = (0x7ffffU & 
                                        (vlTOPp->dct__DOT__p1a 
                                         + vlTOPp->dct__DOT__p2a));
        vlTOPp->dct__DOT__z_out_int2 = (0x7ffffU & 
                                        (vlTOPp->dct__DOT__p3a 
                                         + vlTOPp->dct__DOT__p4a));
    }
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
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__dct2d_int1 = 0U;
        vlTOPp->dct__DOT__dct2d_int2 = 0U;
    } else {
        vlTOPp->dct__DOT__dct2d_int1 = (0xfffffU & 
                                        (vlTOPp->dct__DOT__p1b 
                                         + vlTOPp->dct__DOT__p2b));
        vlTOPp->dct__DOT__dct2d_int2 = (0xfffffU & 
                                        (vlTOPp->dct__DOT__p3b 
                                         + vlTOPp->dct__DOT__p4b));
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__p1a = 0U;
    } else {
        if ((0U == (IData)(vlTOPp->dct__DOT__i_wait))) {
            vlTOPp->dct__DOT__p1a = (0x7ffffU & (IData)(
                                                        (0xfffffffffULL 
                                                         & ((1U 
                                                             & ((IData)(vlTOPp->dct__DOT__save_sign1a) 
                                                                ^ 
                                                                ((IData)(vlTOPp->dct__DOT__memory1a) 
                                                                 >> 7U)))
                                                             ? 
                                                            (- vlTOPp->dct__DOT__p1a_all)
                                                             : vlTOPp->dct__DOT__p1a_all))));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__p2a = 0U;
    } else {
        if ((0U == (IData)(vlTOPp->dct__DOT__i_wait))) {
            vlTOPp->dct__DOT__p2a = (0x7ffffU & (IData)(
                                                        (0xfffffffffULL 
                                                         & ((1U 
                                                             & ((IData)(vlTOPp->dct__DOT__save_sign2a) 
                                                                ^ 
                                                                ((IData)(vlTOPp->dct__DOT__memory2a) 
                                                                 >> 7U)))
                                                             ? 
                                                            (- vlTOPp->dct__DOT__p2a_all)
                                                             : vlTOPp->dct__DOT__p2a_all))));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__p3a = 0U;
    } else {
        if ((0U == (IData)(vlTOPp->dct__DOT__i_wait))) {
            vlTOPp->dct__DOT__p3a = (0x7ffffU & (IData)(
                                                        (0xfffffffffULL 
                                                         & ((1U 
                                                             & ((IData)(vlTOPp->dct__DOT__save_sign3a) 
                                                                ^ 
                                                                ((IData)(vlTOPp->dct__DOT__memory3a) 
                                                                 >> 7U)))
                                                             ? 
                                                            (- vlTOPp->dct__DOT__p3a_all)
                                                             : vlTOPp->dct__DOT__p3a_all))));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__p4a = 0U;
    } else {
        if ((0U == (IData)(vlTOPp->dct__DOT__i_wait))) {
            vlTOPp->dct__DOT__p4a = (0x7ffffU & (IData)(
                                                        (0xfffffffffULL 
                                                         & ((1U 
                                                             & ((IData)(vlTOPp->dct__DOT__save_sign4a) 
                                                                ^ 
                                                                ((IData)(vlTOPp->dct__DOT__memory4a) 
                                                                 >> 7U)))
                                                             ? 
                                                            (- vlTOPp->dct__DOT__p4a_all)
                                                             : vlTOPp->dct__DOT__p4a_all))));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__p1b = 0U;
    } else {
        if ((0U == (IData)(vlTOPp->dct__DOT__i_wait))) {
            vlTOPp->dct__DOT__p1b = (0xfffffU & (IData)(
                                                        (0xfffffffffULL 
                                                         & ((1U 
                                                             & ((IData)(vlTOPp->dct__DOT__save_sign1b) 
                                                                ^ 
                                                                ((IData)(vlTOPp->dct__DOT__memory1a) 
                                                                 >> 7U)))
                                                             ? 
                                                            (- vlTOPp->dct__DOT__p1b_all)
                                                             : vlTOPp->dct__DOT__p1b_all))));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__p2b = 0U;
    } else {
        if ((0U == (IData)(vlTOPp->dct__DOT__i_wait))) {
            vlTOPp->dct__DOT__p2b = (0xfffffU & (IData)(
                                                        (0xfffffffffULL 
                                                         & ((1U 
                                                             & ((IData)(vlTOPp->dct__DOT__save_sign2b) 
                                                                ^ 
                                                                ((IData)(vlTOPp->dct__DOT__memory2a) 
                                                                 >> 7U)))
                                                             ? 
                                                            (- vlTOPp->dct__DOT__p2b_all)
                                                             : vlTOPp->dct__DOT__p2b_all))));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__p3b = 0U;
    } else {
        if ((0U == (IData)(vlTOPp->dct__DOT__i_wait))) {
            vlTOPp->dct__DOT__p3b = (0xfffffU & (IData)(
                                                        (0xfffffffffULL 
                                                         & ((1U 
                                                             & ((IData)(vlTOPp->dct__DOT__save_sign3b) 
                                                                ^ 
                                                                ((IData)(vlTOPp->dct__DOT__memory3a) 
                                                                 >> 7U)))
                                                             ? 
                                                            (- vlTOPp->dct__DOT__p3b_all)
                                                             : vlTOPp->dct__DOT__p3b_all))));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__p4b = 0U;
    } else {
        if ((0U == (IData)(vlTOPp->dct__DOT__i_wait))) {
            vlTOPp->dct__DOT__p4b = (0xfffffU & (IData)(
                                                        (0xfffffffffULL 
                                                         & ((1U 
                                                             & ((IData)(vlTOPp->dct__DOT__save_sign4b) 
                                                                ^ 
                                                                ((IData)(vlTOPp->dct__DOT__memory4a) 
                                                                 >> 7U)))
                                                             ? 
                                                            (- vlTOPp->dct__DOT__p4b_all)
                                                             : vlTOPp->dct__DOT__p4b_all))));
        }
    }
    vlTOPp->dct__DOT__i_wait = __Vdly__dct__DOT__i_wait;
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__save_sign1a = 0U;
    } else {
        if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub1a))) {
            if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub1a))) {
                vlTOPp->dct__DOT__save_sign1a = 1U;
            }
        } else {
            vlTOPp->dct__DOT__save_sign1a = 0U;
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__save_sign2a = 0U;
    } else {
        if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub2a))) {
            if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub2a))) {
                vlTOPp->dct__DOT__save_sign2a = 1U;
            }
        } else {
            vlTOPp->dct__DOT__save_sign2a = 0U;
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__save_sign3a = 0U;
    } else {
        if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub3a))) {
            if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub3a))) {
                vlTOPp->dct__DOT__save_sign3a = 1U;
            }
        } else {
            vlTOPp->dct__DOT__save_sign3a = 0U;
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__save_sign4a = 0U;
    } else {
        if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub4a))) {
            if ((0x100U & (IData)(vlTOPp->dct__DOT__add_sub4a))) {
                vlTOPp->dct__DOT__save_sign4a = 1U;
            }
        } else {
            vlTOPp->dct__DOT__save_sign4a = 0U;
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__memory1a = 0U;
    } else {
        if (((((((((0U == vlTOPp->dct__DOT__indexi) 
                   | (1U == vlTOPp->dct__DOT__indexi)) 
                  | (2U == vlTOPp->dct__DOT__indexi)) 
                 | (3U == vlTOPp->dct__DOT__indexi)) 
                | (4U == vlTOPp->dct__DOT__indexi)) 
               | (5U == vlTOPp->dct__DOT__indexi)) 
              | (6U == vlTOPp->dct__DOT__indexi)) | 
             (7U == vlTOPp->dct__DOT__indexi))) {
            vlTOPp->dct__DOT__memory1a = ((0U == vlTOPp->dct__DOT__indexi)
                                           ? 0x5bU : 
                                          ((1U == vlTOPp->dct__DOT__indexi)
                                            ? 0x7eU
                                            : ((2U 
                                                == vlTOPp->dct__DOT__indexi)
                                                ? 0x76U
                                                : (
                                                   (3U 
                                                    == vlTOPp->dct__DOT__indexi)
                                                    ? 0x6aU
                                                    : 
                                                   ((4U 
                                                     == vlTOPp->dct__DOT__indexi)
                                                     ? 0x5bU
                                                     : 
                                                    ((5U 
                                                      == vlTOPp->dct__DOT__indexi)
                                                      ? 0x47U
                                                      : 
                                                     ((6U 
                                                       == vlTOPp->dct__DOT__indexi)
                                                       ? 0x31U
                                                       : 0x19U)))))));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__save_sign1b = 0U;
    } else {
        if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub1b))) {
            if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub1b))) {
                vlTOPp->dct__DOT__save_sign1b = 1U;
            }
        } else {
            vlTOPp->dct__DOT__save_sign1b = 0U;
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__memory2a = 0U;
    } else {
        if (((((((((0U == vlTOPp->dct__DOT__indexi) 
                   | (1U == vlTOPp->dct__DOT__indexi)) 
                  | (2U == vlTOPp->dct__DOT__indexi)) 
                 | (3U == vlTOPp->dct__DOT__indexi)) 
                | (4U == vlTOPp->dct__DOT__indexi)) 
               | (5U == vlTOPp->dct__DOT__indexi)) 
              | (6U == vlTOPp->dct__DOT__indexi)) | 
             (7U == vlTOPp->dct__DOT__indexi))) {
            if ((0U == vlTOPp->dct__DOT__indexi)) {
                vlTOPp->dct__DOT__memory2a = 0x5bU;
            } else {
                if ((1U == vlTOPp->dct__DOT__indexi)) {
                    vlTOPp->dct__DOT__memory2a = 0x6aU;
                } else {
                    if ((2U == vlTOPp->dct__DOT__indexi)) {
                        vlTOPp->dct__DOT__memory2a = 0x31U;
                    } else {
                        if ((3U == vlTOPp->dct__DOT__indexi)) {
                            vlTOPp->dct__DOT__memory2a 
                                = (0x80U | (IData)(vlTOPp->dct__DOT__memory2a));
                            vlTOPp->dct__DOT__memory2a 
                                = (0x19U | (0x80U & (IData)(vlTOPp->dct__DOT__memory2a)));
                        } else {
                            if ((4U == vlTOPp->dct__DOT__indexi)) {
                                vlTOPp->dct__DOT__memory2a 
                                    = (0x80U | (IData)(vlTOPp->dct__DOT__memory2a));
                                vlTOPp->dct__DOT__memory2a 
                                    = (0x5bU | (0x80U 
                                                & (IData)(vlTOPp->dct__DOT__memory2a)));
                            } else {
                                if ((5U == vlTOPp->dct__DOT__indexi)) {
                                    vlTOPp->dct__DOT__memory2a 
                                        = (0x80U | (IData)(vlTOPp->dct__DOT__memory2a));
                                    vlTOPp->dct__DOT__memory2a 
                                        = (0x7eU | 
                                           (0x80U & (IData)(vlTOPp->dct__DOT__memory2a)));
                                } else {
                                    if ((6U == vlTOPp->dct__DOT__indexi)) {
                                        vlTOPp->dct__DOT__memory2a 
                                            = (0x80U 
                                               | (IData)(vlTOPp->dct__DOT__memory2a));
                                        vlTOPp->dct__DOT__memory2a 
                                            = (0x76U 
                                               | (0x80U 
                                                  & (IData)(vlTOPp->dct__DOT__memory2a)));
                                    } else {
                                        vlTOPp->dct__DOT__memory2a 
                                            = (0x80U 
                                               | (IData)(vlTOPp->dct__DOT__memory2a));
                                        vlTOPp->dct__DOT__memory2a 
                                            = (0x47U 
                                               | (0x80U 
                                                  & (IData)(vlTOPp->dct__DOT__memory2a)));
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__save_sign2b = 0U;
    } else {
        if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub2b))) {
            if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub2b))) {
                vlTOPp->dct__DOT__save_sign2b = 1U;
            }
        } else {
            vlTOPp->dct__DOT__save_sign2b = 0U;
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__memory3a = 0U;
    } else {
        if (((((((((0U == vlTOPp->dct__DOT__indexi) 
                   | (1U == vlTOPp->dct__DOT__indexi)) 
                  | (2U == vlTOPp->dct__DOT__indexi)) 
                 | (3U == vlTOPp->dct__DOT__indexi)) 
                | (4U == vlTOPp->dct__DOT__indexi)) 
               | (5U == vlTOPp->dct__DOT__indexi)) 
              | (6U == vlTOPp->dct__DOT__indexi)) | 
             (7U == vlTOPp->dct__DOT__indexi))) {
            if ((0U == vlTOPp->dct__DOT__indexi)) {
                vlTOPp->dct__DOT__memory3a = 0x5bU;
            } else {
                if ((1U == vlTOPp->dct__DOT__indexi)) {
                    vlTOPp->dct__DOT__memory3a = 0x47U;
                } else {
                    if ((2U == vlTOPp->dct__DOT__indexi)) {
                        vlTOPp->dct__DOT__memory3a 
                            = (0x80U | (IData)(vlTOPp->dct__DOT__memory3a));
                        vlTOPp->dct__DOT__memory3a 
                            = (0x31U | (0x80U & (IData)(vlTOPp->dct__DOT__memory3a)));
                    } else {
                        if ((3U == vlTOPp->dct__DOT__indexi)) {
                            vlTOPp->dct__DOT__memory3a 
                                = (0x80U | (IData)(vlTOPp->dct__DOT__memory3a));
                            vlTOPp->dct__DOT__memory3a 
                                = (0x7eU | (0x80U & (IData)(vlTOPp->dct__DOT__memory3a)));
                        } else {
                            if ((4U == vlTOPp->dct__DOT__indexi)) {
                                vlTOPp->dct__DOT__memory3a 
                                    = (0x80U | (IData)(vlTOPp->dct__DOT__memory3a));
                                vlTOPp->dct__DOT__memory3a 
                                    = (0x5bU | (0x80U 
                                                & (IData)(vlTOPp->dct__DOT__memory3a)));
                            } else {
                                vlTOPp->dct__DOT__memory3a 
                                    = ((5U == vlTOPp->dct__DOT__indexi)
                                        ? 0x19U : (
                                                   (6U 
                                                    == vlTOPp->dct__DOT__indexi)
                                                    ? 0x76U
                                                    : 0x6aU));
                            }
                        }
                    }
                }
            }
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__save_sign3b = 0U;
    } else {
        if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub3b))) {
            if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub3b))) {
                vlTOPp->dct__DOT__save_sign3b = 1U;
            }
        } else {
            vlTOPp->dct__DOT__save_sign3b = 0U;
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__memory4a = 0U;
    } else {
        if (((((((((0U == vlTOPp->dct__DOT__indexi) 
                   | (1U == vlTOPp->dct__DOT__indexi)) 
                  | (2U == vlTOPp->dct__DOT__indexi)) 
                 | (3U == vlTOPp->dct__DOT__indexi)) 
                | (4U == vlTOPp->dct__DOT__indexi)) 
               | (5U == vlTOPp->dct__DOT__indexi)) 
              | (6U == vlTOPp->dct__DOT__indexi)) | 
             (7U == vlTOPp->dct__DOT__indexi))) {
            if ((0U == vlTOPp->dct__DOT__indexi)) {
                vlTOPp->dct__DOT__memory4a = 0x5bU;
            } else {
                if ((1U == vlTOPp->dct__DOT__indexi)) {
                    vlTOPp->dct__DOT__memory4a = 0x19U;
                } else {
                    if ((2U == vlTOPp->dct__DOT__indexi)) {
                        vlTOPp->dct__DOT__memory4a 
                            = (0x80U | (IData)(vlTOPp->dct__DOT__memory4a));
                        vlTOPp->dct__DOT__memory4a 
                            = (0x76U | (0x80U & (IData)(vlTOPp->dct__DOT__memory4a)));
                    } else {
                        if ((3U == vlTOPp->dct__DOT__indexi)) {
                            vlTOPp->dct__DOT__memory4a 
                                = (0x80U | (IData)(vlTOPp->dct__DOT__memory4a));
                            vlTOPp->dct__DOT__memory4a 
                                = (0x47U | (0x80U & (IData)(vlTOPp->dct__DOT__memory4a)));
                        } else {
                            if ((4U == vlTOPp->dct__DOT__indexi)) {
                                vlTOPp->dct__DOT__memory4a = 0x5bU;
                            } else {
                                if ((5U == vlTOPp->dct__DOT__indexi)) {
                                    vlTOPp->dct__DOT__memory4a = 0x6aU;
                                } else {
                                    if ((6U == vlTOPp->dct__DOT__indexi)) {
                                        vlTOPp->dct__DOT__memory4a 
                                            = (0x80U 
                                               | (IData)(vlTOPp->dct__DOT__memory4a));
                                        vlTOPp->dct__DOT__memory4a 
                                            = (0x31U 
                                               | (0x80U 
                                                  & (IData)(vlTOPp->dct__DOT__memory4a)));
                                    } else {
                                        vlTOPp->dct__DOT__memory4a 
                                            = (0x80U 
                                               | (IData)(vlTOPp->dct__DOT__memory4a));
                                        vlTOPp->dct__DOT__memory4a 
                                            = (0x7eU 
                                               | (0x80U 
                                                  & (IData)(vlTOPp->dct__DOT__memory4a)));
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__save_sign4b = 0U;
    } else {
        if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub4b))) {
            if ((0x800U & (IData)(vlTOPp->dct__DOT__add_sub4b))) {
                vlTOPp->dct__DOT__save_sign4b = 1U;
            }
        } else {
            vlTOPp->dct__DOT__save_sign4b = 0U;
        }
    }
    vlTOPp->dct__DOT__indexi = __Vdly__dct__DOT__indexi;
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__add_sub1a = 0U;
    } else {
        if (vlTOPp->dct__DOT__toggleA) {
            vlTOPp->dct__DOT__add_sub1a = (0x1ffU & 
                                           ((IData)(vlTOPp->dct__DOT__xa7_reg) 
                                            + (IData)(vlTOPp->dct__DOT__xa0_reg)));
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__toggleA)))) {
                vlTOPp->dct__DOT__add_sub1a = (0x1ffU 
                                               & ((IData)(vlTOPp->dct__DOT__xa7_reg) 
                                                  - (IData)(vlTOPp->dct__DOT__xa0_reg)));
            }
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__add_sub2a = 0U;
    } else {
        if (vlTOPp->dct__DOT__toggleA) {
            vlTOPp->dct__DOT__add_sub2a = (0x1ffU & 
                                           ((IData)(vlTOPp->dct__DOT__xa6_reg) 
                                            + (IData)(vlTOPp->dct__DOT__xa1_reg)));
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__toggleA)))) {
                vlTOPp->dct__DOT__add_sub2a = (0x1ffU 
                                               & ((IData)(vlTOPp->dct__DOT__xa6_reg) 
                                                  - (IData)(vlTOPp->dct__DOT__xa1_reg)));
            }
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__add_sub3a = 0U;
    } else {
        if (vlTOPp->dct__DOT__toggleA) {
            vlTOPp->dct__DOT__add_sub3a = (0x1ffU & 
                                           ((IData)(vlTOPp->dct__DOT__xa5_reg) 
                                            + (IData)(vlTOPp->dct__DOT__xa2_reg)));
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__toggleA)))) {
                vlTOPp->dct__DOT__add_sub3a = (0x1ffU 
                                               & ((IData)(vlTOPp->dct__DOT__xa5_reg) 
                                                  - (IData)(vlTOPp->dct__DOT__xa2_reg)));
            }
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__add_sub4a = 0U;
    } else {
        if (vlTOPp->dct__DOT__toggleA) {
            vlTOPp->dct__DOT__add_sub4a = (0x1ffU & 
                                           ((IData)(vlTOPp->dct__DOT__xa4_reg) 
                                            + (IData)(vlTOPp->dct__DOT__xa3_reg)));
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__toggleA)))) {
                vlTOPp->dct__DOT__add_sub4a = (0x1ffU 
                                               & ((IData)(vlTOPp->dct__DOT__xa4_reg) 
                                                  - (IData)(vlTOPp->dct__DOT__xa3_reg)));
            }
        }
    }
    vlTOPp->dct__DOT__p1a_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub1a_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory1a))))));
    vlTOPp->dct__DOT__p1b_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub1b_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory1a))))));
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__add_sub1b = 0U;
    } else {
        if (vlTOPp->dct__DOT__toggleB) {
            vlTOPp->dct__DOT__add_sub1b = (0xfffU & 
                                           ((IData)(vlTOPp->dct__DOT__xb0_reg) 
                                            + (IData)(vlTOPp->dct__DOT__xb7_reg)));
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__toggleB)))) {
                vlTOPp->dct__DOT__add_sub1b = (0xfffU 
                                               & ((IData)(vlTOPp->dct__DOT__xb7_reg) 
                                                  - (IData)(vlTOPp->dct__DOT__xb0_reg)));
            }
        }
    }
    vlTOPp->dct__DOT__p2a_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub2a_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory2a))))));
    vlTOPp->dct__DOT__p2b_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub2b_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory2a))))));
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__add_sub2b = 0U;
    } else {
        if (vlTOPp->dct__DOT__toggleB) {
            vlTOPp->dct__DOT__add_sub2b = (0xfffU & 
                                           ((IData)(vlTOPp->dct__DOT__xb1_reg) 
                                            + (IData)(vlTOPp->dct__DOT__xb6_reg)));
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__toggleB)))) {
                vlTOPp->dct__DOT__add_sub2b = (0xfffU 
                                               & ((IData)(vlTOPp->dct__DOT__xb6_reg) 
                                                  - (IData)(vlTOPp->dct__DOT__xb1_reg)));
            }
        }
    }
    vlTOPp->dct__DOT__p3a_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub3a_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory3a))))));
    vlTOPp->dct__DOT__p3b_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub3b_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory3a))))));
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__add_sub3b = 0U;
    } else {
        if (vlTOPp->dct__DOT__toggleB) {
            vlTOPp->dct__DOT__add_sub3b = (0xfffU & 
                                           ((IData)(vlTOPp->dct__DOT__xb2_reg) 
                                            + (IData)(vlTOPp->dct__DOT__xb5_reg)));
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__toggleB)))) {
                vlTOPp->dct__DOT__add_sub3b = (0xfffU 
                                               & ((IData)(vlTOPp->dct__DOT__xb5_reg) 
                                                  - (IData)(vlTOPp->dct__DOT__xb2_reg)));
            }
        }
    }
    vlTOPp->dct__DOT__p4a_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub4a_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory4a))))));
    vlTOPp->dct__DOT__p4b_all = (0xfffffffffULL & ((QData)((IData)(vlTOPp->dct__DOT__addsub4b_comp)) 
                                                   * (QData)((IData)(
                                                                     (0x7fU 
                                                                      & (IData)(vlTOPp->dct__DOT__memory4a))))));
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__add_sub4b = 0U;
    } else {
        if (vlTOPp->dct__DOT__toggleB) {
            vlTOPp->dct__DOT__add_sub4b = (0xfffU & 
                                           ((IData)(vlTOPp->dct__DOT__xb3_reg) 
                                            + (IData)(vlTOPp->dct__DOT__xb4_reg)));
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__toggleB)))) {
                vlTOPp->dct__DOT__add_sub4b = (0xfffU 
                                               & ((IData)(vlTOPp->dct__DOT__xb4_reg) 
                                                  - (IData)(vlTOPp->dct__DOT__xb3_reg)));
            }
        }
    }
    vlTOPp->dct__DOT__toggleA = __Vdly__dct__DOT__toggleA;
    vlTOPp->dct__DOT__toggleB = __Vdly__dct__DOT__toggleB;
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xa0_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xa0_reg = ((0x100U & 
                                          ((IData)(vlTOPp->dct__DOT__xa0_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xa0_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xa7_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xa7_reg = ((0x100U & 
                                          ((IData)(vlTOPp->dct__DOT__xa7_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xa7_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xa1_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xa1_reg = ((0x100U & 
                                          ((IData)(vlTOPp->dct__DOT__xa1_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xa1_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xa6_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xa6_reg = ((0x100U & 
                                          ((IData)(vlTOPp->dct__DOT__xa6_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xa6_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xa2_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xa2_reg = ((0x100U & 
                                          ((IData)(vlTOPp->dct__DOT__xa2_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xa2_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xa5_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xa5_reg = ((0x100U & 
                                          ((IData)(vlTOPp->dct__DOT__xa5_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xa5_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xa3_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xa3_reg = ((0x100U & 
                                          ((IData)(vlTOPp->dct__DOT__xa3_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xa3_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xa4_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xa4_reg = ((0x100U & 
                                          ((IData)(vlTOPp->dct__DOT__xa4_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xa4_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb0_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xb0_reg = ((0x800U & 
                                          ((IData)(vlTOPp->dct__DOT__xb0_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xb0_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb7_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xb7_reg = ((0x800U & 
                                          ((IData)(vlTOPp->dct__DOT__xb7_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xb7_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb1_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xb1_reg = ((0x800U & 
                                          ((IData)(vlTOPp->dct__DOT__xb1_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xb1_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb6_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xb6_reg = ((0x800U & 
                                          ((IData)(vlTOPp->dct__DOT__xb6_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xb6_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb2_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xb2_reg = ((0x800U & 
                                          ((IData)(vlTOPp->dct__DOT__xb2_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xb2_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb5_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xb5_reg = ((0x800U & 
                                          ((IData)(vlTOPp->dct__DOT__xb5_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xb5_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb3_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xb3_reg = ((0x800U & 
                                          ((IData)(vlTOPp->dct__DOT__xb3_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xb3_in));
        }
    }
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb4_reg = 0U;
    } else {
        if ((8U == (IData)(vlTOPp->dct__DOT__cntr8))) {
            vlTOPp->dct__DOT__xb4_reg = ((0x800U & 
                                          ((IData)(vlTOPp->dct__DOT__xb4_in) 
                                           << 1U)) 
                                         | (IData)(vlTOPp->dct__DOT__xb4_in));
        }
    }
    vlTOPp->dct__DOT__cntr8 = __Vdly__dct__DOT__cntr8;
    vlTOPp->dct__DOT__xa7_in = ((IData)(vlTOPp->__Vcellinp__dct__RST)
                                 ? 0U : (IData)(vlTOPp->dct__DOT__xa6_in));
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb7_in = 0U;
    } else {
        if (vlTOPp->dct__DOT__en_dct2d_reg) {
            vlTOPp->dct__DOT__xb7_in = vlTOPp->dct__DOT__xb6_in;
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__en_dct2d_reg)))) {
                vlTOPp->dct__DOT__xb7_in = 0U;
            }
        }
    }
    vlTOPp->dct__DOT__xa6_in = ((IData)(vlTOPp->__Vcellinp__dct__RST)
                                 ? 0U : (IData)(vlTOPp->dct__DOT__xa5_in));
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb6_in = 0U;
    } else {
        if (vlTOPp->dct__DOT__en_dct2d_reg) {
            vlTOPp->dct__DOT__xb6_in = vlTOPp->dct__DOT__xb5_in;
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__en_dct2d_reg)))) {
                vlTOPp->dct__DOT__xb6_in = 0U;
            }
        }
    }
    vlTOPp->dct__DOT__xa5_in = ((IData)(vlTOPp->__Vcellinp__dct__RST)
                                 ? 0U : (IData)(vlTOPp->dct__DOT__xa4_in));
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb5_in = 0U;
    } else {
        if (vlTOPp->dct__DOT__en_dct2d_reg) {
            vlTOPp->dct__DOT__xb5_in = vlTOPp->dct__DOT__xb4_in;
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__en_dct2d_reg)))) {
                vlTOPp->dct__DOT__xb5_in = 0U;
            }
        }
    }
    vlTOPp->dct__DOT__xa4_in = ((IData)(vlTOPp->__Vcellinp__dct__RST)
                                 ? 0U : (IData)(vlTOPp->dct__DOT__xa3_in));
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb4_in = 0U;
    } else {
        if (vlTOPp->dct__DOT__en_dct2d_reg) {
            vlTOPp->dct__DOT__xb4_in = vlTOPp->dct__DOT__xb3_in;
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__en_dct2d_reg)))) {
                vlTOPp->dct__DOT__xb4_in = 0U;
            }
        }
    }
    vlTOPp->dct__DOT__xa3_in = ((IData)(vlTOPp->__Vcellinp__dct__RST)
                                 ? 0U : (IData)(vlTOPp->dct__DOT__xa2_in));
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb3_in = 0U;
    } else {
        if (vlTOPp->dct__DOT__en_dct2d_reg) {
            vlTOPp->dct__DOT__xb3_in = vlTOPp->dct__DOT__xb2_in;
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__en_dct2d_reg)))) {
                vlTOPp->dct__DOT__xb3_in = 0U;
            }
        }
    }
    vlTOPp->dct__DOT__xa2_in = ((IData)(vlTOPp->__Vcellinp__dct__RST)
                                 ? 0U : (IData)(vlTOPp->dct__DOT__xa1_in));
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb2_in = 0U;
    } else {
        if (vlTOPp->dct__DOT__en_dct2d_reg) {
            vlTOPp->dct__DOT__xb2_in = vlTOPp->dct__DOT__xb1_in;
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__en_dct2d_reg)))) {
                vlTOPp->dct__DOT__xb2_in = 0U;
            }
        }
    }
    vlTOPp->dct__DOT__xa1_in = ((IData)(vlTOPp->__Vcellinp__dct__RST)
                                 ? 0U : (IData)(vlTOPp->dct__DOT__xa0_in));
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb1_in = 0U;
    } else {
        if (vlTOPp->dct__DOT__en_dct2d_reg) {
            vlTOPp->dct__DOT__xb1_in = vlTOPp->dct__DOT__xb0_in;
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__en_dct2d_reg)))) {
                vlTOPp->dct__DOT__xb1_in = 0U;
            }
        }
    }
    vlTOPp->dct__DOT__xa0_in = ((IData)(vlTOPp->__Vcellinp__dct__RST)
                                 ? 0U : (IData)(vlTOPp->__Vcellinp__dct__xin));
    if (vlTOPp->__Vcellinp__dct__RST) {
        vlTOPp->dct__DOT__xb0_in = 0U;
    } else {
        if (vlTOPp->dct__DOT__en_dct2d_reg) {
            vlTOPp->dct__DOT__xb0_in = vlTOPp->dct__DOT__data_out;
        } else {
            if ((1U & (~ (IData)(vlTOPp->dct__DOT__en_dct2d_reg)))) {
                vlTOPp->dct__DOT__xb0_in = 0U;
            }
        }
    }
    vlTOPp->dct__DOT__en_dct2d_reg = ((~ (IData)(vlTOPp->__Vcellinp__dct__RST)) 
                                      & (IData)(vlTOPp->dct__DOT__en_dct2d));
}

VL_INLINE_OPT void Vdct::_sequent__TOP__5(Vdct__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_sequent__TOP__5\n"); );
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    CData/*5:0*/ __Vdlyvdim0__dct__DOT__ram1_mem__v0;
    CData/*0:0*/ __Vdlyvset__dct__DOT__ram1_mem__v0;
    CData/*5:0*/ __Vdlyvdim0__dct__DOT__ram2_mem__v0;
    CData/*0:0*/ __Vdlyvset__dct__DOT__ram2_mem__v0;
    SData/*10:0*/ __Vdlyvval__dct__DOT__ram1_mem__v0;
    SData/*10:0*/ __Vdlyvval__dct__DOT__ram2_mem__v0;
    // Body
    __Vdlyvset__dct__DOT__ram2_mem__v0 = 0U;
    __Vdlyvset__dct__DOT__ram1_mem__v0 = 0U;
    vlTOPp->dct__DOT__data_out = (((IData)(vlTOPp->dct__DOT__en_ram1reg) 
                                   & (~ ((IData)(vlTOPp->dct__DOT__rd_cntr) 
                                         >> 6U))) ? 
                                  vlTOPp->dct__DOT__ram2_mem
                                  [(0x3fU & (IData)(vlTOPp->dct__DOT__rd_cntr))]
                                   : (((IData)(vlTOPp->dct__DOT__en_ram1reg) 
                                       & ((IData)(vlTOPp->dct__DOT__rd_cntr) 
                                          >> 6U)) ? 
                                      vlTOPp->dct__DOT__ram1_mem
                                      [(0x3fU & (IData)(vlTOPp->dct__DOT__rd_cntr))]
                                       : 0U));
    if (((IData)(vlTOPp->dct__DOT__en_ram1reg) & ((IData)(vlTOPp->dct__DOT__wr_cntr) 
                                                  >> 6U))) {
        __Vdlyvval__dct__DOT__ram2_mem__v0 = vlTOPp->dct__DOT__z_out_rnd;
        __Vdlyvset__dct__DOT__ram2_mem__v0 = 1U;
        __Vdlyvdim0__dct__DOT__ram2_mem__v0 = (0x3fU 
                                               & (IData)(vlTOPp->dct__DOT__wr_cntr));
    }
    if (((IData)(vlTOPp->dct__DOT__en_ram1reg) & (~ 
                                                  ((IData)(vlTOPp->dct__DOT__wr_cntr) 
                                                   >> 6U)))) {
        __Vdlyvval__dct__DOT__ram1_mem__v0 = vlTOPp->dct__DOT__z_out_rnd;
        __Vdlyvset__dct__DOT__ram1_mem__v0 = 1U;
        __Vdlyvdim0__dct__DOT__ram1_mem__v0 = (0x3fU 
                                               & (IData)(vlTOPp->dct__DOT__wr_cntr));
    }
    if (__Vdlyvset__dct__DOT__ram2_mem__v0) {
        vlTOPp->dct__DOT__ram2_mem[__Vdlyvdim0__dct__DOT__ram2_mem__v0] 
            = __Vdlyvval__dct__DOT__ram2_mem__v0;
    }
    if (__Vdlyvset__dct__DOT__ram1_mem__v0) {
        vlTOPp->dct__DOT__ram1_mem[__Vdlyvdim0__dct__DOT__ram1_mem__v0] 
            = __Vdlyvval__dct__DOT__ram1_mem__v0;
    }
}

VL_INLINE_OPT void Vdct::_combo__TOP__6(Vdct__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_combo__TOP__6\n"); );
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    VL_ASSIGN_ISW(8,vlTOPp->__Vcellinp__dct__xin, vlTOPp->xin);
    vlTOPp->dct__DOT__en_dct2d = ((~ (IData)(vlTOPp->__Vcellinp__dct__RST)) 
                                  & ((0x4fU == (IData)(vlTOPp->dct__DOT__cntr79)) 
                                     | (IData)(vlTOPp->dct__DOT__en_dct2d)));
}

VL_INLINE_OPT void Vdct::_sequent__TOP__7(Vdct__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_sequent__TOP__7\n"); );
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->dct__DOT__rd_cntr = vlTOPp->__Vdly__dct__DOT__rd_cntr;
    vlTOPp->dct__DOT__wr_cntr = vlTOPp->__Vdly__dct__DOT__wr_cntr;
    vlTOPp->dct__DOT__z_out_rnd = (0x7ffU & ((0x80U 
                                              & vlTOPp->dct__DOT__z_out_int)
                                              ? ((IData)(1U) 
                                                 + 
                                                 (vlTOPp->dct__DOT__z_out_int 
                                                  >> 8U))
                                              : (vlTOPp->dct__DOT__z_out_int 
                                                 >> 8U)));
    vlTOPp->dct__DOT__en_ram1reg = ((~ (IData)(vlTOPp->__Vcellinp__dct__RST)) 
                                    & (IData)(vlTOPp->dct__DOT__en_ram1));
}

VL_INLINE_OPT void Vdct::_combo__TOP__8(Vdct__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_combo__TOP__8\n"); );
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->dct__DOT__en_ram1 = ((~ (IData)(vlTOPp->__Vcellinp__dct__RST)) 
                                 & ((0xdU == (IData)(vlTOPp->dct__DOT__cntr12)) 
                                    | (IData)(vlTOPp->dct__DOT__en_ram1)));
    VL_ASSIGN_ISI(1,vlTOPp->__Vcellinp__dct__RST, vlTOPp->RST);
}

void Vdct::_eval(Vdct__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_eval\n"); );
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__1(vlSymsp);
    vlTOPp->__Vm_traceActivity[1U] = 1U;
    if ((((IData)(vlTOPp->__Vcellinp__dct__CLK) & (~ (IData)(vlTOPp->__Vclklast__TOP____Vcellinp__dct__CLK))) 
         | ((IData)(vlTOPp->__VinpClk__TOP____Vcellinp__dct__RST) 
            & (~ (IData)(vlTOPp->__Vclklast__TOP____VinpClk__TOP____Vcellinp__dct__RST))))) {
        vlTOPp->_sequent__TOP__4(vlSymsp);
        vlTOPp->__Vm_traceActivity[2U] = 1U;
    }
    if (((IData)(vlTOPp->__Vcellinp__dct__CLK) & (~ (IData)(vlTOPp->__Vclklast__TOP____Vcellinp__dct__CLK)))) {
        vlTOPp->_sequent__TOP__5(vlSymsp);
    }
    vlTOPp->_combo__TOP__6(vlSymsp);
    if ((((IData)(vlTOPp->__Vcellinp__dct__CLK) & (~ (IData)(vlTOPp->__Vclklast__TOP____Vcellinp__dct__CLK))) 
         | ((IData)(vlTOPp->__VinpClk__TOP____Vcellinp__dct__RST) 
            & (~ (IData)(vlTOPp->__Vclklast__TOP____VinpClk__TOP____Vcellinp__dct__RST))))) {
        vlTOPp->_sequent__TOP__7(vlSymsp);
        vlTOPp->__Vm_traceActivity[3U] = 1U;
    }
    vlTOPp->_combo__TOP__8(vlSymsp);
    // Final
    vlTOPp->__Vclklast__TOP____Vcellinp__dct__CLK = vlTOPp->__Vcellinp__dct__CLK;
    vlTOPp->__Vclklast__TOP____VinpClk__TOP____Vcellinp__dct__RST 
        = vlTOPp->__VinpClk__TOP____Vcellinp__dct__RST;
    vlTOPp->__VinpClk__TOP____Vcellinp__dct__RST = vlTOPp->__Vcellinp__dct__RST;
}

VL_INLINE_OPT QData Vdct::_change_request(Vdct__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_change_request\n"); );
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    return (vlTOPp->_change_request_1(vlSymsp));
}

VL_INLINE_OPT QData Vdct::_change_request_1(Vdct__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_change_request_1\n"); );
    Vdct* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    __req |= ((vlTOPp->__Vcellinp__dct__RST ^ vlTOPp->__Vchglast__TOP____Vcellinp__dct__RST));
    VL_DEBUG_IF( if(__req && ((vlTOPp->__Vcellinp__dct__RST ^ vlTOPp->__Vchglast__TOP____Vcellinp__dct__RST))) VL_DBG_MSGF("        CHANGE: ../xapp610/dct.v:88: __Vcellinp__dct__RST\n"); );
    // Final
    vlTOPp->__Vchglast__TOP____Vcellinp__dct__RST = vlTOPp->__Vcellinp__dct__RST;
    return __req;
}

#ifdef VL_DEBUG
void Vdct::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdct::_eval_debug_assertions\n"); );
}
#endif  // VL_DEBUG
