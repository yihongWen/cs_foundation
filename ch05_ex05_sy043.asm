;将mov ax,4c00h之前的指令复制到内存0:200处
assume cs:code
code segment
         mov  ax,cs
         mov  ds,ax
         mov  ax,0020h
         mov  es,ax
         mov  bx,0
    ; 根据程序的指令可以得出大小为17h个byte,可以使用mov cx,17h
    ; 程序启动时会将程序大小放置在cx中，直接减去返回指令的大小就可
         sub  cx,5
    s:   
         mov  al,ds:[bx]
         mov  es:[bx],al
         inc  bx
         loop s
         mov  ax,4c00h
         int  21h

code ends
end