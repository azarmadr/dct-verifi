tabs 6
verilator --sc --trace --Wno-fatal ../xapp610/dct.v && \
cd obj_dir && \
make -f Vdct.mk && \
make -f ../sc.mk all && \
cd ..
