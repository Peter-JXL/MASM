; 编写0号中断的处理程序，使得在除法溢出发生时，在屏幕中间显示字符串"divide error!”  ，然后返回到DOS。

assume cs:codesg


codesg segment
start:	mov ax, cs
		mov ds, ax
		mov si, offset do0 ; 源地址ds:si指向 中断代码，准备传送到0:200
		
		mov ax, 0
		mov es, ax
		mov di, 200h	;目的地址指向中断程序要存放的地址，
		
		mov cx, offset do0end - offset do0
		cld
		rep movsb	; 传送中断代码到0:200处
		
		; 设置中断向量表
		mov ax, 0
		mov es, ax
		mov word ptr es:[0*4], 200h ; 偏移地址
		mov word ptr es:[0*4+2], 0 	; 段地址
		
		; 安装中断程序完毕，退出程序
		mov ax, 4c00h
		int 21h
		
		
		; 中断程序代码
do0:	jmp short do0start
		db 'overflow!'
do0start: 	mov ax, cs
			mov ds, ax
			mov si, 202h	; 设置ds：si指向字符串overflow
			
			mov ax, 0b800h
			mov es, ax		; 显存的段地址
			mov di, 12*160 + 32 *2  ; 设置偏移地址为显存的中间位置
			
			mov cx, 9	; 字符串长度
do0loop:	mov al, [si]
			mov es:[di], al
			inc si
			add di,2
			loop do0loop
			
			; 中断程序处理完毕，结束
			mov ax, 4c00h
			int 21h
do0end:		nop			
		
		
		
codesg ends
end start