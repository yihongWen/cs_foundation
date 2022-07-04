; 1、向cmos ram中的2号单元写入数据以及读取数据
; 端口：70h\71h  in out

codes segment
          assume cs:codes
    start:
    ; 写入数据
          mov    al,2
          out    70h,al
          mov    al,6
          out    71h,al

    ; 读取数据
          mov    cx,3
    s:    
          mov    al,2
          out    70h,al
          in     al,71h
          loop   s

          mov    ah, 4ch
          int    21h
codes ends
end start
