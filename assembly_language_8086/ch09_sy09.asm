; 编程：在屏幕中间分别显示绿色、绿底红色、白底蓝色的字符串'welcome to masm!'
; 首先需要计算出屏幕（第一页）中间所在的内存地址是多少、然后将展示的颜色多对应的值是多少
; 最后定义一个二重循环的结构将数据写入即可

data segment
    ; 定义字符数据以及颜色数据
         db 'welcome to masm!'
    ; 绿色、绿底红色、白底蓝色
         db 00000010b,00100100b,01110001b
data ends

stacks segment
           db 16 dup(0)
stacks ends

codes segment
             assume cs:codes, ds:data, ss:stacks
    start:   

    ; 设置数据段、栈段、以及显示缓存地址的段地址
             mov    ax, data
             mov    ds, ax
             mov    ax, stacks
             mov    ss,ax
             mov    sp,10h
             mov    ax,0b800h
             mov    es,ax

    ; 定义外层循环，处理每行的数据
    ; di表示中间三行每行的首地址
             mov    di,06e0h
             mov    cx,3
             mov    si,0

    out_loop:
    ; 定义内存循环，处理每一行的具体数据
             mov    bx,0
             mov    bp,0
             push   cx
             mov    cx,16

    in_lopp: 
             mov    dl,ds:[bx]
             mov    dh,ds:[si+16]
             mov    es:[bp+di+64],dx
             inc    bx
             add    bp,2
             loop   in_lopp
             
             pop    cx
             inc    si
             add    di,160
             loop   out_loop
             mov    ah, 4ch
             int    21h
codes ends
end start