;在程序代码中定义一组数据，从新指定cs/ip的位置，也就是越过定义的数据项
assume cs:code
code segment
          dw  0001h,0002h,0003h,0004h,0005h,0006h,0007h,0008h
    start:
          mov ax,0
          mov bx,0
          mov ax,4c00h
          int 21h
code ends

end start