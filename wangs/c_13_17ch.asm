; 检测点13.1  
; (2) 用7ch中断例程完成jmp near ptr s指令的功能，用bx向中断例程传送转移位移。
; 应用举例：在屏幕的第12行，显示data段中成0结尾的字符串。
; 个人分析，可以用实现loop的方式，但是题目里要求完成jmp near ptr s的指令。
assume cs:code


code segment
start: 	mov ax, cs
		mov	ds, ax
		mov	si, offset show	; si指向程序准备复制7ch中断程序

		mov	ax, 0
		mov	es, ax
		mov	di, 200h	; di指向到0:200处
		
		; 设置中断向量表
		mov word ptr es:[7ch*4], 200h
		mov word ptr es:[7ch*4+2], 0
		
		; 复制程序到0:200处 
		mov cx, offset show_end - offset show
		cld
		rep movsb 

		
		
		
		; 安装中断程序完毕，退出程序
		mov	ax,4c00h
		int	21h
		
show: 	push bp
		mov bp, sp
		add [bp+2], bx
		pop bp
		iret
		
show_end: 	nop
code	ends	
end start	
