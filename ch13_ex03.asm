; 对int iret的理解，使用中断实现loop指令
; 在屏幕中间显示80个！
codes segment
                        assume             cs:codes
    start:              

    ;将中断程序copy到0:200处
                        mov                ax,0
                        mov                es,ax
                        mov                di,0200h

                        mov                ax,cs
                        mov                ds,ax
                        mov                si,offset interrupt_loop
                        mov                cx,offset interrupt_loop_end-offset interrupt_loop
                        cld
                        rep                movsb

    ; 设置中断向量
                        mov                ax,0
                        mov                es,ax
                        mov                word ptr es:[7ch*4],0200h
                        mov                word ptr es:[7ch*4+2],0


    ; 测试
                        mov                ax,0b800h
                        mov                es,ax
                        mov                di,160*12

    ; 设置循环标号的偏移地址,执行7ch后ip指向s_end
                        mov                bx,offset s-offset s_end
                        mov                cx,80
    s:                  
                        mov                byte ptr es:[di],"!"
                        mov                byte ptr es:[di+1],2
                        add                di,2
                        int                7ch
    s_end:              
                        nop
                        mov                ah, 4ch
                        int                21h

    interrupt_loop:     
                        push               bp
                        mov                bp,sp
                        dec                cx
                        jcxz               interrupt_loop_exit
                        add                ss:[bp+2],bx
    interrupt_loop_exit:
                        pop                bp
                        iret
    interrupt_loop_end:
                        nop

codes ends
end start