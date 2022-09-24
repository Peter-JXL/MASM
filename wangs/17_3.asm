; 最基本的字符串输入程序，需要具备下面的功能。
; (1) 在输入的同时需要显示这个字符串；
; (2) 一般在输入回车符后，字符串输入结束；
; (3) 能够删除已经输入的字符。

; 编写一个接收字符串输入的子程序，实现上面3个基本功能。因为在输入的过程中需要显示，子程序的参数如下：
; (dh)、(dl)=字符串在屏幕上显示的行、列位置；
; ds:si  指向字符串的存储空间，字符串以0为结尾符。


assume cs:codesg, ds:datasg

datasg segment
	db 128 dup(0)
datasg ends

codesg segment
			
start:		mov ax, datasg
			mov ds, ax
			mov si, 0 ; 初始化数据段
			
			mov dh, 2 ; (dh)、(dl)=字符串在屏幕上显示的行、列位置；
			mov dl, 1 
			
			call getstr

			
			mov ax, 4c00h
			int 21h

; ---------子程序：接收字符串输入的子程序-----------------
getstr:		push ax

getstrs:	mov ah, 0
			int 16h		; 0号表示输入 结果：(ah)=扫描码，(al)=ASCII码。
			cmp al, 20h	 
			jb nochar	; ASCII码小于20h，说明不是字符，要判断是回车还是退格
			mov ah, 0	; 否则字符入栈
			call charstack	
			
			; 输入完后，显示字符串
			mov ah, 2
			call charstack
			jmp getstrs	;循环输入，直到按下Enter键

nochar:		cmp ah, 0eh	;退格键的扫描码
			je backspace
			cmp ah, 1ch	;Enter键的扫描码
			je enter
			jmp getstrs  ; 如果都不是 就忽略

backspace:	mov ah, 1
			call charstack  ; 删除一个字符
			mov ah, 2
			call charstack  ; 然后显示字符串
			jmp getstrs

enter:		mov al, 0
			mov ah, 0
			call charstack ; 0入栈
			
			mov ah, 2
			call charstack ;显示字符串
			pop ax			
			ret
			
; ---------子程序：字符栈的入栈、出栈和显示。-----------------
; 参数说明：（ah）=功能号，0表示入栈，1表示出栈，2表示显示；
; ds:si指向字符栈空间；
; 对于0号功能：（al）=入栈字符；
; 对于1号功能：（al）=返回的字符；
; 对于2号功能：（dh）、（dl）=字符串在屏幕上显示的行、列位置。

charstack:	jmp short charstart
			table dw charpush, charpop, charshow
			top	  dw 0 ;栈顶
			
charstart:	push bx
			push dx
			push di
			push es
			
			cmp ah, 2
			ja sret
			mov bl, ah
			mov bh, 0
			add bx, bx
			jmp word ptr table[bx]

charpush:	mov bx, top
			mov [si][bx], al
			inc top
			jmp sret
			
charpop:	cmp top, 0
			je sret
			dec top
			mov bx, top
			mov al, [si][bx]
			jmp sret

charshow:	mov bx, 0b800h
			mov es, bx
			mov al, 160
			mov ah, 0
			mul dh  ; dh为行，相乘后，ax就是行所在的地址
			mov di, ax  ; di现在是行所在的地址
			add dl, dl  ;dl就是列所在的地址
			mov dh, 0
			add di, dx  ; di现在就是要显示的地址
			mov bx, 0
			
charshows:	cmp bx, top
			jne noempty
			mov byte ptr es:[di], ' '  ; 如果是空的，就显示一个空格
			jmp sret

noempty:	mov al, [si][bx]
			mov es:[di], al
			mov byte ptr es:[di+2], ' '
			inc bx
			add di, 2
			jmp charshows

sret:		pop es
			pop di
			pop dx
			pop bx
			ret

codesg ends
end start