;问题3.2:写几条指令，将al中的数据送入内存单元10000H中
assume cs:code
code segment
         mov bx,1000h
         mov ds,bx
         mov ds:[0],al
         mov ax,4c00h
         int 21h
code ends
end
