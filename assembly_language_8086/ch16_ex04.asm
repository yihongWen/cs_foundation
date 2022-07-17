; 编写一个子程序，计算sin(x)，x属于{0，30，60，90，120，150，180}，并在屏幕中间显示计算结果
; table单位为dw,c
codes segment
            assume cs:codes
    start:  
            mov    al,120
            call   showsin
            mov    ah, 4ch
            int    21h

    ; ax向子程序传递角度
    showsin:
            jmp    short show

    table   dw     ag0,ag30,ag60,ag90,ag120,ag150,ag180
    error   db     'angle not right',0
    ag0     db     '0',0                                   ; sin(0)对应的结果"0"
    ag30    db     '0.5',0
    ag60    db     '0.866',0
    ag90    db     '1',0
    ag120   db     '0.866',0
    ag150   db     '0.5',0
    ag180   db     '0',0
    
    show:   
            push   bx
            push   es
            push   si

    ; 判断输入的角度是否合法 al>=0 && al<=180 && al%30 == 0
            cmp    ax,0
            jb     sherror
            cmp    ax,180
            ja     sherror
			
            push   ax
            push   bx
            mov    bl,30
            div    bl
            cmp    ah,0
            pop    bx
            pop    ax
            jne    sherror
    		
            mov    bx,0b800h
            mov    es,bx
    		
    ; 用角度值/30作为对于table的偏移，取得对应字符串的偏移地址，放在bx中
            mov    ah,0
            mov    bl,30
            div    bl
            mov    bl,al                                   ; bl保存除得的结果
            mov    bh,0
            add    bx,bx                                   ; 因为ag0等占两个字节(值为标号ago的偏移地址)
    ; 因此bx要*2才是ag0等相对于table偏移地址
            mov    bx,table[bx]
    		
    ; 显示sin(x)对应的字符串
            mov    si,160*12+40*2
    shows:  mov    ah,cs:[bx]
            cmp    ah,0                                    ; 每个值的字符串长度不一样，因此在末尾加0
            je     showret                                 ; 方便读取
            mov    es:[si],ah
            mov byte ptr es:[si+1],2eh
            inc    bx
            add    si,2
            jmp    short shows
    		
    showret:pop    si
            pop    es
            pop    bx
            ret
            
    sherror:
            push   si
            push   di
            push   bx
	
            mov    bx,0b800h
            mov    es,bx
				
            mov    si,0                                    ;
            mov    di,160 * 12 + 40 * 2
	
            mov    bh,2eh
    erlp:   
            cmp    error[si],0
            je     erok
					
            mov    bl, error[si]
            mov    es:[di],bx
            inc    si
            add    di,2
            jmp    erlp
    erok:   
            pop    bx
            pop    di
            pop    si
            ret
codes ends
end start