; 13.1 程序案例

assume cs:codesg
codesg segment
start:	mov ax, 0b800h
		mov es, ax
		mov byte ptr es:[12*160 + 40 *2 ], '!'
		int 0

codesg ends
end start