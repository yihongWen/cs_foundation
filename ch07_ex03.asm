; 使用si跟di将字符串复制到后面的数据区中
data segment
         db 'welcome to masm!'
         db '                '
data ends


codes segment
          assume cs:codes, ds:data
    start:
          mov    ax, data
          mov    ds, ax
          mov    si,0
          mov    di,16
          mov    cx,8
    s:    
          mov    dx,ds:[si]
          mov    ds:[di],dx
          add    si,2
          add    di,2
          loop   s
          mov    ah, 4ch
          int    21h
codes ends
end start