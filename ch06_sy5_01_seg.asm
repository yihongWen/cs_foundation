; 分析下面的程序：cs\ss\ds的地址
; ans: 加载程序后段地址相对位置ds\psp\cs\ss（程序的指向）、不够补齐16

codes segment
          assume cs:codes, ds:data, ss:stacks
    start:
          mov    ax, stacks
          mov    ss, ax
          mov    sp,16
          mov    ax,data
          mov    ds,ax

          push   ds:[0]
          push   ds:[2]
          pop    ds:[2]
          pop    ds:[0]
    
          mov    ah, 4ch
          int    21h
codes ends

data segment
         dw 0123h,0456h
data ends

stacks segment
           dw 0,0
stacks ends
end start