;----------------------第四章：实验3---------------------------
;---------主要了解：汇编程序结构，psp的内容，装载程序后cx寄存器的值---
;---------- cd20指令的含义：退出
assume cs:code
code segment
         mov  ax,2000h
         mov  ss,ax
         mov  sp,0
         add  sp,0
         pop  ax
         pop  bx
         push ax
         push bx
         pop  ax
         pop  bx
         mov  ax,4c00h
         int  21h
code ends
end