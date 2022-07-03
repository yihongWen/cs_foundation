; 在指定的位置，用指定的颜色，显示一个用0结束的字符串
data segment
         db 'Welcome to masm!',0
data ends



codes segment
                 assume cs:codes, ds:data
    start:       
                 mov    dh,8
                 mov    dl,3
                 mov    cl,2
                 mov    ax, data
                 mov    ds, ax
                 mov    si,0
                 call   show_str
    
                 mov    ah, 4ch
                 int    21h

    ;子程序：在指定的位置，用指定的颜色，显示一个用0结束的字符串
    ;参数：1、行号dh  2、列号dl  3、颜色 cl  4、字符起始地址ds:[si]
    show_str:    
                 push   ax
                 push   es
                 push   bx
                 push   dx
                 push   si

    ; 设置缓冲段地址
                 mov    ax,0b800h
                 mov    es,ax

    ; 根据行号以及列号计算第一个字符所在地址:计算结果存在在bx中
                 mov    ax,0
                 mov    al,dh
                 dec    al
                 mov    bl,160
                 mul    bl
                 mov    bx,ax
                 mov    ax,0
                 ; 这里需要加上2*dl(每个字符显示占用两个字节)
                 mov    al,dl
                 add    al,dl
                 add    bx,ax

    s:           
                 push   cx
                 mov    cl,ds:[si]
                 mov    ch,0
                 jcxz   show_str_end
                 mov    ax,cx
                 pop    cx
                 mov    ah,cl
                 mov    es:[bx],ax
                 inc    si
                 add    bx,2
                 jmp    short s
    show_str_end:
                 pop    cx
                 pop    si
                 pop    dx
                 pop    bx
                 pop    es
                 pop    ax
                 ret

codes ends
end start