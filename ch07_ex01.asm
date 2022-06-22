; 将第一个字符串转换为大写，第二个字符串转换为小写
data segment
         db 'BaSic'
         db 'iNfOrMaTiOn'
data ends

codes segment
          assume cs:codes, ds:data
    start:
          mov    ax, data
          mov    ds, ax
          mov    cx,5
          mov    bx,0
    s:    
          mov    dl,ds:[bx]
          and    dl,0dfh
          mov    ds:[bx],dl
          inc    bx
          loop   s
    
          mov    cx,0bh
    s1:   
          mov    dl,ds:[bx]
          or     dl,20h
          mov    ds:[bx],dl
          inc    bx
          loop   s1


          mov    ah, 4ch
          int    21h
codes ends
end start