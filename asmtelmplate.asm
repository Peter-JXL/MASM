; 编写asm程序的一般结构

assume cs:code, ds:datasg, ss:stacksg

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
		
		mov ax, 4c00h
		int 21h
codesg ends
end start