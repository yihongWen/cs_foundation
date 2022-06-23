;将第一个字符串转换为大写，第二个字符串转换为小写(两个字符串的长度相同)
;可以使用bx+idata的方式
data segment
         db 'Basic'
         db 'Minix'
data ends

codes segment
          assume cs:codes, ds:data
    start:
          mov    ax, data
          mov    ds, ax
          mov    bx,0
          mov    cx,5
          mov    dh,0
    s:    
          mov    dl,ds:[bx]
          and    dl,0dfh
          mov    ds:[bx],dl

          mov    dl,ds:[bx+5]
          or     dl,20h
          mov    ds:[bx+5],dl
          inc    bx
          loop   s

    
          mov    ah, 4ch
          int    21h
codes ends
end start
