; 分析一个奇怪的程序：程序是否能正常退出
; 1、程序能退出主要是ax 4c00,int 21h，指令执行对应的中断程序,只要程序最后能够执行到，即可退出


codes segment
          assume cs:codes
          mov    ax,4c00h
          int    21h
    start:
    s:    
          ; 当s0处跳转到s处时，由于copy的数据过来，此时指令的指令为jmp short s1
          ; 又因jmp short指令跳转给出的本质上是偏移地址，所以此时会去执行上面的退出指令
          nop
          nop
          ; 下面四个指令，将s2处的jmp指令的内容copy到s处两个nop占位符中
          mov    di,offset s
          mov    si,offset s2
          mov    ax,cs:[si]
          mov    cs:[di],ax

    s0:   
          ; 跳转到s处指令
          jmp    short s

    s1:   
          mov    ax,0
          int    21h
          mov    ax,0
    
    s2:   
          jmp    short s1
          nop
codes ends
end start