assume cs:code, ds:datasg

datasg segment
	dw 0, 0, 0, 0
datasg ends

code segment
	start:	mov ax,2000H
			mov word ptr ds:[2], 0
			
			mov ax, 4c00H
			int 21h
code ends
end start
