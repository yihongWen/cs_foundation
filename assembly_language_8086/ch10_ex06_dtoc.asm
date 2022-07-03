data segment
         dw 8 dup(0)
data ends

stacks segment
           dw 8 dup(0)
           dw 8 dup(0)
           dw 8 dup(0)
stacks ends

codes segment
                               assume cs:codes, ds:data, ss:stacks
    start:                     
                               mov    ax, data
                               mov    ds, ax
                               mov    ax,stacks
                               mov    ss,ax
                               mov    sp,48
                               mov    ax,02f5ah
                               mov    dx,001dh
                               mov    si,0
                               call   dtoc

                               mov    dh,8
                               mov    dl,3
                               mov    cl,2
                               call   show_str


    
                               mov    ah, 4ch
                               int    21h


    ;子程序dtoc：将dword数字转化成字符串
    ; 请求参数：dx、ax表示需要处理的数字高位和低位
    ; 返回参数：将计算的结果存放在ds:si中以0为结束
    dtoc:                      
    ; 为了避免除法溢出，使用子程序divdw进行处理
                               push   ax
                               push   dx
                               push   cx
                               push   si

    ; 标记值
                               mov    cx,0
                               push   cx
    dtoc_handle_every:         
                               mov    cx,10
                               call   divdw
    ; 将结果保存在栈中：数字展示是高位在前，所以使用栈结构
                               add    cx,30h
                               push   cx
    ;判断是否结束: 商是否为0，需要判断ax,bx分别是否为0
                               mov    cx,ax
                               jcxz   dtoc_dx_is_zero
                               jmp    dtoc_handle_every


    dtoc_dx_is_zero:           
                               mov    cx,dx
    ; 此时如果dx也为0，此时结束处理
                               jcxz   dtoc_dx_is_zero_handle_end
                               jmp    dtoc_handle_every

    dtoc_dx_is_zero_handle_end:
    ; 处理完每一位数，将stack中的数据写入到data段中
    write_loop:                
                               pop    cx
                               mov    ds:[si],cl
                               jcxz   dtoc_end
                               inc    si
                               loop   write_loop

    dtoc_end:                  
                               pop    si
                               pop    cx
                               pop    dx
                               pop    ax
                               ret

    ; 子程序divdw：不会溢出的除法
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
    
    
    ;子程序show_str：在指定的位置，用指定的颜色，显示一个用0结束的字符串
    ;参数：1、行号dh  2、列号dl  3、颜色 cl  4、字符起始地址ds:[si]
    show_str:                  
                               push   ax
                               push   es
                               push   bx
                               push   dx
                               push   si

    ; 设置缓冲段地址
                               mov    ax,0b800h
                               mov    es,ax

    ; 根据行号以及列号计算第一个字符所在地址:计算结果存在在bx中
                               mov    ax,0
                               mov    al,dh
                               dec    al
                               mov    bl,160
                               mul    bl
                               mov    bx,ax
                               mov    ax,0
    ; 这里需要加上2*dl(每个字符显示占用两个字节)
                               mov    al,dl
                               add    al,dl
                               add    bx,ax

    s:                         
                               push   cx
                               mov    cl,ds:[si]
                               mov    ch,0
                               jcxz   show_str_end
                               mov    ax,cx
                               pop    cx
                               mov    ah,cl
                               mov    es:[bx],ax
                               inc    si
                               add    bx,2
                               jmp    short s
    show_str_end:              
                               pop    cx
                               pop    si
                               pop    dx
                               pop    bx
                               pop    es
                               pop    ax
                               ret
codes ends
end start