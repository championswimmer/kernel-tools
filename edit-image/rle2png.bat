@echo --------------------------------------
@echo Converting RLE file to image file
@echo --------------------------------------
@echo .
@echo Using %1
@echo .
@echo [ STEP 1] - converting to RLE to RAW format...
@win-bin\5652rgb -rle < %1 > %1.raw
@echo .
@echo [ STEP 2] - converting to Final iamge format...
@win-bin\convert -depth 8 -size 480x854 rgb:%1.raw %1.png
@echo .
@echo --------------------------------------
@echo DONE!!!
@echo --------------------------------------
