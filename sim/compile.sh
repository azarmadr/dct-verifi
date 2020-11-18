tabs 6
verilator --sc --trace --Wno-fatal ../xapp610/dct.v && \
python ../dct-py/dct_img.py && \
cd obj_dir && \
make -sf Vdct.mk && \
make -sf ../sc.mk all && \
cd ..
