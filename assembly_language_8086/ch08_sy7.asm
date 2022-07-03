;将data段的数据，以表格的数据，每行展示每一年的数据
;分析：
;  1、使用两个段ds\es分别指向data段以及table段
;  2、年份数据和收入数据都是4个字节，使用bx进行寻址：ds:[bx+idata],而员工数式两个字节，使用si：ds:[si+idata]
;  3、table中的数据使用di
;  4、使用循环处理21行的数据

data segment
         db '1975','1976','1977','1978','1979','1980','1981','1982','1983'

         db '1984','1985','1986','1987','1988','1989','1990','1991','1992'

         db '1993','1994','1995'

    ;以上是表示21年的21个字符串

         dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514

         dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

    ;以上是表示21年 公司总收入的21个dword型数据

         dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226

         dw 11542,14430,15257,17800

    ;以上是表示21公司雇员人数的21个Word型数据。

data ends

table segment

          db 21 dup ('year summ ne ?? ')

table ends


codes segment
          assume cs:codes, ds:data
    start:
          mov    ax, data
          mov    ds, ax
          mov    ax,table
          mov    es,ax
          mov    cx,21
          mov    bx,0
          mov    di,0
          mov    si,0
    s:    
    ;   处理年份数据
          mov    dx,ds:[bx]
          mov    es:[di],dx
          mov    dx,ds:[bx+2]
          mov    es:[di+2],dx

    ; 处理总收入数据
          mov    ax,ds:[bx+84]
          mov    es:[di+5],ax
          mov    dx,ds:[bx+86]
          mov    es:[di+7],dx

    ; 使用div（16）计算平均值
          div    word ptr ds:[si+168]
          mov    es:[di+13],ax

    ; 处理员工数
          mov    dx,ds:[si+168]
          mov    es:[di+10],dx

    ; 处理完之后进行下一位移动
          add    bx,4
          add    si,2
          add    di,16
          loop   s
    
          mov    ah, 4ch
          int    21h
codes ends
end start