; 中断例程：提供一个算平方的7ch中断例程

assume cs:codesg


codesg segment
start: 	mov ax, cs
		mov ds, ax
		mov si, offset sqr ; ds：si指向程序源地址
		
		mov ax, 0
		mov es, ax
		mov di, 200h	; es:si 中断例程要存储的地方
		
		; 传送例程到中断向量区
		mov cx, offset sqrend-offset sqr
		cld
		rep movsb
		
		; 安装中断例程
		mov ax, 0
		mov es,  ax
		mov word ptr es:[7ch * 4], 200h ;偏移地址
		mov word ptr es:[7ch * 4 + 2 ], 0 ;偏移地址
		
		; 安装程序结束，退出
		mov ax, 4c00h
		int 21h
		
sqr:	mul ax
		iret
sqrend: nop
codesg ends
end start