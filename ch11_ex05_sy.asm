; 编写一个子程序，将包含任意字符，以0结尾的字符串中的小写字母转化成大写字母

data segment
         db "Beginner's All-purpose Symbolic Instruction Code.",0
data ends

stacks segment
    
stacks ends

codes segment
                 assume cs:codes, ds:data, ss:stacks
    start:       
                 mov    ax, data
                 mov    ds, ax
                 mov    si,0
                 call   letterc
                 mov    ah, 4ch
                 int    21h


    ; 子程序：letterc
    ; 功能：将以0为结尾的字符串中的小写字母转变成大些字母
    ; 参数：ds:si指向字符串的首地址
    ; 实现：
    ;   1、判断是否是小写字母（小写字母的asc码的区间范围97-122） 使用 cmp、条件转移
    ;   2、0为结尾，使用jcxz
    ;   3、大写转小写 +32 or 0010 0000
    letterc:     
                 push   cx
                 push   si

    s:           
                 mov    ch,0
                 mov    cl,ds:[si]
                 jcxz   exit_letterc
                 cmp    cl,97
                 jb     not_low
                 cmp    cl,122
                 ja     not_low
                 and    cl,11011111b
                 mov    ds:[si],cl
                 inc    si
                 jmp    s

    not_low:     
                 inc    si
                 jmp    s

    exit_letterc:
                 pop    si
                 pop    cx
                 ret

codes ends
end start