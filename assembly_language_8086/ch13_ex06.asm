; 在屏幕中的5行12列显示字符串 'welcome to masm!'
; 使用21号中断（dos）9号子程序，（先使用10号子程序进行设置光标）
data segment
         db 'Welcome to masm!','$'
data ends

codes segment
          assume cs:codes
    start:

          mov    ah,2
          mov    bh,0
          mov    dh,5
          mov    dl,12
          int    10h

          mov    ax,data
          mov    ds,ax
          mov    dx,0
          mov    ah,9
          int    21h

          mov    ah, 4ch
          int    21h
codes ends
end start