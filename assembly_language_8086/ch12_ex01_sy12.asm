codes segment
                      assume cs:codes
    start:            
                      mov    ax,0
                      mov    es,ax
                      mov    ax,cs
                      mov    ds,ax
                      mov    di,0200h
                      mov    si,offset interrupt_0
                      mov    cx,offset interrupt_0_end-offset interrupt_0
                      cld
                      rep    movsb

    ;设置中断向量表
                      mov    ax,0
                      mov    es,ax
                      mov    word ptr es:[0*4],200h
                      mov    word ptr es:[0*4+2],0

    ; 测试
                      mov    ax,1000h
                      mov    bl,1
                      div    bl
                      mov    ax, 4c00h
                      int    21h
    interrupt_0:      
                    ; jmp short 跟jmp 指令长度不一样
                      jmp short  interrupt_0_start
                      db     "zhiyujiang_devide_error!"
    interrupt_0_start:

                      mov    ax,cs
                      mov    ds,ax

                      mov    si,0202h

                      mov    ax,0b800h
                      mov    es,ax
                      mov    di,12*160+23*2
                      mov    cx,24
    s:                
                      mov    al,ds:[si]
                      mov    es:[di],al
                      mov    byte ptr es:[di+1],2
                      inc    si
                      add    di,2
                      loop   s
                      mov    ah, 4ch
                      int    21h

    interrupt_0_end:  nop
codes ends
end start