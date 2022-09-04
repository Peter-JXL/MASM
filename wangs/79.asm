;编程，将datasg段中每个单词的前4个字母改为大写字母。
assume cs:codesg,  ss:stacksg, ds:datasg 

stacksg segment
	dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
db	'1. display      '
db	'2. brows        '
db	'3. replace      '
db	'4. modify       '
datasg ends

codesg segment
start:	mov ax, datasg
		mov ds, ax  ;初始化数据段
		
		mov ax, stacksg
		mov ss, ax
		mov sp, 10h ;初始化栈段
		
		mov cx, 4
		mov bx, 0
s0:		push cx
		push bx
		mov cx, 4
s:		mov al, [bx+3]
		and al, 11011111b
		mov [bx+3], al
		inc bx
		loop s
		pop bx
		pop cx
		add bx ,16
		loop s0
		
		mov ax, 4c00h
		int 21h
	
codesg ends
end start
