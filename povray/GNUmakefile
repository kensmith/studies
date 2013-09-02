stars.png \
    : stars.pov \
    ; povray -H768 -W1366 $<

.PHONY: clean view
clean \
    : \
    ; rm -f stars.png

view \
    : stars.png \
    ; feh -F stars.png
