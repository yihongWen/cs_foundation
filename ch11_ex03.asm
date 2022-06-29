data segment
         db 8,11,8,1,8,5,63,8
data ends

codes segment
              assume cs:codes, ds:data
    start:    
              mov    ax, data
              mov    ds, ax
              mov    bx,0
              mov    cx,8
              mov    ax,0

    s:        
              cmp    byte ptr ds:[bx],8
              je     add_count
              inc    bx
              loop   s
              mov    ah, 4ch
              int    21h
    
    add_count:
              inc    ax
              inc    bx
              
              loop   s
              mov    ah, 4ch
              int    21h
    
    
  
codes ends
end start