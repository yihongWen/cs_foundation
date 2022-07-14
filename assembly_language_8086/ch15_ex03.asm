; 安装9中断程序，当按下F1键时，改变屏幕颜色
assume cs:code
stack segment
          db 128 dup(0)
stack ends

code segment
    start:  mov   ax,stack
            mov   ss,ax
            mov   sp,128
			
            push  cs
            pop   ds
			
            mov   ax,0
            mov   es,ax
			
    ; 安装
            mov   si,offset int9
            mov   di,204h
            mov   cx,offset int9end-offset int9
            cld
            rep   movsb
			
            push  es:[9*4]
            pop   es:[200h]
            push  es:[9*4+2]
            pop   es:[202h]
			
            cli
            mov   word ptr es:[9*4],204h
            mov   word ptr es:[9*4+2],0
			
            mov   ax,4c00h
            int   21h
			
    int9:   push  ax
            push  bx
            push  cx
            push  es
			
            in    al,60h
			
            pushf
            call  dword ptr cs:[200h]
			
            cmp   al,3bh                           ; F1扫描码为3bh
            jne   int9ret
			
            mov   ax,0b800h
            mov   es,ax
            mov   bx,1
            mov   cx,2000
    s:      inc   byte ptr es:[bx]
            add   bx,2
            loop  s
	    	
    int9ret:pop   es
            pop   cx
            pop   ax
            pop   ax
            iret
  			
    int9end:nop
  
code ends
end start