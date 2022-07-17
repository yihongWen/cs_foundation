;2021年10月12日 10:20:41

;难点:如何实现在任意情况下都能响应键盘中断
;解决方案:
;1、采用重新安装int 9中断的方法，因为任意外设的输入都要调用int 9中断，
;通过int 9可随时获取键盘输入
;弊端：该中断会影响所有的外设输入，而不仅仅是时钟程序
;2、采用int 16h的0号和1号功能配合，清空键盘缓冲区，通过1号功能查询，
;非有效输入再通过0号功能读取,用于预防键盘缓冲区为空时，调用0号功能
;导致程序阻塞
;清空缓冲区功能面临的主要问题:在键盘缓冲区为空时调用0号功能会导致程序阻塞
;1号功能简述:当缓冲区为空时，ZF标志位为1;当缓冲区非空时，ZF标志位为0

assume cs:code

code segment
;================主程序================
start:

    DOS:nop         
;开启表示dos调试/注释表示虚拟机调试
    IFDEF DOS
    call boot
    ELSE
    call lead_to_disk
    call boot_to_disk
    ENDIF

    mov ax,4c00h
    int 21h
;=====================================

;================引导程序==============
lead:
    mov ax,0    ;尝试将栈顶设置为0:210出错
    mov ss,ax   
    mov sp,7c00h 

    call boot_to_memory

    mov ax,0    ;cs
    push ax
    mov ax,7e00h;ip
    push ax

retf            ;通过retf设置cs:ip
;-------------------------------------
;读到0：7e00h
boot_to_memory:
    mov ax,0    ;es:bx表示内存地址,2将磁盘数据读入内存/3将内存数据写入磁盘
    mov es,ax   ;将0道0面1扇区数据读入内存0:7e00h
    mov bx,7e00h

    mov ah,2    ;2读/3写
    mov al,2    ;扇区数
    mov ch,0    ;磁道号
    mov cl,2    ;扇区号
    mov dh,0    ;面号
    mov dl,0    ;0软驱A/80h硬盘C

    int 13h

ret
;-------------------------------------
lead_to_disk:
    mov ax,cs   ;es:bx表示内存地址,2将磁盘数据读入内存/3将内存数据写入磁盘
    mov es,ax   ;将内存代码段中的lead程序写入0道0面1扇区
    mov bx,offset lead

    mov ah,3    ;2读/3写
    mov al,1    ;扇区数
    mov ch,0    ;磁道号
    mov cl,1    ;扇区号
    mov dh,0    ;面号
    mov dl,0    ;0软驱A/80h硬盘C

    int 13h

ret
;-------------------------------------
boot_to_disk:
    mov ax,cs   ;es:bx表示内存地址,2将磁盘数据读入内存/3将内存数据写入磁盘
    mov es,ax   ;将内存代码段中的boot程序写入0道0面2扇区
    mov bx,offset boot

    mov ah,3    ;2读/3写
    mov al,2    ;扇区数
    mov ch,0    ;磁道号
    mov cl,2    ;扇区号
    mov dh,0    ;面号
    mov dl,0    ;0软驱A/80h硬盘C

    int 13h

ret
;=====================================
IFNDEF DOS
    org 7e00h
ENDIF
;================boot程序==============
boot:
    jmp boot_start
    MENU_1:    	db 'Please Enter Your Choose(1~4):',0    
    MENU_2:     db '1) reset pc',0
    MENU_3:     db '2) start system',0
    MENU_4:     db '3) clock',0
    MENU_5:     db '4) set clock',0
    MENU_6:     db 'SC From Mr.Kang & Learn By Mr.Liang 0.0',0

    MENU_ADD:   dw offset MENU_1
    	        dw offset MENU_2
                dw offset MENU_3
                dw offset MENU_4
                dw offset MENU_5
                dw offset MENU_6

    CMOS_RAM:   	db 9,8,7,4,2,0
    TIME_FORMAT:	db 'yy/mm/dd hh:mm:ss',0    ;于11行30列绘制时间,13行15列绘制提示
    TIME_STRING:	db 12 dup('*'),0
    TIME_SHOW_TIPS:	db 'Enter F1 to change the color,and enter Esc to exit',0
    TIME_SET_TIPS:	db 'Enter [0~9] to set the time,and enter Esc to exit',0

boot_start:
    mov ax,0    	;参考书本中retf指令的使用,需要设置栈顶指针
    mov ss,ax   
    mov sp,7c00h 

    call show_menu
    call choose_option

    mov ax,4c00h
    int 21h
;-------------------------------------
show_menu:
    push bx
    push di     ;显示位置
    push si     ;字符地址

    call clear_screen

    mov bx,0b800h
    mov es,bx
    mov di,9*160+23*2
    mov bx,offset MENU_ADD

    mov cx,6    ;显示6行
    loop_to_draw_menu:
        mov si,cs:[bx]
        call draw_string_end_in_0
        add di,160      ;控制下一行
        add bx,2        ;下一行字符串的地址
        loop loop_to_draw_menu

    pop si
    pop di
    pop bx

ret

;绘制以0为结尾的字符串
draw_string_end_in_0:
    push di     ;显示位置
    push si     ;字符地址

    draw_char:
        mov al,cs:[si]
        cmp al,0
        je draw_char_over
        mov es:[di],al
        add di,2
        inc si
        jmp draw_char

draw_char_over:
    pop si
    pop di

ret
;-----------------------------------
choose_option:  				;参考书本16章
    call clear_keyboard_buffer  ;清除键盘缓冲区，然后再通过阻塞方式等待用户输入 

    mov ah,0    				;读取键盘缓冲区，不用担心缓冲区为空时阻塞
    int 16h     				;因为阻塞等待用户输入也符合程序的设计

    cmp al,'1'
    je choose_one
    cmp al,'2'
    je choose_two
    cmp al,'3'
    je choose_three
    cmp al,'4'
    je choose_four   

    jmp choose_option           ;继续等待用户输入

    choose_one:
        call ResetPC
        jmp short choose_ret    ;实际未跑到，因为系统已重启

    choose_two:
        call StartSystem
        jmp short choose_ret    ;实际未跑到，因为已正常进入xp系统

    choose_three:
        call Clock
        jmp short choose_ret    ;实际未跑到，Esc会重新返回主菜单

    choose_four:
        call SetClock
        jmp short choose_ret    ;实际未跑到，Esc会重新返回主菜单

    choose_ret:
ret
;-----------------------------------
ResetPC:
    mov ax,0ffffh
    push ax
    mov ax,0
    push ax

retf 
;-----------------------------------
StartSystem:
    mov ax,0
    mov es,ax
    mov bx,7c00h

    mov ah,2    ;2读/3写
    mov al,1    ;扇区数
    mov ch,0    ;磁道号
    mov cl,1    ;扇区号
    mov dh,0    ;面号
    mov dl,80h  ;0软驱A/80h硬盘C

    int 13h

    mov ax,0
    push ax
    mov ax,7c00h
    push ax

retf
;-----------------------------------
Clock:
    push di    ;显示位置
    push si    ;字符地址

    mov ax,0b800h
    mov es,ax

    call clear_screen               ;首先清屏并绘制提示信息
    mov di,13*160+15*2              
    mov si,offset TIME_SHOW_TIPS
    call draw_string_end_in_0       

    mov di,11*160+30*2              ;给draw_line_end_with_0传参
    mov si,offset TIME_FORMAT

    loop_to_draw_time:
        call key_interrupt          ;其次判断是否有esc和f1键盘中断
        call update_time_data       ;没有中断则更新时间数据
        call draw_string_end_in_0   ;绘制时间数据字符串
        jmp loop_to_draw_time

    pop si
    pop di

ret

;处理F1与Esc键盘中断
key_interrupt:
    mov ah,1                    	;通过1号功能查询
    int 16h

    jz key_interrupt_ret        	;缓冲区为空则退出，防止调用0号导致阻塞

    mov ah,0                    	;跑到这里表示缓冲区不为空，可以调用0号功能
    int 16h                     	;用扫描码判断，ASCII码无法区分Esc和F1非单字符

    cmp ah,3Bh                  	;3Bh为F1按下时的扫描码
    je change_foreground        	;函数内有ret返回

    cmp ah,01h                  	;01h为Esc按下时的扫描码
    je esc_function

    call clear_keyboard_buffer  	;非F1和Esc输入,清除键盘缓冲区

    key_interrupt_ret:
ret

;更新代码段TIME_FORMAT时间格式字符串
update_time_data:
    push cx
    push bx
    push di

    mov bx,offset CMOS_RAM
    mov di,offset TIME_FORMAT
    mov cx,6

    loop_to_read_cmos:
        push cx                 	;位移指令更改了cl的值,要记得保存cx
        mov al,cs:[bx]          	;读cmos中年月日的数据
        out 70h,al
        in al,71h

        mov ah,al
        mov cl,4
        shr ah,cl               	;取年月日的[十]位数
        and al,00001111b        	;取年月日的[个]位数

        add ah,30h
        add al,30h

        mov byte ptr cs:[di],ah 	;更新代码段TIME_FORMAT时间格式字符串
        inc di                  	;更新下个字符           
        mov byte ptr cs:[di],al

        add di,2                	;跳过年月日间隔符'/'和时分秒间隔符':',以及年月日与时分秒之间的空格间隔符
        inc bx                  	;CMOS_RAM为db定义,所以inc即可
        pop cx
        loop loop_to_read_cmos

    pop di
    pop bx
    pop cx

ret

;清除键盘缓冲区
clear_keyboard_buffer:
    mov ah,1                    
    int 16h

    jz clear_keyboard_buffer_over

    mov ah,0
    int 16h
    jmp clear_keyboard_buffer   	;通过1号查询，缓冲区非空，再通过0号取出

    clear_keyboard_buffer_over:
ret     

;改变前景色
change_foreground:              	;参考书本16章
    push bx
    push cx
    push es

    mov bx,0b800h
    mov es,bx
    mov bx,1
    mov cx,2000

    change_fore_color:
        inc byte ptr es:[bx]    	;该语句参考书本,已优化,功能为随机改变颜色
        add bx,2
        loop change_fore_color

    pop es
    pop cx
    pop bx
ret

;esc按键退出主菜单处理
esc_function:
    mov bx,offset top
    mov byte ptr cs:[bx],0      	;设置top为0

    call clear_time_string
    call clear_keyboard_buffer
    jmp boot_start              	;这里跳转会导致之前压栈的数据没有弹栈处理，但boot_start中又重新初始化栈
                                	;再次压栈则会替换掉旧栈中的数据
;-----------------------------------
SetClock:
    push di
    push si

    mov ax,0b800h
    mov es,ax

    call clear_screen           ;清屏并绘制*号提示

    mov di,13*160+15*2			;绘制提示
    mov si,offset TIME_SET_TIPS
    call draw_string_end_in_0

    mov di,11*160+30*2
    mov si,offset TIME_STRING
    call draw_string_end_in_0

    call clear_keyboard_buffer
    call getstr

    pop si
    pop di
ret

getstr:
    push ax

getstrs:
    mov ah,0                        ;清空键盘缓冲区并阻塞等待用户输入
    int 16h

    cmp al,'0'
    jb nonumber
    cmp al,'9'
    ja nonumber
    mov ah,0
    call charstack
    mov ah,2
    call charstack
    jmp getstrs

    nonumber:
        cmp ah,0eh                  ;退格键扫描码
        je backspace
        cmp ah,1ch                  ;Enter键扫描码
        je input_end
        cmp ah,01h                  ;Esc键扫描码
        je esc_function

        jmp getstrs

    backspace:
        mov ah,1
        call charstack
        mov ah,2
        call charstack
        jmp getstrs

    input_end:
        call set_cmos_ram
        jmp esc_function

    pop ax
ret

;将代码段TIME_STRING中的ASCII码转换为BCD码值的数据
;比如字符'12'实际为31h和32h，还原为BCD码00010010，见书本14章
set_cmos_ram:
    mov bx,offset CMOS_RAM
    mov si,offset TIME_STRING
    mov di,0

    mov cx,6  	
    loop_to_write_cmos:  
        push cx

        mov dx,cs:[si]

        cmp dl,'0'
        jb	not_number     ;有效性判断
        cmp dl,'9'  
        ja  not_number	
        cmp dh,'0'
        jb 	not_number
        cmp dh,'9'
        ja  not_number  

        sub dx,3030H
        mov cl,4
        shl dl,cl
        and dh,00001111B
        or dl,dh

        mov al,cs:[bx]
        out 70H,al      	;将al送入地址端口70h

        mov al,dl
        out 71H,al      	;将数据写入CMOSRAM时钟

        inc bx
        add si,2

        pop cx
    	loop loop_to_write_cmos

    not_number:
    	jcxz set_cmos_ram_ret
    	pop cx				;如果因为字符原因退出循环，则压栈的cx没有pop处理，直接ret会异常
	set_cmos_ram_ret:
ret

;清除代码段TIME_STRING中的字符串缓存
clear_time_string:
    push bx
    push cx

    mov bx,offset TIME_STRING
    mov cx,12

    init_time_string:
        mov byte ptr cs:[bx],'*'
        inc bx
        loop init_time_string

    pop cx
    pop bx
ret
;-----------------------------------
charstack:
    jmp short charstart
    top dw 0                			;参考书本17章设置栈顶

charstart:
    push bx
    push dx
    push di
    push es

    cmp ah,0
    je charpush
    cmp ah,1
    je charpop
    cmp ah,2
    je charshow
    jmp charstack_ret

    mov si,offset TIME_STRING

    charpush:
        cmp top,11						;只记录12个字符
        ja charstack_ret

        mov bx,top
        mov cs:[si][bx],al
        inc top
        jmp charstack_ret

    charpop:
        cmp top,0
        je charstack_ret
        dec top
        mov bx,top
        mov al,cs:[si][bx]
        jmp charstack_ret

    charshow:
        mov bx,0b800h
        mov es,bx
        mov di,11*160+30*2   

        mov bx,0
        charshows:
            cmp bx,top
            jne noempty

            cmp top,11                  ;第12个字符输入后直接退出
            ja charstack_ret      

            mov byte ptr es:[di],'*'    ;字符串为空时用*代替空格显示
            jmp charstack_ret

        noempty:
            mov al,cs:[si][bx]
            mov es:[di],al
            ;mov byte ptr es:[di+2],'*'  ;输入的有效字符的下个字符用*显示，比如1*
            inc bx
            add di,2
            jmp charshows

    charstack_ret:
    pop es
    pop di
    pop dx
    pop bx
ret
;-----------------------------------
clear_screen:
    push bx
    push cx
    push es

    ;全屏清屏
    mov bx,0b800h
    mov es,bx
    mov cx,2000
    mov bx,0

    clear:
        mov byte ptr es:[bx],' '
        mov byte ptr es:[bx+1],07h  ;黑底白字
        add bx,2
        loop clear

    pop es
    pop cx
    pop bx

ret
;----------------------------------- 

;-----------------------------------
boot_end:
    nop
;=====================================
code ends
end start