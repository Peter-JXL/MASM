; 王爽汇编实验13的中断安装程序（2）编写并安装int 7ch中断例程，功能为完成loop指令的功能。 
; 参数：（cx）=循环次数，（bx）=位移。

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
show:		push bp  ; bp用于定位与修改栈里的IP，先备份
			mov bp, sp
			
			dec cx  ; cx = cx - 1
			jcxz ok ; 如果cx=0，则结束			
						
			add [bp+2], bx ; 修改栈中的IP 
ok:			pop bp
			iret
showend:	nop		


codesg ends
end start