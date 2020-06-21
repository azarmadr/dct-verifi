verilator --trace -f verilator.cmd
cd obj_dir
make -f Vdct.mk Vdct__ALL.a
make -f ../sc.mk sc_main.o
make -f ../sc.mk verilated.o
make -f ../sc.mk verilated_vcd_c.o
make -f ../sc.mk verilated_vcd_sc.o
g++ -L$SYSTEMC_HOME/lib-linux64 sc_main.o verilated.o Vdct__ALL.o  verilated_vcd_c.o verilated_vcd_sc.o -o Vdct -lsystemc
cd ..
./obj_dir/Vdct
#gtkwave.exe vl.vcd &
