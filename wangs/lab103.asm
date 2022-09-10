; 王爽-汇编实验10.3
; 编程，将数据12666以十进制的形式在屏幕的8行3列，用绿色显示出来。显示可用子程序show_str

assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
	db 10 dup (0)
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
		
		; 得到十进制数的ASCII码
		mov ax, 12666
		mov si, 0	;ds:si指向字符串的首地址，默认加个0作为程序结尾
		call dtoc
		
		; 将十进制数显示到屏幕上
		mov dh, 8	; 第8行
		mov dl, 3	; 第3列
		mov cl, 2	;绿色的属性字节：0000 0010B 也就是02H
		call show_str
		
		; 程序结束
		mov ax, 4c00h
		int 21h
		
		
;;;;;;;;;;;;;;;;;;;;;;   子程序：十进制转换ASCII码  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			; 程序开始，备份用到的寄存器
dtoc:		push ax
			push cx
			push bx
			push si
			push dx
			
			; 用作除数，由于被除数大于10000， 除以10，商大于1000, 8位寄存器存不下，要用32位除法。			
			mov bx, 10 	
			
			; 由于求字符串是逆序求的，先取最后一位的字符串，然后是倒数第二个，因此用栈来存储，先push 0用作结尾。算完后依次出栈
			mov dx, 0
			push dx
				
	calc:	mov dx, 0	; 32位除法，DX存高位，AX存低位。AX存商，DX存余数。   我们只用了ax，因此dx置0. 
			div bx						
			add dx, 30h ; 转换余数为字符串
			push dx		; 将字符串结果入栈
			mov cx, ax
			jcxz outstack
			jmp calc
			
	outstack:pop cx
			mov [si], cl
			inc si
			jcxz dotcok
			jmp short outstack
			
			; 计算完毕，恢复用到的寄存器			
	dotcok:	pop dx
			pop si
			pop bx
			pop cx
			pop ax
			ret
		
		
;;;;;;;;;;;;;;;;;;;;;;   子程序：显示字符串  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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