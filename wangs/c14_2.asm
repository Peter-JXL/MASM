; 检测点 14.2
; (1) 编程，读取CMOS RAM的2号单元的内容。
; (2) 编程，向CMOS RAM的2号单元写入0。

assume cs:codesg


codesg segment
start:	mov al, 2
		out 70h, al
		in al,71h
		mov ax, 4c00h
		int 21h
codesg ends
end start