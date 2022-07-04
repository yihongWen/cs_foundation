; 使用位移指令（shl、shr)计算 ax*10
codes segment
          assume cs:codes
    start:
    ; 假设ax,5
          mov    ax,5

          mov    bx,ax
          shl    ax,1

          mov    cl,3
          shl    bx,cl

          add    ax,bx
    
          mov    ah, 4ch
          int    21h
codes ends
end start