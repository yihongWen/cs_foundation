assume cs:code
code segment
start:
;将int 7ch写入内存0:200h
mov ax,cs
mov ds,ax
mov si,offset int7ch
 
mov ax,0
mov es,ax
mov di,200h
 
mov cx,offset int7chend - offset int7ch
cld
rep movsb
 
;将int 7ch的地址写入中断向量表中
mov es:[4*7ch],200h
mov es:[4*7ch+2],0
 
;安装程序返回
mov ax,4c00h
int 21h
 
;写int 7ch的中断例程
;功能：根据逻辑扇区号计算出物理扇区号
;参数:
;ah表示读（ah=0），写（ah=1）
;dx 逻辑扇区号
;es:bx 读出/写入的内存首地址
int7ch:
push ax
push cx
push dx
 
push ax ;保存功能号
mov ax,dx
mov dx,0
mov cx,1440
div cx ;此时ax=面号
 
push ax ;将面号保存起来
mov ax,dx
mov cl,18
div cl ;此时al=int，ah=rem
mov ch,al ;直接获取磁道号
inc ah
mov cl,ah ;rem+1后为扇区号
 
pop dx ;将面号送入dl(dx)
mov dh,dl ;将面号送入dh
mov dl,0 ;驱动器号默认为0
 
pop ax ;将功能号送入ah
add ah,2 ;;ah=int 13h功能号，读（ah=2）写（ah=3）
mov al,1 ;al=读/写的扇区总数(默认al=1)
 
;调用int 13h中断例程进行读写
;int 13h参数
;ah=int 13h功能号，读（ah=2）写（ah=3）
;al=读/写的扇区总数(默认al=1)
;ch=磁道号
;cl=扇区号
;dh=磁头号（面）
;dl=驱动器号（默认dl=0）
;es:bx 指向要读/写的扇区
int 13h
 
int7chret:
pop dx
pop cx
pop ax
iret
 
int7chend:
nop
 
code ends
end start