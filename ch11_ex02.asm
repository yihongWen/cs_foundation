;编程： 如果ah==bh  那么ah = ah+ah  否则ah = ah+bh
;实现：cmp指令+检测比较结果的条件跳转

CODES SEGMENT
            ASSUME CS:CODES
    START:  
    
    ; 比较ah跟bh的值
            CMP    ah,	bh
            je     s
            add    ah,bh
            jmp    cal_end
    s:      
            add    ah,ah
    cal_end:
            MOV    AH, 4CH
            INT    21H
CODES ENDS
END START