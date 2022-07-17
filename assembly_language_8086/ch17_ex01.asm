; 编程，接收用户的键盘输入，r\g\b 将屏幕上的颜色设置为rgb
codes segment
          assume cs:codes

    start:

          mov    ah,0
    ; 调用16号中断，从输入缓存中读取数据
          int    16h
    ; ah为1此时代表绿色
          mov    ah,1
          cmp    al,'r'
          je     red
          cmp    al,'g'
          je     green
          cmp    al,'b'
          je     blue
          ; 输入e直接退出程序
          cmp    al,'e'
          je     sret
 
    red:  
          shl    ah,1
    green:
          shl    ah,1
 
    blue: 
          mov    bx,0b800h
          mov    es,bx
          mov    bx,1
          mov    cx,2000
    s:    
          and    byte ptr es:[bx],11111000b
          or     es:[bx],ah
          add    bx,2
          loop   s
          ; 循环
          jmp    start

 
    sret: 
          mov    ax,4c00h
          int    21h
    
codes ends
end start