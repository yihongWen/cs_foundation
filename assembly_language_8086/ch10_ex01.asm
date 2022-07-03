; 使用retf，实现从1000：0000处开始执行命令
; reft： pop ip  pop cx

stacks segment
           db 16 dup(0)
stacks ends

codes segment
          assume cs:codes, ss:stacks
    start:
          mov    ax, stacks
          mov    ss, ax
          mov    sp,16
          mov    ax,1000h
          push   ax
          mov    ax,0000h
          push   ax
          retf
          mov    ah, 4ch
          int    21h
codes ends
end start