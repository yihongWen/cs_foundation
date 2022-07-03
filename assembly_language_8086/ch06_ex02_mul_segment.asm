;定义多个段：代码段、数据段、栈段
;利用栈段，将数据段中的数据逆序存放
data segment
         dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
data ends

stacks segment
           dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
stacks ends

codes segment
              assume cs:codes, ds:data, ss:stacks
    start:    
    ; 初始化数据段地址
              mov    ax, data
              mov    ds, ax

    ; 初始化栈段地址
              mov    ax, stacks
              mov    ss, ax
              mov    sp, 20h

    ;循环将数据段的数据push到栈段
              mov    bx,0
              mov    cx,8
    push_loop:
              push   ds:[bx]
              add    bx,2
              loop   push_loop

    ; 将栈中的数据pop到数据段中
              mov    bx,0
              mov    cx,8
    pop_loop: 
              pop    ds:[bx]
              add    bx,2
              loop   pop_loop

              mov    ah, 4ch
              int    21h
codes ends
end start