assume cs:code

code segment

start:      
            mov ax,cs
            mov ds,ax
            mov si,offset int7c                       ;设置 ds:si 指向源地址
            mov ax,0
            mov es,ax
            mov di,0200h                              ;设置 es:di 指向目的地址

            mov cx,offset int7cend-offset int7c       ;设置 cx 为传输长度
            
            cld                                       ;设置传输方向为正
            rep movsb                                 ;串传送操作

            mov ax,0
            mov es,ax

            cli
            mov word ptr es:[7ch*4],200h
            mov word ptr es:[7ch*4+2],0               ;设置中断向量表
            sti

            ; 安装完中断后，进行测试代码
            mov ax,0101h
            int 7ch
            call delay

            mov ax,0207h
            int 7ch
            call delay

            mov ah,03
            int 7ch
            call delay

            mov ah,0
            int 7ch
            call delay


            mov ax,4c00h
            int 21h

    delay:
          push   ax
          push   dx
   
          mov    dx,0005h
    s1:   
          dec    dx
          cmp    dx,0
          je     s_end
          mov    ax,0ffffh
    s2:   
          dec    ax
          cmp    ax,0
          jne    s2
          jmp    s1
    s_end:
          pop    dx
          pop    ax
          ret

int7c:      jmp short set

            dw offset sub1 - offset int7c + 200h
            dw offset sub2 - offset int7c + 200h
            dw offset sub3 - offset int7c + 200h
            dw offset sub4 - offset int7c + 200h
            ;int7c 在0:200处，通过上式的计算，可以得到子程序sub(i)入口的地址
            ;这里不能直接用 sub(i) 的标号找到 sub(i) 的入口地址
            ;因为上面的程序会将位于 cs:offset int7c 的新中断处理程序复制到 0:200 处

  set:      push bx

            cmp ah,3
            ja sret
            mov bl,ah
            mov bh,0
            add bx,bx

            call word ptr cs:[bx+202h]                ;2 是 jmp short set 占的空间
                                                      ;这里不能用之前的 table[bx]
                                                      ;请深刻理解
                                                      ;牢牢记住程序的本质
 sret:      pop bx
            iret

;子程序 1：清屏
sub1:       push bx
            push cx
            push es
            mov bx,0b800h
            mov es,bx
            mov bx,0
            mov cx,2000
sub1s:      mov byte ptr es:[bx],' '
            add bx,2
            loop sub1s
            pop es
            pop cx
            pop bx
            ret

;子程序 2：设置前景色
sub2:       push bx
            push cx
            push es
            mov bx,0b800h
            mov es,bx
            mov bx,1
            mov cx,2000
sub2s:      and byte ptr es:[bx],11111000b
            or es:[bx],al
            add bx,2
            loop sub2s
            pop es
            pop cx
            pop bx
            ret

;子程序 3：设置背景色
sub3:       push bx
            push cx
            push es
            mov cl,4
            shl al,cl
            mov bx,0b800h
            mov es,bx
            mov bx,1
            mov cx,2000
sub3s:      and byte ptr es:[bx],10001111b
            or es:[bx],al
            add bx,2
            loop sub3s
            pop es
            pop cx
            pop bx
            ret

;子程序 4：向上滚动一行
sub4:       push cx
            push si
            push di
            push es
            push ds
            mov si,0b800h
            mov es,si
            mov ds,si
            mov si,160
            mov di,0
            cld
            mov cx,24
sub4s:      push cx
            mov cx,160
            rep movsb
            pop cx
            loop sub4s
            mov cx,80
            mov si,0
sub4s1:     mov byte ptr [160*24+si],' '
            add si,2
            loop sub4s1
            pop ds
            pop es
            pop di
            pop si
            pop cx
            ret

int7cend:   nop

code ends

end start