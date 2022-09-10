; 王爽汇编实验10.2 解决除法溢出

; 子程序描述   名称：divdw
; 功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为 dword 型。
; 参数：(dx)=dword型数据的高16位    (ax)=dword型数据的低16位  	(cx)=除数
; 返回：(dx)=结果的高16位		      (ax)=结果的低16位  		(cx)=余数
; 应用举例：计算 1000000/10   (F4240H/0AH)
; 思路：X/N = int(H/N)*65536  + [rem(H/N)*65536+L] / N  该公式的计算见书籍辅附注5
; 


assume cs:codesg, ds:datasg, ss:stacksg

datasg segment

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
		
		mov dx, 000FH ; 除数的高16位
		mov ax, 4240H ; 除数的低16位
		mov cx, 10 ; 	除数为10
		call divdw
		mov ax, 4c00h
		int 21h
		
		; 程序开始，将用到的寄存器备份下
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
codesg ends
end start

; 背景知识：div是除法指令，使用div做除法的时候应注意以下问题。
; 除数：有8位和16位两种，在一个reg或内存单元中。
; 如果除数为8位， 被除数则为16位， 默认在AX中存放；AL存商，AH存余数； 
; 如果除数为16位，被除数则为32位，在DX和AX中存放，DX存高位，AX存低位。AX存商，DX存余数。
; 除法格式：div reg   div 内存单元

