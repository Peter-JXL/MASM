; 王爽汇编实验13 （2）编写并安装int 7ch中断例程，功能为完成loop指令的功能。 
; 参数：（cx）=循环次数，（bx）=位移。


assume cs:codesg, ds:datasg

datasg segment
	db "welcome to masm!", 0
datasg ends


codesg segment
start:	mov ax, 0b800h
		mov es, ax
		mov di, 160*12
		
		mov bx, offset se - offset s 	;设置从标号se到标号s的转移位移
		mov cx, 80
		
s:		mov byte ptr es:[di], '!'
		add di, 2
		int 7ch
se:		nop		 ;如果(cx) #=0,转移到标号s处

		mov ax, 4c00h
		int 21h
codesg ends
end start