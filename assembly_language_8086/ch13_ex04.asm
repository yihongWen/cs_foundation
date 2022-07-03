; 用7ch中断例程完成jmp near ptr s指令的功能
data segment
         db 'conversation',0
data ends

codes segment
                      assume cs:codes
    start:            

                      mov    ax,0
                      mov    es,ax
                      mov    di,0200h

                      mov    ax,cs
                      mov    ds,ax
                      mov    si,offset interrupt_jmp
                      mov    cx,offset interrupt_jmp_end-offset interrupt_jmp
                      cld
                      rep    movsb

    ; 设置中断向量
                      mov    ax,0
                      mov    es,ax
                      mov    word ptr es:[7ch*4],0200h
                      mov    word ptr es:[7ch*4+2],0



                      mov    ax, data
                      mov    ds, ax
                      mov    si,0
                      mov    ax,0b800h
                      mov    es,ax
                      mov    di,12*160

    s:                
                      cmp    byte ptr ds:[si],0
                      je     ok
                      mov    al,ds:[si]
                      mov    es:[di],al
                      mov    byte ptr es:[di+1],2
                      inc    si
                      add    di,2
                      mov    bx,offset s-offset ok
                      int    7ch
    ok:               
                      mov    ax,4c00h
                      int    21h
    
                      mov    ah, 4ch
                      int    21h

    interrupt_jmp:    
                      push   bp
                      mov    bp,sp
                      add    ss:[bp+2],bx
                      pop    bp
                      iret
    interrupt_jmp_end:
                      nop
codes ends
end start