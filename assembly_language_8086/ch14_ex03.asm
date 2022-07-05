; 编程，在屏幕显示当前的月份
; 指定端口、位移读取数据（读取的数据是bcd编码）

codes segment
          assume cs:codes
    start:

          mov    al,8
          out    70h,al
          in     al,71h

    ; 使用ah计算高位
          mov    ah,al
          mov    cl,4
          shr    ah,cl
    
    ; 计算低位
          and    al,00001111b

    ; 将ah\al转化成对应的ascii码中的十进制数:+48
          add    al,48
          add    ah,48

    ;往显存里面写数据
          mov    bx,0b800h
          mov    es,bx
          mov    byte ptr es:[160*12],ah
          mov    byte ptr es:[160*12+1],2
          mov    byte ptr es:[160*12+2],al
          mov    byte ptr es:[160*12+3],2


          mov    ah, 4ch
          int    21h
codes ends
end start