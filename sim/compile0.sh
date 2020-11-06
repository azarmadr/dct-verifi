tabs 6
verilator --sc --trace --Wno-fatal --Mdir obj_dir0 ../backup/dct.v && \
cd obj_dir0 && \
make -f Vdct.mk && \
make -f ../sc.mk all && \
cd ..
