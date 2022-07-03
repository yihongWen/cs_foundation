;第五章：练习二
;loop、[bx]的使用：计算ffff:0~ffff:b单元中的数据和，将结果保存到dx中
assume cs:code
code segment
    mov ax,0ffffh
    mov ds,ax
    mov bx,0
    mov cx,12
    s:
        mov al,ds:[bx]
        mov ah,0
        add dx,ax
        inc bx
        loop s
    mov ax,4c00h
    int 21h
code ends
end