; 第五章：练习3，安全的地址空间，不能随意使用（修改）内存中的数据
; 因为不知道这段地址空间有谁在用，可能会导致其他程序崩溃
; 地址空间：0:200~0:2ff属于相对安全的地址空间
assume cs:code
code segment
    mov ax,0
    mov ds,ax
    ; 往该地址中写数据，导致os无法工作
    mov ds:[26h],ax
    mov ax,4c00h
    int 21h
code ends
end