; 实验12: 编写0号中断的处理程序，使得除法溢出发生时，在屏幕中间显示字符串“zhiyujiang_devide_error!”
; 实现分析：除法溢出会产生0号中断，需要将中断向量表中0号中断的CS\IP指向中断处理程序的所在的地址
; 将中断处理程序指令装载到一个安全的地址空间


codes segment
                      assume cs:codes
    start:            
    ; 将中断处理程序指令copy到0: 0200h处
    ; 使用串转移指令 rep movsb: 需要设置cx,也就是指令的大小，以及串移动的方向
    ; 设置es:di(0:0200h)  ds:si(cs:中断处理程序起始地址)
                      mov    ax,0
                      mov    es,ax
                      mov    ax,cs
                      mov    dx,ax
                      mov    di,0200h
                      mov    si offset interrupt_0
                      mov    cx,offset interrupt_0_end-offset interrupt_0
                      cld
                      rep    movsb
                      mov    ax, 4c00h
                      int    21h



    interrupt_0:      
    ;定义需要展示的字符,但是数据并非指令，需要跳过
                      jmp    interrupt_0_start
                      db     "zhiyujiang_devide_erro"
    interrupt_0_start:
                      mov    ax,cs
                      mov    dx,ax
    ; 指令copy到0000:0200h处,jmp占用两个字节，所以展示的数据地址为202
                      mov    si,0202h
    ; 设置显存地址,展示在中间
                      mov    ax,0b800h
                      mov    es,ax
                      mov    di 12*160+23*2
                      mov    cx,24
    s:                
                      mov    al,ds:[si]
                      mov    es:[di],al
                      mov    es:[di],2
                      inc    si
                      add    di,2
                      loop   s
                      mov    ah, 4ch
                      int    21h
    ; 为了计算中断处理程序的大小，设置最后一个字节
    interrupt_0_end:  nop
                      mov    ah, 4ch
                      int    21h
codes ends
end start