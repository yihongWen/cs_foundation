; 编程，用串传送指令，将f000h段中的最后16个字符复制到data段中
; 逆序方向

data segment
         db 16 dup(0)
data ends


codes segment
          assume cs:codes, ds:data
    start:
          mov    ax, data
          mov    es, ax
          mov    di,15

          mov    ax,0f000h
          mov    ds,ax
          mov    si,0ffffh
          mov    cx,16
    ; 设置串方向为逆序
          std

          rep    movsb
    ; 恢复ds:指向data段
          mov    ax,data
          mov    ds,ax
          mov    ah, 4ch
          int    21h
codes ends
end start