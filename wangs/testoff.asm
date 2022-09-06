assume cs:codesg

codesg segment
		mov ax, 0
		inc ax
		mov ax, 4c00h
		int 21h
	
start:	mov ax, 0  ;程序一开始，执行这条指令
s:		mov di, offset s

codesg ends
end start