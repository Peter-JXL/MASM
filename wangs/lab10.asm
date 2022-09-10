; 王爽汇编实验10，显示字符串是现实工作中经常要用到的功能，应该编写一个通用的子程序来实现这个功能。
; 子程序名称：show_str 
; 功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串。
; 参数：（dh）=行号（取值范围0 ~ 24）, （dl）=列号（取值范围0〜79）,（cl）=颜色，ds:si指向字符串的首地址
; 返回：无
; 应用举例：在屏幕的8行3列，用绿色显示data段中的字符串。

assume cs:codesg, ds:datasg

datasg segment
	db 'Welcome to masm!',0
datasg ends

stacksg segment
	db 20 dup(0)
stacksg ends

codesg segment
start:	mov ax, datasg
		mov ds, ax	;初始化数据段
		
		mov ax, stacksg
		mov ss, ax 
		mov sp, 20 ;初始化栈段
		
		mov dh, 8	; 第8行
		mov dl, 3	; 第3列
		mov cl, 02H ;绿色的属性字节：0000 0010B 也就是02H
		mov si, 0	;si指向首字母
		call show_str
		mov ax, 4c00h
		int 21h
		
		
show_str: 	;程序开始，先备份用到的寄存器内容
			push ax
			push es
			push di
			push si
			push bp
			
			
			mov ax, 0B800H ; 显存开始地址
			mov es, ax	; 放到es段寄存器
			
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
	show:	mov cl, [si]	;读取字符串
			jcxz ok			;为0则结束	
			mov es:[bp+di], cl	;复制字符串
			mov es:[bp+di+1], ah;复制字符串属性
			inc si
			add di,2		;显存指向下一个字符串
			jmp short show
			
			;程序结束，恢复用到的寄存器内容
	ok:		pop bp
			pop si
			pop di
			pop es
			pop ax
			ret			

codesg ends
end start