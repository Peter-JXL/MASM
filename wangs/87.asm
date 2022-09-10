; 测试div指令
assume cs:codesg, ds:datasg, ss:stacksg

datasg segment

datasg ends


stacksg segment
	db 20 dup(0)
stacksg ends



codesg segment
start:	mov ax, datasg
		mov ds, ax ;初始化数据段
		
		mov ax, stacksg
		mov ss, ax 
		mov sp, 20 ;初始化栈段
		
		;这样会溢出
		mov dx, 000Fh
		mov ax, 0
		mov cx, 10
		div cx
		
		mov ax, 4c00h
		int 21h
codesg ends
end start