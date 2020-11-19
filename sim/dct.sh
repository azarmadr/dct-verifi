tabs 6
python ./dct_img.py && \
verilator --sc --trace --Wno-fatal --Mdir obj_dct ../xapp610/dct.v && \
cd obj_dct && \
make -sf Vdct.mk && \
make -sf ../make_dct.mk all && \
cd ..
rm dct.txt
