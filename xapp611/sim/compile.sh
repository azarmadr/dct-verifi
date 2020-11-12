tabs 6
verilator --sc --trace --Wno-fatal ../idct.v && \
#python ../../dct-py/dct_img.py && \
cd obj_dir && \
make -s -f Vidct.mk && \
make -s -f ../sc.mk all && \
cd ..
