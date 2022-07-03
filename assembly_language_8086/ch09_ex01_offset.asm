; 将s处的一条指令复制到s0处
; 1、offset获取偏移量，了解指令的长度，复制
CODES SEGMENT
          ASSUME CS:CODES
    START:
    s:    
          mov    ax,bx
          mov    si,offset s
          mov    di,offset s0
          mov    dx,cs:[si]
          mov    cs:[di],dx
    s0:   
          nop
          nop
          MOV    AH, 4CH
          INT    21H
CODES ENDS
END START