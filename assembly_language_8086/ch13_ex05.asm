; 在屏幕的5行12列显示3个绿色的a
; bios中的10号中断（2号子程序、设置光标、9号子程序设置字符）

codes segment
          assume cs:codes
    start:
    ; 置光标页
          mov    ah,2
          mov    bh,0
          mov    dh,5
          mov    dl,12
          int    10h

    ;显示字符
          mov    ah,9
          mov    al,'a'
          mov    bl,2
          mov    bh,0
          mov    cx,3
          int    10h

          mov    ah, 4ch
          int    21h
codes ends
end start