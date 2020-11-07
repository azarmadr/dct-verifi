// Verilated -*- SystemC -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _VDCT_H_
#define _VDCT_H_  // guard

#include "systemc.h"
#include "verilated_sc.h"
#include "verilated.h"

//==========

class Vdct__Syms;
class Vdct_VerilatedVcd;


//----------

SC_MODULE(Vdct) {
  public:
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    sc_in<bool> CLK;
    sc_in<bool> RST;
    sc_out<bool> rdy_out;
    sc_out<sc_bv<12> > dct_2d;
    sc_in<sc_bv<8> > xin;
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        CData/*7:0*/ dct__DOT__memory1a;
        CData/*7:0*/ dct__DOT__memory2a;
        CData/*7:0*/ dct__DOT__memory3a;
        CData/*7:0*/ dct__DOT__memory4a;
        CData/*7:0*/ dct__DOT__xa0_in;
        CData/*7:0*/ dct__DOT__xa1_in;
        CData/*7:0*/ dct__DOT__xa2_in;
        CData/*7:0*/ dct__DOT__xa3_in;
        CData/*7:0*/ dct__DOT__xa4_in;
        CData/*7:0*/ dct__DOT__xa5_in;
        CData/*7:0*/ dct__DOT__xa6_in;
        CData/*7:0*/ dct__DOT__xa7_in;
        CData/*7:0*/ dct__DOT__addsub1a_comp;
        CData/*7:0*/ dct__DOT__addsub2a_comp;
        CData/*7:0*/ dct__DOT__addsub3a_comp;
        CData/*7:0*/ dct__DOT__addsub4a_comp;
        CData/*0:0*/ dct__DOT__save_sign1a;
        CData/*0:0*/ dct__DOT__save_sign2a;
        CData/*0:0*/ dct__DOT__save_sign3a;
        CData/*0:0*/ dct__DOT__save_sign4a;
        CData/*1:0*/ dct__DOT__i_wait;
        CData/*0:0*/ dct__DOT__toggleA;
        CData/*3:0*/ dct__DOT__cntr12;
        CData/*3:0*/ dct__DOT__cntr8;
        CData/*6:0*/ dct__DOT__cntr79;
        CData/*6:0*/ dct__DOT__wr_cntr;
        CData/*6:0*/ dct__DOT__rd_cntr;
        CData/*6:0*/ dct__DOT__cntr92;
        CData/*0:0*/ dct__DOT__en_ram1;
        CData/*0:0*/ dct__DOT__en_dct2d;
        CData/*0:0*/ dct__DOT__en_ram1reg;
        CData/*0:0*/ dct__DOT__en_dct2d_reg;
        CData/*0:0*/ dct__DOT__save_sign1b;
        CData/*0:0*/ dct__DOT__save_sign2b;
        CData/*0:0*/ dct__DOT__save_sign3b;
        CData/*0:0*/ dct__DOT__save_sign4b;
        CData/*0:0*/ dct__DOT__toggleB;
        SData/*8:0*/ dct__DOT__xa0_reg;
        SData/*8:0*/ dct__DOT__xa1_reg;
        SData/*8:0*/ dct__DOT__xa2_reg;
        SData/*8:0*/ dct__DOT__xa3_reg;
        SData/*8:0*/ dct__DOT__xa4_reg;
        SData/*8:0*/ dct__DOT__xa5_reg;
        SData/*8:0*/ dct__DOT__xa6_reg;
        SData/*8:0*/ dct__DOT__xa7_reg;
        SData/*8:0*/ dct__DOT__add_sub1a;
        SData/*8:0*/ dct__DOT__add_sub2a;
        SData/*8:0*/ dct__DOT__add_sub3a;
        SData/*8:0*/ dct__DOT__add_sub4a;
        SData/*10:0*/ dct__DOT__z_out_rnd;
        SData/*10:0*/ dct__DOT__data_out;
        SData/*10:0*/ dct__DOT__xb0_in;
        SData/*10:0*/ dct__DOT__xb1_in;
        SData/*10:0*/ dct__DOT__xb2_in;
        SData/*10:0*/ dct__DOT__xb3_in;
        SData/*10:0*/ dct__DOT__xb4_in;
        SData/*10:0*/ dct__DOT__xb5_in;
        SData/*10:0*/ dct__DOT__xb6_in;
        SData/*10:0*/ dct__DOT__xb7_in;
        SData/*11:0*/ dct__DOT__xb0_reg;
        SData/*11:0*/ dct__DOT__xb1_reg;
        SData/*11:0*/ dct__DOT__xb2_reg;
        SData/*11:0*/ dct__DOT__xb3_reg;
        SData/*11:0*/ dct__DOT__xb4_reg;
    };
    struct {
        SData/*11:0*/ dct__DOT__xb5_reg;
        SData/*11:0*/ dct__DOT__xb6_reg;
        SData/*11:0*/ dct__DOT__xb7_reg;
        SData/*11:0*/ dct__DOT__add_sub1b;
        SData/*11:0*/ dct__DOT__add_sub2b;
        SData/*11:0*/ dct__DOT__add_sub3b;
        SData/*11:0*/ dct__DOT__add_sub4b;
        SData/*10:0*/ dct__DOT__addsub1b_comp;
        SData/*10:0*/ dct__DOT__addsub2b_comp;
        SData/*10:0*/ dct__DOT__addsub3b_comp;
        SData/*10:0*/ dct__DOT__addsub4b_comp;
        IData/*18:0*/ dct__DOT__p1a;
        IData/*18:0*/ dct__DOT__p2a;
        IData/*18:0*/ dct__DOT__p3a;
        IData/*18:0*/ dct__DOT__p4a;
        IData/*18:0*/ dct__DOT__z_out_int1;
        IData/*18:0*/ dct__DOT__z_out_int2;
        IData/*18:0*/ dct__DOT__z_out_int;
        IData/*31:0*/ dct__DOT__indexi;
        IData/*19:0*/ dct__DOT__p1b;
        IData/*19:0*/ dct__DOT__p2b;
        IData/*19:0*/ dct__DOT__p3b;
        IData/*19:0*/ dct__DOT__p4b;
        IData/*19:0*/ dct__DOT__dct2d_int1;
        IData/*19:0*/ dct__DOT__dct2d_int2;
        IData/*19:0*/ dct__DOT__dct_2d_int;
        IData/*31:0*/ dct__DOT__unnamedblk1__DOT__itemp;
        QData/*35:0*/ dct__DOT__p1a_all;
        QData/*35:0*/ dct__DOT__p2a_all;
        QData/*35:0*/ dct__DOT__p3a_all;
        QData/*35:0*/ dct__DOT__p4a_all;
        QData/*35:0*/ dct__DOT__p1b_all;
        QData/*35:0*/ dct__DOT__p2b_all;
        QData/*35:0*/ dct__DOT__p3b_all;
        QData/*35:0*/ dct__DOT__p4b_all;
        SData/*10:0*/ dct__DOT__ram1_mem[64];
        SData/*10:0*/ dct__DOT__ram2_mem[64];
    };
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    CData/*0:0*/ __Vcellinp__dct__RST;
    CData/*0:0*/ __Vcellinp__dct__CLK;
    CData/*7:0*/ __Vcellinp__dct__xin;
    CData/*6:0*/ __Vdly__dct__DOT__rd_cntr;
    CData/*6:0*/ __Vdly__dct__DOT__wr_cntr;
    CData/*0:0*/ __VinpClk__TOP____Vcellinp__dct__RST;
    CData/*0:0*/ __Vclklast__TOP____Vcellinp__dct__CLK;
    CData/*0:0*/ __Vclklast__TOP____VinpClk__TOP____Vcellinp__dct__RST;
    CData/*0:0*/ __Vchglast__TOP____Vcellinp__dct__RST;
    CData/*0:0*/ __Vm_traceActivity[4];
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    Vdct__Syms* __VlSymsp;  // Symbol table
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vdct);  ///< Copying not allowed
  public:
    SC_CTOR(Vdct);
    virtual ~Vdct();
    /// Trace signals in the model; called by application code
    void trace(VerilatedVcdC* tfp, int levels, int options = 0);
    /// SC tracing; avoid overloaded virtual function lint warning
    virtual void trace(sc_trace_file* tfp) const override { ::sc_core::sc_module::trace(tfp); }
    
    // API METHODS
  private:
    void eval() { eval_step(); }
    void eval_step();
  public:
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(Vdct__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(Vdct__Syms* symsp, bool first);
  private:
    static QData _change_request(Vdct__Syms* __restrict vlSymsp);
    static QData _change_request_1(Vdct__Syms* __restrict vlSymsp);
  public:
    static void _combo__TOP__1(Vdct__Syms* __restrict vlSymsp);
    static void _combo__TOP__6(Vdct__Syms* __restrict vlSymsp);
    static void _combo__TOP__8(Vdct__Syms* __restrict vlSymsp);
  private:
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(Vdct__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif  // VL_DEBUG
  public:
    static void _eval_initial(Vdct__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(Vdct__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _initial__TOP__3(Vdct__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _sequent__TOP__4(Vdct__Syms* __restrict vlSymsp);
    static void _sequent__TOP__5(Vdct__Syms* __restrict vlSymsp);
    static void _sequent__TOP__7(Vdct__Syms* __restrict vlSymsp);
    static void _settle__TOP__2(Vdct__Syms* __restrict vlSymsp) VL_ATTR_COLD;
  private:
    static void traceChgSub0(void* userp, VerilatedVcd* tracep);
    static void traceChgTop0(void* userp, VerilatedVcd* tracep);
    static void traceCleanup(void* userp, VerilatedVcd* /*unused*/);
    static void traceFullSub0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceFullTop0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInitSub0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInitTop(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    void traceRegister(VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) VL_ATTR_COLD;
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
