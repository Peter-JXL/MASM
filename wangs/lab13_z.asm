; 王爽汇编实验13的中断安装程序
; （1）编写并安装int 7ch中断例程，功能为显示一个用0结束的字符串，中断例程安 装在0:200处。
; 参数：（dh）=行号，（dl）=列号，（cl）=颜色，ds:si指向字符串首地址。
assume cs:codesg

codesg segment
start:	mov ax, cs
		mov ds, ax
		mov si, offset show	; 指向代码地址
		
		mov ax, 0
		mov es, ax
		mov di, 200h ;指向0:200，代码存放的地址
		
		; 开始传送代码
		mov cx, offset showend - offset show
		cld 
		rep movsb
		
		; 设置中断向量
		mov word ptr es:[7ch * 4], 200h ; 偏移地址
		mov word ptr es:[7ch * 4 + 2], 0 ; 段地址
		
		; 安装完毕，退出程序
		mov ax, 4c00h
		int 21h
		
			; 7ch的中断例程
show:		push es
			push ax
			push bp
			push di
			push dx
			push cx
			
			mov ax, 0b800h
			mov es, ax
			
			
			; 计算行的地址
			mov al, dh	; dh为要显示的行数
			sub al, 1	; 显存从0开始为第1行，因此先-1，用于计算行数
			mov ah, 0A0H	;一行有160个字节，也就是0A0H
			mul ah		; 相乘后，ax 存放了显存上要显示的行地址
			mov bp, ax	; bp用于定位行
			
			; 计算列的地址
			mov al, dl	; dl为要显示的列数
			sub al, 1	; 显存从0开始为第1列，因此先-1，用于计算列数
			mov ah, 2	; 一列有2个字节
			mul ah		; 相乘后，ax存放了显存上要显示的列地址
			mov di, ax	;di用来定位列
			
			;al存储属性字节
			mov ah, cl 
			
			; 开始显示字符串
			mov ch,0
continue:	mov cl, [si]	; 读取字符串
			jcxz showeok	; 为0则结束	
			mov es:[bp+di], cl	; 复制字符串
			mov es:[bp+di+1], ah; 复制字符串属性
			inc si			; si指向下一个字符
			add di,2		; 显存指向下一个字符
			jmp short continue
		
showeok:	pop cx
			pop dx
			pop di
			pop bp
			pop ax
			pop es
			iret
showend:	nop		


codesg ends
end start