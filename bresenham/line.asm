ideal
P486
model huge
jumps
stack 100h
dataseg
    screenmode  db 0
    instruct1   db "RODware presents: a line <insert trumpets here>",255
    instruct2   db "    -wiggle the mouse to do stuff",255
    instruct3   db "    -press the left mouse button to quit",255
    instruct4   db "    -blow lightly upon the keyboard to continue :)",255
    X1          dw 0
    Y1          db 0
    X2          dw 0
    Y2          db 0
codeseg
    startupcode
    mov AX,3
    int 10h
    ;AL <-- colornum (0..255)
    ;AH <-- red value (0..63)
    ;BL <-- green value (0..63)
    ;BH <-- blue value (0..63)
        mov AL,1
        mov AH,0
        mov BL,0
        mov BH,0
        call setcolor

        mov SI,offset instruct1
        mov AH,1
        mov BX,0
        call outtext
        mov SI,offset instruct2
        mov AH,1
        mov BX,1
        call outtext
        mov SI,offset instruct3
        mov AH,1
        mov BX,2
        call outtext
        mov SI,offset instruct4
        mov AH,1
        mov BX,3
        call outtext
        mov AH,0
        mov BL,0
        mov BH,1
COLORLOOP:
        push AX BX                  ;FADE IN!!!
        mov AL,1
        call setcolor
        ;insert slowdown timer here
        mov CX,0F000h
TIMER:  loop TIMER
        pop BX AX
        inc BH
        cmp BH,63
        je  DONECOLOR
        jmp COLORLOOP
DONECOLOR:
        mov AH,8
        int 21h
        call initialize
            mov AX,3
            int 33h
            mov AH,15
            shr CX,1
            mov BX,CX
            mov AL,DL
            mov [X1],CX
            mov [X2],CX
            mov [Y1],DL
            mov [Y2],DL
            call LINE
BEGIN:      mov AX,3
            int 33h
            cmp BX,0
            ja  DONE
            shr CX,1
            cmp CX,[X2]
            jne KICKIT
            cmp DL,[Y2]
            je  BEGIN
KICKIT:     push CX DX
            mov AH,0
            mov BX,[X1]
            mov AL,[Y1]
            mov CX,[X2]
            mov DL,[Y2]
            call LINE
            mov AH,15
            mov BX,[X1]
            mov AL,[Y1]
            pop DX CX
            mov [X2],CX
            mov [Y2],DL
            call LINE
            jmp BEGIN
DONE:
        call tidy_up
    exitcode

proc initialize near
    ;This procedure takes care of preliminary business, mousey stuff,
    ;video mode, etc.,

    ;VIDEO STUFF
    mov AH,0Fh          ;store old screen mode
    int 10h
    mov [screenmode],AL
    xor AH,AH           ;set 320x200x256 mode VGA 13h
    mov AL,13h
    int 10h

    ;MOUSE STUFF
    xor AX,AX           ;initialize mouse driver
    int 33h

    ret
endp initialize

proc tidy_up    near
    ;This procedure takes care of cleaning up the system after the
    ;program is done tweaking.
    xor AH,AH
    mov AL,[screenmode]
    cmp AL,13h
    jne @@1
    mov AL,2
@@1:int 10h
    ret
endp tidy_up

proc setcolor   near
    ;AL <-- colornum (0..255)
    ;AH <-- red value (0..63)
    ;BL <-- green value (0..63)
    ;BH <-- blue value (0..63)
    mov DX,3C8h
    out DX,AL
    inc DX
    mov AL,AH
    out DX,AL
    mov AL,BL
    out DX,AL
    mov AL,BH
    out DX,AL
    ret
endp setcolor

proc line       near
    ;AL <-- y1      * swap these.
    ;AH <-- color   *
    ;BX <-- x1
    ;CX <-- x2
    ;DL <-- y2
    ;corrupts BP,SI,DI,ES
    ;This procedure is a conglomeration of multiple procedures.  Each one
    ;draws a line in a different circumstance.
    ;1st  0 degree (horizontal)                 DONE!
    ;2nd  90 degree (vertical)                  DONE!
    ;0<degree<90 (positive slope)
    ;   3rd  0<degree<45 (Shallow positive)
    ;   4th  degree=45 (Slope=1)                DONE!
    ;   5th  45<degree<90 (Steep positive)
    ;90<degree<180 (negative slope)
    ;   6th  90<degree<135 (Steep negative)
    ;   7th  degree=135 (Slope=-1)              DONE!
    ;   8th  135<degreee<180 (Shallow negative)

    ;This sets up the destination memory location for the screen writes
    cmp BX,CX
    jbe @@00
    xchg BX,CX      ;make sure the line will be draw from left to right
    xchg DL,AL      ;if it isn't vertical
@@00:push AX
    push CX
    xor AH,AH
    fastimul CX,AX,320d
    add CX,BX
    mov DI,CX
    mov AX,0A000h
    mov ES,AX
    pop CX
    pop AX
    ;This part is the decision sequence which decides which algorithm to use
    cmp BX,CX
    je @@VERTICAL
    cmp AL,DL
    je @@HORIZONTAL
    cmp AL,DL
    ja @@POSITIVE
@@NEGATIVE:         ;the line has a negative slope (90<degree<180)
    mov BP,CX
    sub BP,BX       ;BP holds the horizontal length of the line
    xor DH,DH       ; |-----| <--BP
    mov SI,DX       ;  \      -
    push AX         ;    \    | <-- SI
    xor AH,AH       ;      \  -
    sub SI,AX       ;SI holds the vertical length of the line
    pop AX
    cmp BP,SI
    je  @@SLOPE_NEG_1
    cmp BP,SI
    ja  @@SHALLOW_NEG
@@STEEP_NEG:        ;90<degree<135
    inc SI
    inc BP
    xchg AH,AL
    push AX
    mov AX,SI
    mov DX,BP
    div DL
    mov DX,AX       ;DH = remainder (counter)  DL = quotient
    pop AX          ;AL = color of the line
    mov AH,DH       ;AH = remainder (reference)
    mov BX,BP       ;BL = divisor
@@STEEP_NEG01:
    mov CL,DL
    xor CH,CH
    add DH,AH
    cmp DH,BL
    jbe @@STEEP_NEG02
    sub DH,BL
    inc CL
@@STEEP_NEG02:
    stosb
    add DI,319
    loop @@STEEP_NEG02
    inc DI
    dec BP
    cmp BP,0
    ja  @@STEEP_NEG01
    ret
@@SLOPE_NEG_1:      ;degree=135
    inc BP
    mov AL,AH
@@SLOPE_NEG_1A:
    stosb
    add DI,320d
    dec BP
    cmp BP,0
    je  @@SLOPE_NEG_1B
    jmp @@SLOPE_NEG_1A
@@SLOPE_NEG_1B:
    ret
@@SHALLOW_NEG:      ;135<degree<180
    xchg AL,AH      ;AL = color
    push AX         ;AX needs to be free for DIV
    inc BP          ;this gives the true horizontal length of the line
    inc SI          ;          "         vertical         "
    mov AX,BP       ;BP / SI
    mov DX,SI
    div DL
    mov DH,AH       ;DH = remainder (counter)
    mov DL,AL       ;DL = quotient
    pop AX          ;AL = color of the line
    mov AH,DH       ;AH = remainder (reference)
    mov BX,SI       ;BL = divisor
@@SHALLOW_NEG01:
    mov CL,DL
    xor CH,CH
    add DH,AH
    cmp DH,BL
    jbe @@SHALLOW_NEG02
    sub DH,BL
    inc CL
@@SHALLOW_NEG02:
    rep stosb
    add DI,320
    dec SI
    cmp SI,0
    ja  @@SHALLOW_NEG01
    ret
@@POSITIVE:
    mov BP,CX
    sub BP,BX       ;BP holds the horizontal length of the line
    push AX
    xor AH,AH
    mov SI,AX
    pop AX
    xor DH,DH
    sub SI,DX       ;SI holds the vertical length of the line
    cmp BP,SI
    je  @@SLOPE_POS_1
    cmp BP,SI
    ja  @@SHALLOW_POS
@@STEEP_POS:        ;45<degree<90
    inc SI
    inc BP
    xchg AH,AL
    push AX
    mov AX,SI
    mov DX,BP
    div DL
    mov DX,AX       ;DH = remainder (counter)  DL = quotient
    pop AX          ;AL = color of the line
    mov AH,DH       ;AH = remainder (reference)
    mov BX,BP       ;BL = divisor
@@STEEP_POS01:
    mov CL,DL
    xor CH,CH
    add DH,AH
    cmp DH,BL
    jbe @@STEEP_POS02
    sub DH,BL
    inc CL
@@STEEP_POS02:
    stosb
    sub DI,321d
    loop @@STEEP_POS02
    inc DI
    dec BP
    cmp BP,0
    ja  @@STEEP_POS01
    ret
@@SLOPE_POS_1:      ;degree=45
    inc BP
    mov AL,AH
@@SLOPE_POS_1A:
    stosb
    sub DI,320d
    dec BP
    cmp BP,0
    je  @@SLOPE_POS_1B
    jmp @@SLOPE_POS_1A
@@SLOPE_POS_1B:
    ret
@@SHALLOW_POS:      ;0<degree<45
    xchg AL,AH      ;AL = color
    push AX         ;AX needs to be free for DIV
    inc BP          ;this gives the true horizontal length of the line
    inc SI          ;          "         vertical         "
    mov AX,BP       ;BP / SI
    mov DX,SI
    div DL
    mov DH,AH       ;DH = remainder (counter)
    mov DL,AL       ;DL = quotient
    pop AX          ;AL = color of the line
    mov AH,DH       ;AH = remainder (reference)
    mov BX,SI       ;BL = divisor
    mov BH,BL
    shr BH,1        ;BH = divisor / 2   !!UNNECESSARY!!
@@SHALLOW_POS01:
    mov CL,DL
    xor CH,CH
    add DH,AH
    cmp DH,BL
    jbe @@SHALLOW_POS02
    sub DH,BL
    inc CL
@@SHALLOW_POS02:
    rep stosb
    sub DI,320
    dec SI
    cmp SI,0
    ja  @@SHALLOW_POS01
    ret
@@VERTICAL:         ;degree=90
    cmp AL,DL
    jbe @@VERTICAL00
    push AX
    push DX
    xor DH,DH
    fastimul AX,DX,320d
    add AX,BX
    mov DI,AX
    pop DX
    pop AX
    xchg DL,AL
@@VERTICAL00:
    xchg AL,AH
    sub DL,AH
    inc DL
@@VERTICAL01:
    stosb
    add DI,319d
    dec DL
    cmp DL,0
    je @@VERTICAL02
    jmp @@VERTICAL01
@@VERTICAL02:
    ret
@@HORIZONTAL:       ;degree=0
    sub CX,BX
    inc CX
    mov AL,AH
    rep stosb
    ret
endp line

proc outtext    near
    ;DS:SI <-- location of string to write to screen
    ;AH color of the letters
    ;BH <-- X coordinate to begin
    ;BL <-- Y coordinate to begin
@@1:lodsb
    cmp AL,255
    je  @@DONE
    push BX AX
    call write
    pop AX BX
    inc BH
    jmp @@1
@@DONE:ret
endp outtext

proc write		near
	;This procedure writes a character to the text screen(80x25)
	;AH <-- color of the character
	;AL <-- character
	;BH <-- X coordinate of character
	;BL <-- Y coordinate of character
	push BX
	xor BH,BH
	fastimul DX,BX,160d
	pop BX
	mov BL,BH
	xor BH,BH
    shl BX,1
	add DX,BX
	mov DI,DX
	mov DX,0B800h
	mov ES,DX
	stosw
	ret
endp write
end
