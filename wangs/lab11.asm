; 编写一个子程序,  将包含任意字符,  以0结尾的字符串中的小写字母转变成大写字母，描述如下。
; 名称：letterc
; 功能：将以0结尾的字符串中的小写字母转变成大写字母
; 参数：ds:si指向字符串首地址
; 注意需要进行转化的是字符串中的小写字母a〜z,  而不是其他字符。

assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
	db "Beginner's All-purpose Symbolic Instruction Code.",0
datasg ends


stacksg segment
	db 20 dup(0)
stacksg ends



codesg segment
start:	mov ax, datasg
		mov ds, ax ; 初始化数据段
		
		mov ax, stacksg
		mov ss, ax 
		mov sp, 20 	; 初始化栈段
		
		mov si, 0	; ds:si指向字符串首地址
		call letterc
		
		mov ax, 4c00h
		int 21h
letterc: 	push bx
			push cx
			push si
	let:	cmp byte ptr[si], 0
			je short letok	; 如果等于0，则认为字符串结束
			
			cmp byte ptr[si], 61H
			jb continue ; 如果小于a，则认为不是小写字母
			
			cmp byte ptr[si], 7AH
			ja continue	; 如果大于z，则认为不是小写字母
			
			; 如果大于等于a，且小于等于z，则认为是小写字母，要转换为大写
			mov bl, [si]
			sub bl, 20h
			mov [si], bl
			
	continue: inc si
			  jmp short let
			
	letok:	pop si
			pop cx
			pop bx
			ret

codesg ends
end start