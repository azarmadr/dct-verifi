tabs 6
verilator --sc --trace --Wno-fatal ../xapp610/dct.v && \
#python ../dct-py/dct_img.py && \
cd obj_dir && \
make -f Vdct.mk && \
make -f ../sc.mk all && \
cd ..
