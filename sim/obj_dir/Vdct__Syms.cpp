// Verilated -*- SystemC -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vdct__Syms.h"
#include "Vdct.h"



// FUNCTIONS
Vdct__Syms::Vdct__Syms(Vdct* topp, const char* namep)
    // Setup locals
    : __Vm_namep(namep)
    , __Vm_dumping(false)
    , __Vm_dumperp(nullptr)
    , __Vm_activity(false)
    , __Vm_baseCode(0)
    , __Vm_didInit(false)
    // Setup submodule names
{
    // Pointer to top level
    TOPp = topp;
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOPp->__Vconfigure(this, true);
}
