; 编写、安装中断7ch的中断例程
; 功能：求word型数据的平方，参数存在ax中，dx,ax中存放结果的高16位和低16位
; demo: 2*(3456*3456)

codes segment
            assume cs:codes
    start:  

    ; 将程序copy
            mov    ax,cs
            mov    ds,ax
            mov    si,offset sqr

            mov    ax,0
            mov    es,ax
            mov    di,0200h
            mov    cx,offset sqr_end-offset sqr
            cld
            rep    movsb

    ; 将中断例程安装到中断向量中
            mov    ax,0
            mov    es,ax
            mov    word ptr es:[7ch*4],0200h
            mov    word ptr es:[7ch*4+2],0

    ; 测试例子
            mov    ax,3456
            int    7ch
            add    ax,ax
            adc    dx,dx
            
            mov    ah, 4ch
            int    21h

    sqr:    
            mul    ax
            iret
    sqr_end:
            nop
codes ends
end start