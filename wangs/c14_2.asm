; 检测点 14.2
; 编程，用加法和移位指令计算(ax)=(ax)*10
; 提示,  (ax)* 10=(ax)*2 + (ax)*8。
assume cs:codesg


codesg segment
start:	mov ax, 0AH
		mov bx, ax
		
		; 计算 (ax)*2 
		shl ax, 1
		
		; 计算 (ax) * 8 
		mov cl, 3
		shl bx, cl
		
		; 计算ax
		add ax ,bx
		
		
		mov ax, 4c00h
		int 21h
codesg ends
end start