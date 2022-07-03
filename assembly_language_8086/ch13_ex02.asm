; 编写安装7ch中断例程
; 功能：将一个全是字母，以0结尾的字符串，转化为大写
; 参数：ds:si指向字符串的首地址
data segment
         db 'zhiyujiang',0
data ends

codes segment
                              assume cs:codes, ds:data
    start:                    
    ;将7ch的指令copy到0:200处
                              mov    ax,cs
                              mov    ds,ax
                              mov    si,offset capital_convert

                              mov    ax,0
                              mov    es,ax
                              mov    di,0200h
    
                              mov    cx,offset capital_convert_end-offset capital_convert
                              cld
                              rep    movsb

    ; 设置中断向量表
                              mov    ax,0
                              mov    es,ax
                              mov    word ptr es:[7ch*4],0200h
                              mov    word ptr es:[7ch*4+2],0

    ; 测试，调用7ch中断
                              mov    ax, data
                              mov    ds, ax
                              mov    si,0
                              int    7ch
                              mov    ah, 4ch
                              int    21h

    ; 中断程序
    capital_convert:          
                              push   si
                              push   ax
                              push   cx
    capital_convert_start:    
                              mov    cl,ds:[si]
                              mov    ch,0
                              jcxz   capital_convert_loop_tail
                              mov    ax,cx
                              and    al,11011111b
                              mov    ds:[si],al
                              inc    si
                              jmp    capital_convert_start

    capital_convert_loop_tail:
                              pop    cx
                              pop    ax
                              pop    si
                              iret
    capital_convert_end:      
                              nop
    
codes ends
end start