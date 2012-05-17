@echo --------------------------------------
@echo Converting image file to RLE file
@echo --------------------------------------
@echo .
@echo Using %1
@echo .
@echo [ STEP 1] - converting to RAW format...
@win-bin\convert -depth 8 %1 rgb:%1.raw
@echo .
@echo [ STEP 2] - converting to Final RLE...
@win-bin\to565 -rle < %1.raw > %1.rle
@echo .
@echo --------------------------------------
@echo DONE!!!
@echo --------------------------------------
