;实验2
assume cs:code
code segment
         mov ax,0ffffh
         mov ds,ax
        ; 单步执行，ss\sp指令是一起执行的
        ;
         mov ax,2200h
         mov ss,ax
         mov sp,0100h

         mov ax,ds:[0]
         add ax,ds:[2]
         mov bx,ds:[4]
         add bx,ds:[6]

         push ax
         push bx
         pop ax
         pop bx

         push ds:[4]
         push ds:[6]
         
         mov ax,4c00h
         int 21h
code ends
end
