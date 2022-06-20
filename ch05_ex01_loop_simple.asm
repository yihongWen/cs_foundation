;-------------------------第五章练习1:loop循环的简单例子-----------------------
;-------------------------用加法计算 123*236结果存在在ax中---------------------
;--------------------G命令的使用：跳出loop循环，(在vscode搭建的dos环境中p命令失效)
assume cs:code
code segment
         mov ax,0
         mov bx,236
         mov cx,123
         s:
            add ax,bx
            loop s
         mov ax,4c00h
         int 21h
code ends
end