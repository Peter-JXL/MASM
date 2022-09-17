; 安装一个新的int 7ch中断例程，为显示输出提供如下功能子程序。
; (1) 清屏；
; (2) 设置前景色；
; (3) 设置背景色；
; (4) 向上滚动一行。

; 入口参数说明如下。
; (1) 用ah寄存器传递功能号：0表示清屏，1表示设置前景色，2表示设置背景色, 3表示向上滚动一行；
; (2) 对于1、2号功能，用al传送颜色值，(al) ∈ {0,1,2,3,4,5,6,7}。
; 7		 6 5 4		 3 			2 1 0 
; 闪烁	 背景RGB     高亮		前景RGB
assume cs:codesg, ss:stacksg



stacksg segment
	db 128 dup(0)
stacksg ends


codesg segment
start:	;初始化栈段
		mov ax, stacksg
		mov ss, ax 
		mov sp, 128 
	
	
		; 设置ds：si指向源地址，准备复制程序
		push cs
		pop ds 
		mov si, offset setscreen 


		;指向0:200，中断例程存放的地址
		mov ax, 0
		mov es, ax
		mov di, 200h  
		
		; 开始复制代码到0:200
		mov cx, offset setscreen - offset setscreenend
		cld
		rep movsb

		; 安装7ch
		mov word ptr es:[7ch * 4], 200h	;偏移地址
		mov word ptr es:[7ch * 4 + 2], 0	;段地址
		
		; 测试1号子程序
		mov ah, 1
		
		mov ax, 4c00h
		int 21h
		
		
setscreen:	jmp short set
	table	dw sub1, sub2, sub3, sub4
	set:	push bx	; bx用于计算table表中的偏移
			cmp ah, 3
			ja sret
			mov bl, ah
			add bx, bx	; 由于table是字单元，计算偏移要*2， 例如sub2的地址是1*2
			call word ptr table[bx]
	sret:	pop bx
			ret
			
;----------0号子程序，表示清屏------------------
	sub1:	push bx
			push cx
			push es
			
			mov bx, 0b800h
			mov es, bx
			mov bx, 0	; 用于定位具体的显存单元
			mov cx, 2000
	sub1s:	mov byte ptr es:[bx], ' ' ;每个显存都复制空格字符串
			add bx, 2
			loop sub1s
			
			pop es
			pop cx
			pop bx
			ret
	
;----------1号子程序，表示设置前景色 用al传送颜色值------------------
	sub2:	push bx
			push cx
			push es
			
			mov bx, 0b800h
			mov es, bx
			mov bx, 1
			mov cx, 2000
	sub2s:	and byte ptr es:[bx], 11111000b  ; 将前景色RGB先置为000
			or es:[bx], al  ; 根据al设置前景色
			add bx, 2 ;定位下一个属性字节
			loop sub2s
			
			pop es
			pop cx
			pop bx
			ret
	
;----------2号子程序，表示设置背景色 用al传送颜色值------------------			
	
	sub3:	push bx
			push cx
			push es
			
			mov cl, 4
			shl al, cl  ; 将背景色挪到前4位
			
			mov bx, 0b800h
			mov es, bx
			mov bx, 1
			mov cx,2000
	sub3s:	and byte ptr es:[bx], 1000111b ; 背景色RGB先置为000
			or es:[bx], al  ; 设置背景色
			add bx, 2
			loop sub3s
		
			pop es
			pop cx
			pop bx
			ret
			
;----------3号子程序，表示向上滚动一行------------------			
			
	sub4:	push cx
			push si
			push di
			push es
			push ds
			
			mov si, 0b800h
			mov es, si
			mov ds, si
			mov si, 160
			mov di, 0
			cld 
			mov cx, 24
	sub4s:	push cx
			mov cx, 160
			rep movsb
			pop cx
			loop sub4
			
			mov cx, 80
			mov si, 0
	sub4s1:	mov byte ptr [160*24 + si], ' ' ;最后一行清空
			add si, 2
			loop sub4s1
			
			pop ds
			pop es
			pop di
			pop si
			pop cx
			ret
			
codesg ends
end start