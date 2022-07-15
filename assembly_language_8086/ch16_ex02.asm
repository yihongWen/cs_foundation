;16.2 在其他段中使用数据标号
;将dat段中a处的8个数据累加，结果存储到b处的字节中
data segment
    a    db 1,2,3,4,5,6,7,8
    b    dw 0
data ends

codes segment
          assume cs:codes, ds:data
    start:
          mov    ax, data
          mov    ds, ax
          mov    si,0
          mov    cx,8
    s:    
          mov    al,a[si]
          mov    ah,0
          add    b,ax
          inc    si
          loop   s
    
          mov    ah, 4ch
          int    21h
codes ends
end start