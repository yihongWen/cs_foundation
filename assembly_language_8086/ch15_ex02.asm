;屏幕中间循环显示 a~z , 按 Esc 变换颜色
;主要思路：
;1、读取键盘的输入 in 60h,esc键的通码
;2、自定义9号中断，然后在自定义的中断中调用原来的9号中断
assume cs:code, ds:data, ss:stack
stack segment stack
        db 128 dup (0)
stack ends
data segment
        dw 0,0
data ends
code segment
start:  
        ; 设置栈段、data段
        mov ax,stack
        mov ss,ax
        mov sp,128
        mov ax,data
        mov ds,ax

        ; 通过栈将9号中断程序的cs\ip保存在 ds数据中
        mov ax,0
        mov es,ax
        push es:[9*4]
        pop ds:[0]
        push es:[9*4+2]
        pop ds:[2]

        ; 将自定义的9号中断cs\ip保存在中断向量表中的9号位置中
        ; 为了防止执行这两个指令中间发生中断，进入之前设置为不响应可屏蔽中断
        cli
        mov word ptr es:[9*4],offset int9
        mov es:[9*4+2],cs
        sti

        ; 循环显示'a'~'z'
        mov ax,0b800h
        mov es,ax
        mov ah,'a'
   s:   mov  es:[160*12+40*2],ah
        call delay
        inc ah
        cmp ah,'z'
        jna s
        mov ax,0
        mov es,ax

        ; 恢复原来的地址
        push ds:[0]
        pop es:[9*4]
        push ds:[2]
        pop es:[9*4+2]

        mov ax,4c00h
        int 21h

; 延迟
delay:  push ax
        push dx
        mov dx,10h
        mov ax,0
   s1:  sub ax,1
        sbb dx,0
        cmp ax,0
        jne s1
        cmp dx,0
        jne s1
        pop dx
        pop ax
        ret

; 自定义定义中断例程
int9:   
        push ax
        push bx
        push es

        ; 读取键盘的输入
        in al,60h
        pushf
        call dword ptr ds:[0]

        ; 判断是否是esc的通码
        cmp al,1
        ; 中断返回继续执行、或者改变颜色后返回继续执行
        jne int9ret
        mov ax,0b800h
        mov es,ax
        inc byte ptr es:[160*12+40*2+1]

int9ret:pop es
        pop bx
        pop ax
        iret

code ends
end start