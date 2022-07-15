; 编写子程序，以十六进制的形式在屏幕中间显示给定的字节型数据。
; 通过映射的方式实现
codes segment
    assume cs:codes
start:
    ;在屏幕中间显示7F
    mov al,7fh
    call showbyte
    mov ah, 4ch
    int 21h

showbyte:
        jmp short show
        table db '0123456789ABCDEF'     ;字符表

show:   
        push bx
        push es

        mov ah,al
        shr ah,1
        shr ah,1
        shr ah,1
        shr ah,1        ;右移4位,ah中得到高4位的值
        and al,00001111b        ;al中为低4位的值

        mov bl,ah
        mov bh,0
        mov ah,table[bx]        ;用高4位的值作为相对于table的偏移，取得对应的字符

        mov bx,0b800h
        mov es,bx
        mov es:[160*12+40*2],ah
        mov byte ptr es:[160*12+40*2+1],2


        mov bl,al
        mov bh,0
        mov al,table[bx]        ;用低4位的值作为相对于table的偏移，取得对应的字符

        mov es:[160*12+40*2+2],al
        mov byte ptr es:[160*12+40*2+3],2


        pop es
        pop bx
        ret
codes ends
end start