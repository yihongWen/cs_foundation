; 利用loop指令，实验在内存2000h段中查找第一个值为0的字节，找到后将打偏移地址存储在dx中
; 细节点：题目要求的是字节，最后dx中的结果是偏移地址
codes segment
          assume cs:codes
    start:
          mov    ax, 2000h
          mov    ds, ax
          mov    bx,0
    s:    
          mov    ch,0
          mov    cl,ds:[bx]
          inc    bx
          inc    cx
          loop   s
    
    ok:   
          dec    bx
          mov    dx,bx
          mov    ah, 4ch
          int    21h
codes ends
end start