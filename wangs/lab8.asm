assume cs:codesg

codesg segment
	mov ax, 4c00h
	int 21h
	
start:	mov ax, 0  ;程序一开始，执行这条指令
s:		nop	;此时指令为jmp short s1
		nop
		
		mov di, offset s
		mov si, offset s2
		mov ax, cs:[si] ;复制jmp short s1到ax，之前是两个字节
		mov cs:[di], ax	;复制指令jmp short s1 到s

s0:		jmp short s	; 跳转到s
s1:		mov ax, 0  ;复制ax到0
		int 21h    ;执行21h，程序不能正常返回
		mov ax, 0
		
s2:		jmp short s1  ;跳转到s1
		nop
codesg ends
end start