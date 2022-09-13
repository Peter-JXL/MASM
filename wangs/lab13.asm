; 王爽汇编实验13 （1）编写并安装int 7ch中断例程，功能为显示一个用0结束的字符串，中断例程安 装在0:200处。
; 参数：（dh）=行号，（dl）=列号，（cl）=颜色，ds:si指向字符串首地址。
; 以上中断例程安装成功后，对下面的程序进行单步跟踪，尤其注意观察int、iret指令 执行前后CS、IP和栈中的状态。


assume cs:codesg, ds:datasg

datasg segment
	db "welcome to masm!", 0
datasg ends


codesg segment
start:	mov ax, datasg
		mov ds, ax ;初始化数据段
		mov si, 0	; 指向字符串首地址
		
		mov dh, 10
		mov dl, 10
		mov cl, 2
		int 7ch
		
		mov ax, 4c00h
		int 21h
codesg ends
end start