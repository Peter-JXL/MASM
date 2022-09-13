; 中断例程：将一个全是字母，以0结尾的字符串，转化为大写。
; 参数：ds:si指向字符串的首地址。
; 应用举例：将data段中的字符串转化为大写。

assume cs:codesg

codesg segment
start: 	mov ax, cs
		mov ds, ax
		mov si, offset capital ; ds：si指向程序源地址
		
		mov ax, 0
		mov es, ax
		mov di, 200h	; es:si 中断例程要存储的地方
		
		; 传送例程到中断向量区
		mov cx, offset capitalend - offset capital
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
		
capital:	push cx
			push si
change:		mov cl, [si]
			mov ch, 0
			jcxz ok
			and byte ptr [si], 11011111b
			inc si
			jmp short change
ok:			pop si
			pop cx
			iret
capitalend:	nop
			
codesg ends
end start