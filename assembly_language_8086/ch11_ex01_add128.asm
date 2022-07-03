data segment
    dw 8 dup(0101h)
    dw 8 dup(0202h)
data ends

stacks segment
    dw 8 dup(0)
stacks ends

codes segment
    assume cs:codes, ds:data, ss:stacks
start:
    mov ax, data
    mov ds, ax
    mov ax,stacks
    mov sp,16

    mov si,0
    mov di,16

    call add128

    mov ax, 4c00h
    int 21h

    ;子程序add128:将两个128位的数据进行相加
    ;参数：ds:si  ds:di
    ;结果：ds:si
    ;1、CF标志进位 （先清空）2、循环计算 3、abc带进位标志的加法计算
add128:
    push ax
    push cx
    push si
    push di
    mov cx,8
    sub ax,ax

loop_adc:
    mov ax,ds:[si]
    adc ax,ds:[di]
    mov ds:[si],ax
    ; inc不会对cf造成影响、add会对cf进行影响
    inc si
    inc si
    inc di
    inc di
    loop loop_adc

    pop di
    pop si
    pop cx
    pop ax
    ret

codes ends
end start