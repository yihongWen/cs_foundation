; 将data段字符串中前4个字母改写成大些字母
; 可以 ds:[bx+di+idata]的寻址方式
data segment
         db '1. display      '
         db '2. brows        '
         db '3. replace      '
         db '4. modify       '
data ends

stacks segment
           dw 0,0,0,0,0,0,0,0
stacks ends

codes segment
          assume cs:codes, ds:data, ss:stacks
    start:
          mov    ax, data
          mov    ds, ax
          mov    dh,0
          mov    bx,0
          mov    cx,4

    s0:   
          push   cx
          mov    di,0
          mov    cx,4
    s1:   
          mov    dl,ds:[bx+di+3]
          and    dl,0dfh
          mov    ds:[bx+di+3],dl
          inc    di
          loop   s1
          pop    cx
          add    bx,16
          loop   s0
          mov    ah, 4ch
          int    21h
codes ends
end start