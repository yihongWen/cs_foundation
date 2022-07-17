; 编写一个接收字符串的输入子程序，实现 1、在输入的同时需要显示这个字符串
; 2、一般在输入回车后，字符串输入结束。3、能够删除已经输入的字符

;子程序：字符串的入栈、出栈、显示
;参数说明：（ah）=功能号，0表示入栈，1表示出栈，2表示显示
;           ds:si指向字符栈空间
;           对于0号功能：（al）=入栈字符
;           对于1号功能：（al）=出栈字符
;           对于2号功能：（dh）、（dl）表示屏幕上的行和列
assume cs:code
code segment
    start:        
  
                  mov  ax, cs
                  mov  ds, ax
                  mov  si, 0
                  mov  dh, 12
                  mov  dl, 40
    clear_screen: 
                  push bx
                  push es
                  push cx
                  mov  bx,0b800h
                  mov  es,bx
                  mov  bx,0
                  mov  cx,2000
    clear_screens:
                  mov  byte ptr es:[bx],' '
                  add  bx,2
                  loop clear_screens
                  pop  cx
                  pop  es
                  pop  bx
                  call getstr
                  mov  ax,4c00h
                  int  21h


    ;*******************************************************
    ;接收字符串输入子程序
    getstr:       
                  push ax
   
    getstr_s:     
                  mov  ah, 0
                  int  16h
                  cmp  al, 20h                        ;al中存放的是扫描码对应的ASCII码
                  jb   nochar                         ;ASCII码小于20h, 说明不是字符
   
    ;字符入栈
                  mov  ah, 0                          ;ah: 0号功能 字符入栈、al：为入栈数据
                  call charstack
    ;显示栈中的字符
                  mov  ah, 2
                  call charstack
                  jmp  short getstr_s
     
    nochar:       
                  cmp  ah, 0eh                        ;退格键的扫描码
                  je   backspace
                  cmp  ah, 1ch                        ;Enter键的扫描码
                  je   enter
                  jmp  short getstr_s
   

    backspace:    
                  mov  ah, 1
                  call charstack                      ;字符出栈
                  mov  ah, 2
                  call charstack                      ;显示栈中的字符
                  jmp  short getstr_s
 
    enter:        
                  mov  al, 0
                  mov  ah, 0                          ;入栈0
                  call charstack
                  mov  ah, 2
                  call charstack                      ;显示栈中的字符
   
                  pop  ax
                  ret
    ;**************************************************
    ;子程序
    charstack:    
                  jmp  short charstart
    table         dw   charpush, charpop, charshow
    top           dw   0                              ;保存栈顶  注意：始终指向栈顶有效字符的上一个

    charstart:    
                  push bx
                  push dx
                  push di
                  push si
                  push es
   
                  cmp  ah, 2
                  ja   sret                           ;ja高于则转移
                  mov  bl, ah
                  mov  bh, 0
                  add  bx, bx                         ;功能号*2 = 对应的功能子程序在地址表中的偏移
                  jmp  word ptr table[bx]
   

    ;字符入栈
    charpush:     
                  mov  bx, top                        ;取得栈顶
                  mov  [si][bx], al
                  inc  top                            ;栈顶+1
                  jmp  short sret
    ;字符出栈
    charpop:      
                  cmp  top, 0                         ;检查栈是否为空
                  je   sret
                  dec  top                            ;栈顶-1  此时指向栈顶的有效字符
                  mov  bx, top
                  mov  al, [si][bx]                   ;把取出的字符保存在al中
                  jmp  short sret

    ;字符显示
    charshow:     
                  mov  bx, 0b800h
                  mov  es, bx
                  mov  al, 160
                  mov  ah, 0
                  mul  dh                             ;ax=al*dh=160*行数
                  mov  di, ax
                  add  dl, dl                         ;dl+dl = 偏移量
                  mov  dh, 0
                  add  di, dx                         ;di=(160*行数)+2*列数
   
                  mov  bx, 0
    charshows:    
                  cmp  bx, top                        ;bx为 存放数据空间的偏移
                  jne  noempty                        ;栈不为空 显示
                  mov  byte ptr es:[di], ' '
                  jmp  short sret
   
    noempty:      
                  mov  al, [si][bx]
                  mov  es:[di], al
                  mov  byte ptr es:[di+2], ' '        ;如果是删除 就可以把删除的字符清空
                  inc  bx
                  add  di, 2
                  jmp  short charshows


    sret:         
                  pop  es
                  pop  si
                  pop  di
                  pop  dx
                  pop  bx
                  ret
code ends
end start
