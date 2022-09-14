; 实验14 编程，以“年/月/日时:分:秒"的格式，显示当前的日期、时间。

assume cs:codesg, ds:datasg

datasg segment
	db '22/09/14 22:18:01',0
datasg ends


codesg segment
start:	mov ax, datasg
		mov ds, ax  ; 初始化数据段
		mov si, 0	; 用于指向字符串
		
		; 读取年份  只读取了年份后两位
		mov al, 9
		out 70h, al
		in al, 71h
		call calc
		mov [si], ah
		mov [si+1],al
		
		; 读取月份
		mov al, 8
		out 70h, al
		in al, 71h
		call calc
		mov [si+3], ah
		mov [si+4],al
		
		
		; 读取日 
		mov al, 7
		out 70h, al
		in al, 71h
		call calc
		mov [si+6], ah
		mov [si+7],al
		
		
		; 读取小时
		mov al, 4
		out 70h, al
		in al, 71h
		call calc
		mov [si+9], ah
		mov [si+10],al
		
		; 读取分钟
		mov al, 2
		out 70h, al
		in al, 71h
		call calc
		mov [si+12], ah
		mov [si+13],al
		
		
		; 读取秒数
		mov al, 0
		out 70h, al
		in al, 71h
		call calc
		mov [si+15], ah
		mov [si+16],al
		
		
		; 显示到屏幕上，调用实验10的子程序
		mov dh, 8	; 第8行
		mov dl, 3	; 第3列
		mov cl, 02H ;绿色的属性字节：0000 0010B 也就是02H
		mov si, 0	;si指向首字母
		call show_str
		
		mov ax, 4c00h
		int 21h
		
calc:	mov ah, al
		mov cl, 4
		shr ah, cl
		and al, 00001111b
		add ah ,30h
		add al, 30h
		ret
		
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