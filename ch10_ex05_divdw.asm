; 不会产生溢出的除法运算，被除数为dword,除数为word型，结果为dword型
; 分析：产生溢出的原因，设计不会溢出（两次除法）
data segment
         dw 8 dup(0)
data ends

stacks segment
           dw 8 dup(0)
stacks ends

codes segment
          assume cs:codes, ds:data, ss:stacks
    start:
          mov    ax, data
          mov    ds, ax
          mov    ax,stacks
          mov    ss,ax
          mov    sp,16
          mov    ax,4240h
          mov    dx,000fh
          mov    cx,0ah
          call   divdw
          mov    ah, 4ch
          int    21h


    ; 不会溢出的除法
    ; 请求参数：ax\dx为被除数的低位和高位，cx为除数
    ; 返回参数：dx\ax为商的高位和低位，cx为余数
    divdw:
    ;先进行高位的除法计算
          push   bx
          push   ax
          mov    ax,dx
          mov    dx,0
    ; 高位计算结果：ax为商,将ax保存，dx余数
          div    cx
          mov    bx,ax

    ; 进行低位运算，高位除法运算后的余数作为低位运算中的高位
          pop    ax
          div    cx
          mov    cx,dx
          mov    dx,bx
          pop    bx
          ret
codes ends
end start