; 执行jmp指令后，cs:ip指向程序的第一条指令，在data段中应该定义那些数据
; jmp word ptr ds:[bx+1],此条件转移指令，只会修改IP，
; 执行codes中的第一条指令,ip为0,所以ds:[bx+1]中的内容为0即可
data segment
         db 3 dup (0)
data ends

codes segment
          assume cs:codes, ds:data
    start:
          mov    ax, data
          mov    ds, ax
          mov    bx,0
          jmp    word ptr ds:[bx+1]
          mov    ah, 4ch
          int    21h
codes ends
end start