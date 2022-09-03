;(6)程序如下，编写code段中的代码，用push指令将a段中的前8个字型数据，逆序存储到b段中。
assume cs:code 
a segment
	dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 0ah, 0bh, 0ch, 0dh, 0eh, 0fh
a ends

b segment
		dw 0,0,0,0,0,0,0,0
b ends

code segment
start: 	mov ax, b
		mov ss, ax
		mov sp, 10H
		
		mov ax, a
		mov ds, ax
		
		mov cx, 8
		mov bx, 0
s:		push ds:[bx]
		inc bx
		inc bx
		loop s
		
		mov ax, 4c00h
		int 21h

code ends

end start		