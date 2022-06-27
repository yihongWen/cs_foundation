; 计算data段中的一组数据的3次方，结果存放在侯敏啊的一组dword单元中
; 使用子程序：call ret

data segment
         dw 1,2,3,4,5,6,7,8
         dd 8 dup(0)
data ends

stacks segment
           dw 8 dup(0)
stacks ends

codes segment
          assume cs:codes, ds:data, ss:stacks
    start:
          mov    ax, data
          mov    ds, ax
          mov    si,0
          mov    di,16
          mov    cx,8
    s:    
          mov    bx,ds:[si]
          call   cube
          mov    ds:[di],ax
          mov    ds:[di+2],dx

          add    si,2
          add    di,4
          loop   s
          mov    ah, 4ch
          int    21h

    ; 计算一个值的三次方：
    ; 请求参数：bx
    ; 返回参数：dx,ax
    cube: 
          mov    ax,bx
          mul    bx
          mul    bx
          ret
    
         
codes ends
end start