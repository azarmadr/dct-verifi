tabs 6
python ./dct_img.py && \
verilator --sc --trace --Wno-fatal --Mdir obj_idct ../xapp611/idct.v && \
cd obj_idct && \
make -sf Vidct.mk && \
make -sf ../make_idct.mk all && \
cd ..
rm idct.txt
