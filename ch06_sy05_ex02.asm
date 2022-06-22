;将a\b段的结果相加依次放在c段中
;由于存在3个段，一般只用ds,es段寄存器，此时需要在重复利用一个段寄存器
;进行中转，所以可以利用栈来保存数据

assume cs:code
a segment
        db 1,2,3,4,5,6,7,8
a ends

b segment
        db 1,2,3,4,5,6,7,8
b ends

c segment
        db 0,0,0,0,0,0,0,0
c ends

code segment
      start:
            mov  ax,a
            mov  ds,ax
            mov  ax,b
            mov  es,ax
            mov  bx,0
            mov  cx,8
      s:    
            mov  dx,0
            add  dl,ds:[bx]
            add  dl,es:[bx]
            push ds
            mov  ax,c
            mov  ds,ax
            mov  ds:[bx],dx
            inc  bx
            pop  ds
            loop s
            mov  ax,4c00h
            int  21h

code ends
end start