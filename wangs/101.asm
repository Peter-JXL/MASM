;检测点10.1 补全程序，实现从内存1000:0000处开始执行指令。
assume cs:code 
stack segment
	db 16 dup (0)
stack ends

code segment
start: 	mov ax, stack
		mov ss, ax
		mov sp, 16
		mov ax, 1000H  ;填空，将指令的段地址入栈
		push ax
		mov ax, 0  ; 填空将指令的偏移地址入栈
		push ax
		retf
code ends
end start