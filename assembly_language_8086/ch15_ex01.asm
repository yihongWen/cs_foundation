; 在屏幕中间显示a-z
data segment
         dw 16 dup(0)
data ends

stacks segment
           dw 8 dup(0)
stacks ends

codes segment
          assume cs:codes, ds:data, ss:stacks
    start:
          mov    ax, data
          mov    ds, ax
          mov    ax,stacks
          mov    ss,ax
          mov    sp,16
          mov    ax,0b800h
          mov    es,ax
          mov    ah,'a'

    s:    
          mov    es:[12*160+40*2],ah
          mov    byte ptr es:[12*160+40*2+1],2
    ; 延时
          call   delay
          inc    ah
          cmp    ah,'z'
          jna    s
    
          mov    ah, 4ch
          int    21h

    delay:
          push   ax
          push   dx
   
          mov    dx,0005h
    s1:   
          dec    dx
          cmp    dx,0
          je     s_end
          mov    ax,0ffffh
    s2:   
          dec    ax
          cmp    ax,0
          jne    s2
          jmp    s1
    s_end:
          pop    dx
          pop    ax
          ret
    
codes ends
end start