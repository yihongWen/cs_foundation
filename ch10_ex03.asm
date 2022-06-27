; question: 将data段中的字符串全部转化为大写
; ans: 
;       1、将每行以0结尾的字符串转换使用子程序的形式
;       2、调用子程序时，将相关寄存器入栈、子程序返回时出栈

data segment
         db 'word',0
         db 'unix',0
         db 'wind',0
         db 'good',0
data ends

stacks segment
           dw 8 dup(0)
stacks ends

codes segment
                        assume cs:codes, ds:data, ss:stacks
    start:              
                        mov    ax, data
                        mov    ds, ax
                        mov    cx,4
                        mov    si,0
    s:                  
                        call   function_trans
                        add    si,5
                        loop   s
                        mov    ah, 4ch
                        int    21h
        
    function_trans:     
                        push   si
                        push   cx
    function_trans_loop:
                        mov    cl,ds:[si]
                        mov    ch,0
                        jcxz   function_trans_end
                        and    byte ptr ds:[si],11011111b
                        inc    si
                        jmp    short function_trans_loop

    function_trans_end: 
                        pop    cx
                        pop    si
                        ret


codes ends
end start