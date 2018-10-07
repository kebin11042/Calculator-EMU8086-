name "10jo"
;;;;;;;;;;;;;;;MACRO;;;;;;;;;;;;;;;;;;;;;;;;;
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM

PUTS    MACRO   string
        PUSH    AX
        PUSH    DX
        MOV     DX, offset string
        MOV     AH, 09H
        INT     21H
        POP     DX
        POP     AX
ENDM

CLEAR   MACRO
        PUSH    AX
        PUSH    CX
        PUSH    DX
        PUSH    BX
        
        MOV     AH, 06
        MOV     AL, 00
        MOV     BH, 07
        MOV     CX, 0000
        MOV     DH, 24
        MOV     DL, 79
        INT     10H
        
        MOV     AH, 02
        MOV     BH, 00
        MOV     DX, 0000
        INT     10H
        
        PUSH    BX
        PUSH    DX
        PUSH    CX
        PUSH    AX
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
org 100h
jmp start
;;;;;;;;;;;;;;;;;;;변수;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
skin                  DB   '-------------------------------- 1.Enter the number1',0dh, 0ah
                      DB   '| RESULT :                      | 2.Enter the operator(+-*/)',0dh, 0ah
                      DB   '|------------------------------| 3.Enter the number2',0dh, 0ah
                      DB   '|                              | 4.Enter the function(r,c,q)',0dh, 0ah
                      DB   '|------------------------------|      *  *  *    ',0dh, 0ah
                      DB   '| MERRY CHRISTMAS              |  *     ***      ',0dh, 0ah
                      DB   '| -----  -----  -----  -----   |       * ***  *  ',0dh, 0ah
                      DB   '| | 1 |  | 2 |  | 3 |  | + |   |    * *******    ',0dh, 0ah
                      DB   '| -----  -----  -----  -----   |       *****     ',0dh, 0ah
                      DB   '| -----  -----  -----  -----   |  *   ***** *   *',0dh, 0ah
                      DB   '| | 4 |  | 5 |  | 6 |  | - |   |     *********   ',0dh, 0ah
                      DB   '| -----  -----  -----  -----   |    *********** *',0dh, 0ah
                      DB   '| -----  -----  -----  -----   |     *** *****   ',0dh, 0ah
                      DB   '| | 7 |  | 8 |  | 9 |  | X |   |  * *********  * ',0dh, 0ah
                      DB   '| -----  -----  -----  -----   |    ******* ***  ',0dh, 0ah
                      DB   '| -----  -----  -----  -----   |   ************* ',0dh, 0ah
                      DB   '| | C |  | 0 |  | R |  | / |   |        ***      ',0dh, 0ah
                      DB   '| -----  -----  -----  -----   |        ***      ',0dh, 0ah
                      DB   '------------------------------- -----------------$',0dh, 0ah
made                  DB   '                                 Made by Group 10$'
blank                 DB    '                             $'
re_blank              DB    '                     $'                           



scan_number         db  12    dup (30h)  ;12자리
scan_dot_num        db  8     dup (30h)  ;8자리
number1             db  12    dup (30h)
dot_num1            db  8     dup (30h)
opr_flag            db  0
empty0              db  0
scan_number2        db  12    dup (30h)  ;12자리
scan_dot_num2       db  8     dup (30h)  ;8자리
number2             db  12    dup (30h)
dot_num2            db  8     dup (30h)
empty               db  10    dup (30h)
result              db  20    dup (30h)  ;결과
printf              db  0
number1_minusflag   db  0
number2_minusflag   db  0
print_minus_flag    db  0
sum_to_minus        db  0
mul_result          db  20     dup (30h)
mul_base            db  20     dup (30h)
mul_dot_falg        db  0
re_flag             db  0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;msg;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

msg0 db "num1 : $"
msg1 db "opr : $"
msg2 db "num2 : $"


;;;;;;;;;;;;;;;;;;;Main;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start:  
        
        mov ah, 09
        mov bh, 00
        mov al, 20h
        mov cx, 800h
        mov bl, 4fh
        int 10h
        
        PUTS    skin
        
        MOV     AH, 02
        MOV     BH, 00
        MOV     Dl, 00
        mov     dh, 19
        INT     10H
        
        mov ah, 09
        mov bh, 00
        mov al, 20h
        mov cx, 49
        mov bl, 4eh
        int 10h
        
        PUTS    made

        MOV     AH, 02
        MOV     BH, 00
        MOV     Dl, 09
        mov     dh, 01
        INT     10H
        
        mov ah, 09
        mov bh, 00
        mov al, 20h
        mov cx, 22
        mov bl, 4ah
        int 10h
        
                PUSH    AX
                PUSH    SI
                PUSH    CX
                
        PUTC ' '
       
        mov si, 0
        mov cx, 20
        
        cmp number1_minusflag, 0
        je  print_re_start
        PUTC  8
        PUTC '-'    

print_re_start:
        mov al, number1+si
        or  al, 30h
        mov printf, al
        
        cmp si, 12
        jne print_re_dot
        PUTC '.'

print_re_dot:
              
        PUTC printf
        
        inc si
        
        loop print_re_start
        
        PUTC    0dh
        PUTC    0ah
          
        
        POP     CX
        POP     SI
        POP     AX        
        
        MOV     AH, 02
        MOV     BH, 00
        MOV     Dl, 02
        mov     dh, 03
        INT     10H
        
        cmp     re_flag, 1
        je      result_opr_start

PUTS msg0
call SCAN_NUM

        MOV     AH, 02
        MOV     BH, 00
        MOV     Dl, 02
        mov     dh, 03
        INT     10H
        
        PUTS    blank
        
        MOV     AH, 02
        MOV     BH, 00
        MOV     Dl, 02
        mov     dh, 03
        INT     10H

result_opr_start:
mov re_flag, 0

PUTS msg1
call OPR_SET

        MOV     AH, 02
        MOV     BH, 00
        MOV     Dl, 02
        mov     dh, 03
        INT     10H
        
        PUTS    blank
        
        MOV     AH, 02
        MOV     BH, 00
        MOV     Dl, 02
        mov     dh, 03
        INT     10H

PUTS msg2
call SCAN_NUM2

        MOV     AH, 02
        MOV     BH, 00
        MOV     Dl, 02
        mov     dh, 03
        INT     10H
        
        PUTS    blank
        
        MOV     AH, 02
        MOV     BH, 00
        MOV     Dl, 02
        mov     dh, 03
        INT     10H

cmp opr_flag, 1
je do_sum
cmp opr_flag, 2
je do_minus
cmp opr_flag, 3
je do_mul
cmp opr_flag, 4
je  opr_div

do_sum:
call OPR_SUM 

cmp sum_to_minus, 1
je  do_minus
jmp do_print_result

do_minus:
call OPR_MINUS
jmp do_print_result

do_mul:
call OPR_MUL
jmp do_print_result

do_div:
jmp opr_div
ret_div:

do_print_result:
call PRINT_RESULT

function:
    
    mov al, 0h
    mov ah,07h       
    int 21h
    
    cmp al, 'q'     
    je  cal_exit
    
    cmp al, 'r'     
    je result_opr
    
    cmp al, 'c'      
    je  cal_c

    jmp function
    
    
result_opr:
    mov cx, 20
    mov si, 0
 result_opr_loop:
    mov al, result+si
    or  al, 30h
    mov number1+si, al
    mov result+si, 30h
    mov number2+si, 30h
    inc si
    loop result_opr_loop
    mov sum_to_minus, 0
    mov al, print_minus_flag
    mov number1_minusflag, al
    mov number2_minusflag, 0
    mov print_minus_flag, 0
    mov opr_flag, 0
    CLEAR       
    sub ax, ax
    sub bx, bx
    sub cx, cx
    sub dx, dx
    sub si, si
    sub di, di
    mov re_flag, 1
    jmp start
    
cal_c:
    mov cx, 20
    mov si, 0
 cal_c_loop:
    mov result+si, 30h
    mov number1+si, 30h
    mov number2+si, 30h
    inc si
    loop cal_c_loop
    mov number1_minusflag, 0
    mov number2_minusflag, 0
    mov print_minus_flag, 0
    mov sum_to_minus, 0
    mov opr_flag, 0
    CLEAR
    sub ax, ax
    sub bx, bx
    sub cx, cx
    sub dx, dx
    sub si, si
    sub di, di
    jmp start
    
cal_exit:

    RET


;;;;;;;;;;;;;;;;;;;;;;;;SCAN_NUM1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        PUSH    DI
        PUSH    CX
        
        sub si, si  ;자리수 위치
        sub di, di  ;소숫점 위치
        sub dx, dx            
        
scan_start:

    mov al, 0h
    mov ah,01h      ;입력받기 
    int 21h
    
    cmp al, 39h
    ja  scan_alpha
    
    cmp al, 0dh     ; 엔터일때
    je  scan_exit
    
    cmp al, '.'     ;'.'이 찍혓을때
    je scan_dot
    
    cmp al, '-'     ; '-'가 찍혔을때
    je  make_minus
    
scan_back:
    
    cmp al, 8
    jne scan_noback ; 백스페이스가 아닐때

scan_numback:
    
    PUTC    20h     ; '.'이 두번찍혔을때
    PUTC    8
    cmp dx, 1
    je  dot_backspace  
    dec si
    mov scan_number+si, 0
    jmp scan_start
    
scan_alpha:
    
    PUTC    8
    PUTC    20h
    PUTC    8
    jmp     scan_start

dot_backspace:      ; '.'이 찍혓을때 backspace
    
    dec di
    mov scan_dot_num+di, 0
    jmp scan_start
    
make_minus:
    mov number1_minusflag, 1
    jmp scan_start
    
scan_dot_back:
    
    PUTC    8
    PUTC    20h
    PUTC    8
    jmp scan_start
    
scan_dot:
    cmp dx, 1
    je  scan_dot_back
    inc dx
    jmp scan_start
    
scan_noback:
    
    cmp dx, 1
    je scan_dot_number
    mov scan_number+si, al
    inc si
    jmp scan_re
    
scan_dot_number:

    mov scan_dot_num+di, al 
    inc di
    jmp scan_re    
    
scan_re:
    jmp scan_start
    
scan_exit:
    
    mov ax, 0ch
    sub ax, si  ; 12 - si 값
    mov di, 0ch
    
num_shift_start:
    mov cx, si
    inc cx
    mov si, ax
    mov ax, 0ch
    sub ax, si
    mov si, ax
num_shift:
    mov al, scan_number+si
    or  al, 30h
    mov number1+di, al
    dec di
    dec si
    loop num_shift
    
    mov cx, 9
    mov di, 0
dot_shift:
    mov al, scan_dot_num+di
    or  al, 30h
    mov dot_num1+di, al
    inc di
    loop dot_shift
    
    
        
        POP     CX
        POP     DI
        POP     SI
        POP     AX
        POP     DX
        RET
SCAN_NUM        ENDP


;;;;;;;;;;;;;;;;;;;;;OPR_READ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OPR_SET        PROC    NEAR
        PUSH    DX
        PUSH    AX

    mov opr_flag, 0

opr_start:        
    mov al, 0h
    
    mov ah, 01
    int 21h
    
    cmp al, '*'
    jb wrong_opr
    cmp al, '/'
    ja wrong_opr
    cmp al, '+'
    je  sum_flag
    cmp al, '-'
    je  minus_flag
    cmp al, '*'
    je  product_flag
    cmp al, '/'
    je  div_flag
    
wrong_opr:
    
    PUTC    8
    PUTC    20h
    PUTC    8
    jmp opr_start
    
sum_flag:
    mov opr_flag, 1
    jmp opr_exit
minus_flag:
    mov opr_flag, 2
    jmp opr_exit
product_flag:
    mov opr_flag, 3
    jmp opr_exit
div_flag:
    mov opr_flag, 4

opr_exit:

    PUTC    0dh
    PUTC    0ah

        POP     AX
        POP     DX
        RET
OPR_SET      ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCAN_NUM2        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        PUSH    DI
        PUSH    CX
        
        sub si, si  ;자리수 위치
        sub di, di  ;소숫점 위치
        sub dx, dx
        mov number2_minusflag, 0            
        
scan_start2:

    mov al, 0h
    mov ah,01h      ;입력받기 
    int 21h
    
    cmp al, 39h
    ja  scan_alpha2
    
    cmp al, 0dh     ; 엔터일때
    je  scan_exit2
    
    cmp al, '.'     ;'.'이 찍혓을때
    je scan_dot2
    
    cmp al, '-'     ; '-'가 찍혔을때
    je make_minus2
    
scan_back2:
    
    cmp al, 8
    jne scan_noback2 ; 백스페이스일때

scan_numback2:
    
    PUTC    20h     ; '.'이 두번찍혔을때
    PUTC    8
    cmp dx, 1
    je  dot_backspace2  
    dec si
    mov scan_number2+si, 0
    jmp scan_start2
    
scan_alpha2:
    
    PUTC    8
    PUTC    20h
    PUTC    8
    jmp     scan_start2

dot_backspace2:      ; '.'이 찍혓을때 backspace
    
    dec di
    mov scan_dot_num2+di, 0
    jmp scan_start2
    
scan_dot_back2:
    
    PUTC    8
    PUTC    20h
    PUTC    8
    jmp scan_start2
    
scan_dot2:
    cmp dx, 1
    je  scan_dot_back2
    inc dx
    jmp scan_start2
    
make_minus2:
    mov number2_minusflag, 1
    jmp scan_start2        

scan_noback2:
    
    cmp dx, 1
    je scan_dot_number2
    mov scan_number2+si, al
    inc si
    jmp scan_re2
    
scan_dot_number2:

    mov scan_dot_num2+di, al 
    inc di
    jmp scan_re2    
    
scan_re2:
    jmp scan_start2
    
scan_exit2:
    
    mov ax, 0ch
    sub ax, si  ; 12 - si 값
    mov di, 0ch
    
num_shift_start2:
    mov cx, si
    inc cx
    mov si, ax
    mov ax, 0ch
    sub ax, si
    mov si, ax
num_shift2:
    mov al, scan_number2+si
    or  al, 30h
    mov number2+di, al
    dec di
    dec si
    loop num_shift2
    
    mov cx, 9
    mov di, 0
dot_shift2:
    mov al, scan_dot_num2+di
    or  al, 30h
    mov dot_num2+di, al
    inc di
    loop dot_shift2  
        
        
        POP     CX
        POP     DI
        POP     SI
        POP     AX
        POP     DX
        RET
SCAN_NUM2        ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OPR_SUM     PROC    NEAR
            PUSH    DX
            PUSH    AX
            PUSH    SI
            PUSH    DI
            
    mov si, 0
    mov cx, 20
            
    cmp number1_minusflag, 1
    je  sum_num1_minus
    cmp number2_minusflag, 1
    je  sum_num2_minus
    jmp opr_sum_start
    
sum_num1_minus:

    cmp number2_minusflag, 1
    je  sum_num12_minus
 swap_start:
 
    mov dl, number1+si
    mov dh, dl
    mov dl, number2+si
    mov number1+si, dl
    mov dl, dh
    mov number2+si, dl
    inc si
    loop swap_start
    
    mov sum_to_minus, 1
    jmp sum_exit
    
sum_num2_minus:
    
    mov sum_to_minus, 1
    jmp sum_exit

sum_num12_minus:
    mov print_minus_flag, 1

opr_sum_start:
      
    mov si, 19
    mov cx, 20
    mov ax, 0  

opr_sum_again:

    mov al, number1+si
    add al, ah             ; 전 carry 더하기
    mov dl, number2+si
    mov ah, 0              ; 캐리 발생하지 않았을 경우 캐리 초기화
    add al, dl
    aaa                    ; ah = carry, al = 몫
    
    mov result+si, al
    or  result+si, 30h
    dec si
    loop opr_sum_again

sum_exit:        
        
        POP     DI
        POP     SI
        POP     AX
        POP     DX
        RET
OPR_SUM        ENDP    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OPR_MINUS   PROC    NEAR
            PUSH    DX
            PUSH    AX
            PUSH    SI
            PUSH    DI
            
            mov si, 0
            mov cx, 20
            
minus_search:
            
            mov dl, number1+si
            mov dh, number2+si
            cmp dl, 30h
            jne mi
            cmp dh, 30h
            jne mi
            jmp minus_zero
           mi:
            sub dl, dh
            aas
            jc opr_minus_start2
            mov dl, number1+si
            mov dh, number2+si
            cmp dl, dh
            jz  minus_zero
            jmp opr_minus_start1
minus_zero:
            inc si
            loop minus_search                         
opr_minus_start1:
            mov si, 19
            mov cx, 20
            sub dx, dx
opr_minus_loop1:

    mov al, number1+si
    mov dl, number2+si
    add dl, dh
    mov dh, 0
    sub al, dl
    aas
    jnc minus_nocarry1
    mov dh, 1
    
minus_nocarry1:
    mov result+si, al
    or  result+si, 30h
    dec si
    loop opr_minus_loop1
    jmp minus_exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
opr_minus_start2:
            inc print_minus_flag
            mov si, 19
            mov cx, 20
            sub dx, dx
opr_minus_loop2:

    mov al, number2+si
    mov dl, number1+si
    add dl, dh
    mov dh, 0            ; 캐리 초기화               
    sub al, dl
    aas
    jnc minus_nocarry2
    mov dh, 1
    
minus_nocarry2:
    mov result+si, al
    or  result+si, 30h
    dec si
    loop opr_minus_loop2                    

minus_exit:
        
        POP     DI
        POP     SI
        POP     AX
        POP     DX
        RET
OPR_MINUS       ENDP 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OPR_MUL     PROC    NEAR
            PUSH    DX
            PUSH    AX
            PUSH    SI
            PUSH    DI
            PUSH    CX
            PUSH    BX
            
    mov si, 15
    mov di, 15
    mov dx, 0
    mov ax, 0
    mov bx, 0
    mov cx, 0
    
    mov al, number1_minusflag
    mov ah, number2_minusflag
    xor al, ah
    cmp al, 1
    je  mul_minusflag
    
    mov print_minus_flag, 0
    jmp opr_mul_start
 mul_minusflag:
    mov print_minus_flag, 1

opr_mul_start:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 opr_mul_again:

    mov al, number1+si
    and al, 0fh
    mov bl, number2+di
    and bl, 0fh
    mul bl
    aam                ;ah = carry, al = 몫
                       ;dh = before ah(전 캐리)
    
    or  dh, 30h
    or  al, 30h
    add al, dh     
    aaa                ;al + dh 전 캐리 = al에 십진수로 담김 
    
    mov dh, ah         ;현재 캐리 dh로 이동                      
    mov mul_base+si, al
    dec si
    cmp si, 0
    jne opr_mul_again
;;;;;;;;;;;;;;;;;;;;;;;;
    push di
    
    add di, 4
    mov cx, di
    mov si, 15    
 opr_mul_sum:

    mov al, result+di
    add al, ah             ; 전 carry 더하기
    mov dl, mul_base+si
    mov ah, 0              ; 캐리 발생하지 않았을 경우 캐리 초기화
    add al, dl
    aaa                    ; ah = carry, al = 몫
    
    mov result+di, al
    cmp si, 0
    je  mul_si_zero
    dec si
 mul_si_zero:   
    dec di
    loop opr_mul_sum
;;;;;;;;;;;;;;;;;;;;;;;;
    pop di
        
    dec di
    mov si, 19
    cmp di, 0
    jne opr_mul_again
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
opr_mul_exit:
        
        POP     BX
        POP     CX
        POP     DI
        POP     SI
        POP     AX
        POP     DX
        RET
OPR_MUL         ENDP    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OPR_DIV:     
    
            PUSH    DX
            PUSH    AX
            PUSH    SI
            PUSH    DI
            PUSH    BX
            
            mov ax, 0
            mov bx, 0
            mov cx, 0
            mov dx, 0
            
    mov al, number1_minusflag
    mov ah, number2_minusflag
    xor al, ah
    cmp al, 1
    je  div_minusflag

    mov print_minus_flag, 0
    jmp div_start
 div_minusflag:
    mov print_minus_flag, 1            
div_start:
    
    mov cx, 20
    mov si, 0
 div_search_num1:
    mov al, number1+si
    cmp al, 30h
    je  num1_zero_si  
    mov cx, 1
 num1_zero_si:
    inc si   
    loop div_search_num1
    
    mov cx, 20
    mov di, 0
 div_search_num2:
    mov al, number2+di
    cmp al, 30h
    je  num2_zero_si  
    mov cx, 1
 num2_zero_si:
    inc di   
    loop div_search_num2
    
    cmp di, si
    jz  zz
    cmp di, si
    jc  div_shift_nega_st
    
    sub di, si  
    mov bx, di
    
 div_shift:
    
    mov si, 1
    mov cx, 19
 div_shift_loop:
    mov al, number2+si
    dec si
    mov number2+si, al
    inc si
    inc si
    
    loop div_shift_loop
    
    mov number2+si, 30h
    
    dec bl
    cmp bl, 0
    jne div_shift
    jmp zz
    
div_shift_nega_st:

    sub si, di
    mov bx, si
    
 div_shift_nega:
    
    mov si, 18
    mov cx, 19
 div_shift_loop_nega:
    mov al, number2+si
    inc si
    mov number2+si, al
    dec si
    dec si
    
    loop div_shift_loop_nega
    
    mov number2+si, 30h
    
    dec bl
    cmp bl, 0
    jne div_shift_nega
    
 zz:
    mov si, 0
    mov cx, 20
div_minus_search:
    
    mov dl, number1+si
    mov dh, number2+si
    cmp dl, 30h
    jne ffff
    cmp dh, 30h
    jne ffff
    jmp fffff
 ffff:
    sub dl, dh
    aas
    jc  div_minus_to_shift
    mov dl, number1+si
    mov dh, number2+si
    cmp dl, dh
    jz  fffff
    jmp div_minus_start 
 fffff:
    inc si
    loop    div_minus_search
    
    sub si, si
    mov cx, 20
    
 div_exit_loop:
    mov al, number1+si
    cmp al, 30h
    jne div_minus_start
    inc si
    loop div_exit_loop
    
    jmp div_exit

div_minus_start:
    
    mov si, 19
    mov cx, 20
    sub dx, dx
    
 div_minus_loop:
    
    mov al, number1+si
    mov dl, number2+si
    add dl, dh
    mov dh, 0
    sub al, dl
    aas
    jnc div_minus_nocarry
    mov dh, 1
 div_minus_nocarry:
    
    cmp al, 0
    or  al, 30h
    mov number1+si, al
    dec si
    loop    div_minus_loop
    
    inc bl
    
    mov si, 19
    mov cx, 20
 div_result_loop:
    mov al, number2+si
    cmp al, 30h
    jne div_result_loop_end
    dec si
    loop    div_result_loop
    
 div_result_loop_end:
    
    mov result+si, bl
    jmp zz

div_minus_to_shift:
    
    mov si, 18
    mov cx, 19

div_minus_to_shift_loop:
    
    mov al, number2+si
    inc si
    mov number2+si, al
    dec si
    dec si
    
    loop div_minus_to_shift_loop
    
    mov number2, 30h
    mov bl, 0
    
    mov cx, 20
    mov si, 0
 div_share_search:
 
    mov al, number2+si
    cmp al, 30h
    jne zz
    inc si
    loop    div_share_search
 
div_exit:
                
        POP     BX
        POP     DI
        POP     SI
        POP     AX
        POP     DX

jmp ret_div    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRINT_RESULT    PROC    NEAR
                PUSH    AX
                PUSH    SI
                PUSH    CX
        
        mov si, 0
        mov cx, 20
        
        cmp print_minus_flag, 0
        je  print_start
        PUTC '-'    

print_start:
        mov al, result+si
        or  al, 30h
        mov printf, al
        
        cmp si, 12
        jne print_dot
        PUTC '.'

print_dot:
              
        PUTC printf
        
        inc si
        
        loop print_start          
        
        POP     CX
        POP     SI
        POP     AX
        RET
PRINT_RESULT       ENDP                   