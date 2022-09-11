; 王爽-汇编实验 综合性实验1 子程序，完成dword型数据到字符串的转化，
; 编程，将数据 5937000 以十进制的形式在屏幕的8行3列，用绿色显示出来。显示可用子程序show_str

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
		mov dx, 9
		mov ax, 0F24H		
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
			

			
			; 由于求字符串是逆序求的，先取最后一位的字符串，然后是倒数第二个，因此用栈来存储，先push 0用作结尾。算完后依次出栈
			mov cx, 0
			push cx
			
				
				
	calc:	mov cx, 10 	; 用作除数	
			call divdw						
			add cx, 30h ; 转换余数为字符串
			push cx		; 将字符串结果入栈
			
			mov cx, dx	; 将高位的商挪到cx，准备判断是否为0
			jcxz axis0	; 如果是0，则判断ax是否为0
			jmp calc	; 如果dx不是0，那么商一定不为0，继续计算
	axis0:	mov cx, ax	; 将低位的商挪到cx，准备判断是否为0
			jcxz outstack	; 如果是0，则说明dx和ax都为0，也就是商为0，转换完毕，
			jmp calc	;如果ax不是0，则说明商一定不为0，继续计算
			
	outstack:pop cx
			mov [si], cl
			inc si
			jcxz dotcok
			jmp short outstack
			
			; 转换完毕，恢复用到的寄存器			
	dotcok:	pop dx
			pop si
			pop bx
			pop cx
			pop ax
			ret
				
; ;;;;;;;;;;;;;;子程序 被除数为dword型，除数为word型，结果为 dword 型。;;;;;;;;;;;;;;;;;;;;
		; 参数： (ax)=dword型数据的低16位 (dx)=dword型数据的高16位  (cx)=除数
		; 返回： (dx)=结果的高16位，(ax)=结果的低16位      (cx)=余数
divdw:	push si
		push di
		
		; 用于dx和ax要用作除法，先将其存起来
		mov si, dx   ; 除数的高16位
		mov di, ax   ; 除数的低16位
		
		mov ax, dx  ; 此时ax为高16位的H
		mov dx, 0   ; 由于除数是16位，要做32位除法，因此计算H/N ，要将高位置0
		div cx     ; 做16位除法，除数为cx， 然后ax存储了商int(H/N)    dx为余数rem(H/N)
		push ax ; 将int(H/N)暂存起来，准备做加号后面的运算
		
		; 计算第二个部分
		mov ax, di ; 将低16位L挪到ax，  此时dx和ax 为 rem(H/N)*65536+L
		div cx   ; 计算 [rem(H/N)*65536+L] / N， 然后dx为余数，ax存的是商
		
		; 计算结束，开始传递参数
		mov cx, dx  ; ax存储本程序的余数
		pop dx  	; dx的值为int(H/N)
		
		; 程序结束，恢复用到的寄存器
		pop di
		pop si
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