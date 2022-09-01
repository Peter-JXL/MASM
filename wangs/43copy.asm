;(3)下面的程序的功能是将“mov ax,4c00h”之前的指令复制到内存0:200处，补全程序。上机调试，跟踪运行结果。
;提示:
;(1)复制的是什么？从哪里到哪里？
;(2)复制的的是什么？有多少个字节？你如何知道要复制的字节的数量？
assume cs:code
code segment
	mov ax, cs
	mov ds, ax
	
	mov ax, 0020H
	mov es, ax
	
	mov bx, 0
	mov cx, 17H
	s : mov al, [bx]
	mov es:[bx], al
	inc bx
	loop s

	mov ax,4c00h
	int 21h
code ends
end 
