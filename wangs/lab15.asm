; 安装一个新的int 9中断例程，功能：在DOS下，按下“A”键后，除非不再松开， 如果松开，就显示满屏幕的“A”，其他的键照常处理。

; 提示，按下一个键时产生的扫描码称为通码，松开一个键产生的扫描码称为断码。断码=通码+ 80h

assume cs:codesg


stacksg segment
	db 128 dup(0)
stacksg ends



codesg segment
start:	mov ax, stacksg
		mov ss, ax 
		mov sp, 128 ;初始化栈段
		
		; 设置ds：si指向源地址，准备复制程序
		push cs
		pop ds
		mov si, offset int9
		
		; 设置es：di指向目的地址
		mov ax, 0
		mov es, ax
		mov di, 204h
		
		; 复制程序
		mov cx, offset int9end - offset int9
		cld
		rep movsb
		
		; 将原本的9h中断例程放到200h处
		push es:[9*4]
		pop es:[200h]
		push es:[9*4+2]
		pop es:[202h]
		
		; 设置新的9h为我们的程序
		cli
		mov word ptr es:[9*4], 204h
		mov word ptr es:[9*4 + 2], 0
		sti
		
		; 安装完毕，退出程序
		mov ax, 4c00h
		int 21h

int9:	push ax
		push bx
		push cx
		push es
		
		in al, 60h
		pushf 
		call dword ptr cs:[200h] ;执行原本的int 9h例程
		
		cmp al, 9Eh ; A键的扫描码为1Eh, 断码1E+80H = 9E 
		jne int9ret
		
		mov ax, 0b800h
		mov es, ax
		mov al, 'a'
		mov bx, 0
		mov cx, 2000
int9s:	mov es:[bx], al
		add bx, 2
		loop int9s
		
int9ret:pop es
		pop cx
		pop bx
		pop ax
		iret
		
int9end:nop		
		
codesg ends
end start