; 实验14 访问cmos ram: 以年/月/日 时:分:秒的格式显示当前的日期，时间
; 1、确定时间数据所在的位置，读取数据、写入到指定地方
; 2、展示数据（写显存、数据转化）
assume cs:code
 
data segment
    ; 年月日时分秒,字符串格式
         db 9,8,7,4,2,0
         db '00/00/00 00:00:00'
data ends
 
stack segment
          dw 8 dup (0)
stack ends
 
code segment
    start: 
           mov  ax,data
           mov  ds,ax
  
           mov  ax,stack
           mov  ss,ax
           mov  sp,16
 
    ; 初始化端口跟展示字符串的起始地址以及循环次数
           mov  bx,6
           mov  si,0
           mov  cx,6
    s:     
           call handle
           inc  si
           add  bx,3
           loop s

    ;显示数据
           mov  ax,0b800h
           mov  es,ax
           mov  si,1920
           mov  bx,6
           mov  cx,17

    show:  
           mov  al,ds:[bx]
           mov  es:[si],al
           mov  byte ptr es:[si+1],2
           add  si,2
           inc  bx
           loop show
           mov ax,4c00h
           int 21h

 
 
    ; 读取指定位置数据，写入到指定位置
    ; ds:[si]-->(bcd码转化)--->ds:[bx]
    handle:
           mov  al,ds:[si]
           out  70h,al
           in   al,71h
           push cx
 
    ; ah为低位、al为高位
           mov  cl,4
           mov  ah,al
           shr  al,cl
           and  ah,00001111b
           add  ah,30h
           add  al,30h
 
           mov  [bx],ax
           pop  cx
           ret
code ends
 
end start
