; 下面的程序将code段只能够的a处的8个数据累加
; 将结果存储到b处的双字节中
; 描述单元

codes segment
    assume cs:codes
    a dw 1,2,3,4,5,6,7,8
    b dd 0
start:
    mov si,0
    mov cx,8

    s:
    mov ax,a[si]
    add word ptr b[0],ax
    adc word ptr b[2],0
    add si,2
    loop s

    
    mov ah, 4ch
    int 21h
codes ends
end start