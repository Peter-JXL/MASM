; 课程设计1  任务：将实验7中的Power idea公司的数据按照图10.2所示的格式在屏幕上显示
; 
; 
; 
; 
; 
; 
; 
; 
assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
	db	'1975', '1976', '1977', '1978','1979', '1980', '1981', '1982', '1983'
	db	'1984', '1985', '1986', '1987','1988', '1989', '1990', '1991', '1992'
	db	'1993', '1994', '1995'
	;以上是表示21年的21个字符串, 共21*4 = 84个字节

	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000 
	;以上是表示21年公司总收入的21个dword型数据  起始地址为ds:[84]，也就是ds:[54h] 共21*2*2 = 84个字节，每个数据之间隔了4个字节

	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
	;以上是表示21年公司雇员人数的21个word型数据  起始地址为ds:[168], 共21*2 = 42个字节
datasg ends


table segment
	db 21 dup ('year summ ne ?? ') ;summ是5开始， ne是10开始13
table ends

table2 segment
	db 21 dup ('1995 ', '        ', '      ','    ', 0) ;  年份4个字符串，收入7个，人数5个，人均收入3个，最后加个空格字符串和0结束符，一行有4+1  + 7+1  + 5+1 + 3+1 + 1  = 5+8+6+4+1=24
	
table2 ends

stacksg segment
	dw 64 dup(0)	; 128个字节
stacksg ends



codesg segment
start:	mov ax, datasg
		mov ds, ax ;初始化数据段
		
		mov ax, stacksg
		mov ss, ax 
		mov sp, 128 ;初始化栈段
		
		call lab7 ; 第一步，将实验7作为一个子程序调用，将结果计算到table段
		
		call main ; 第二步，将table转换成字符串，并且挪到table2段
		
		; 第三步，将每年的数据 依次展示		
		mov ax, table2 ; 将table2段作为数据段		
		mov ds, ax
		
		mov cx, 21	; 循环21次展示字符串
		mov dh, 5	; 第5行开始展示
		mov dl, 1	; 第1列开始展示
		mov si, 0 	; 指向table2的第一个字符串
showline:	call show_str ; 
		inc dh	;在下一行开始展示		
		add si, 24	; si指向下一行字符串
		
		loop showline
		
		mov ax, 4c00h
		int 21h
		
		; ------------------------实验7子程序-----------------------------
lab7:  	push cx	
		push si
		push bx
		push bp
		push di
		push dx
		push ax
		push es
		; 初始化相关寄存器
		mov ax, table
		mov es, ax ;将table端移到es段寄存器
		
		mov cx, 21 ;循环21次
		mov si, 0 ;用于定位年份
		mov bx, 84 ;用于定位每年的收入，用作除数
		mov bp, 168 ; 用于定位每年的雇员人数
		mov di, 0 ;用于定位table段
	
lab7s:	push [si]	;将年份的前两位进栈
		push [si+2]	;将年份的后两位进栈
		pop	es:[di+2]  ;将年份的复制到table
		pop es:[di]  ;将年份的复制到table

		push [bx+2]	;将收入的前两位入栈
		push [bx]   ;将收入的后两位入栈
		pop es:[di+7]  ;将收入的后两位 ，出栈到table
		pop es:[di+5]	;将收入的前两位，出栈到table
		
		push ds:[bp]	;将人数入栈
		pop es:[di+10]	;将人数出栈到table
		
		mov dx,es:[di+5]  ;将收入的高位，复制到dx
		mov ax,es:[di+7]	;将收入的低位，复制到ax
		div word ptr es:[di+10]	;除以人数，商存在AX里
		mov es:[di+13], ax	;将商放在table里
	
		add di, 16  ;table移到下一行
		add si, 4	;年份移到下一个
		add bx, 4 	;收入移到下一个
		add	bp, 2	;人数移到下一个 
		
		loop lab7s
		
		; 计算完毕，恢复寄存器
		pop es
		pop ax
		pop dx
		pop di
		pop bp
		pop bx
		pop si
		pop cx
		ret
		; ------------------------实验7子程序结束-----------------------------
		
		; ------------------------main主程序开始，将table段的数据转换为字符串-----------------------------
main:	push ds
		push es
		push ax
		push si
		push di
		
		
		mov ax, table
		mov ds, ax	; ds 定位table段
		
		mov ax, table2
		mov es, ax	; es 定位table2段
		
		mov si, 0	; 用于定位table的一行
		mov di, 0	; 用于定位table2的一行
		
		
		
		; 开始转换
		mov cx, 21	;将21行转换为字符串
	main_loop:	push [si]	;将年份的前两位进栈
				push [si+2]	;将年份的后两位进栈
				pop	es:[di+2]  ;将年份的后两位复制到table2
				pop es:[di]  ;将年份的前两位复制到table2
				
				
				; 开始转换收入
				
				
				
				
				
				; 开始转换人数
				
				
				
				
				; 开始转换人均收入
				
				add si, 16	; si指向table的下一行		
				add di, 24	; si指向table2的下一行
				loop main_loop
		
		pop di
		pop si
		pop ax
		pop es
		pop ds
		ret
		
		
		; ------------------------main主程序结束-----------------------------
		
		
		
		; ------------子程序将dword型数转变为表示十进制数的字符串，字符串以0为结尾符。-----------------
		; 参数：dx 放高位，ax放低位  es:di指向要存放的地址
		; 返回：通过di输出到es
dtoc:	push dx
		push ax
		push bx

		
		mov cx, 10 ; 用作除数
		call divdw
		add cx, 30h ; 将余数转换为字符串
		push cx		; 先暂存到栈
		
		pop bx
		pop dx
		pop ax 
		ret
		
		
		; -----------------子程序 被除数为dword型，除数为word型，结果为 dword 型。-------------
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
		
		
show_str: 	;程序开始，先备份用到的寄存器内容
			push ax
			push es
			push di
			push si
			push bp
			push cx

			mov ax, 0B800H ; 显存开始地址
			mov es, ax	;  将显存放到es段寄存器
			
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
			mov ah, 02H  
			
			; 开始显示字符串
			mov ch,0
	show:	mov cl, [si]	;读取字符串
			jcxz showstrok			;为0则结束	
			mov es:[bp+di], cl	;复制字符串
			mov es:[bp+di+1], ah;复制字符串属性
			inc si
			add di,2		;显存指向下一个字符串
			jmp short show
			
			;程序结束，恢复用到的寄存器内容
	showstrok:	
			pop cx
			pop bp
			pop si
			pop di
			pop es
			pop ax
			ret			
		
codesg ends
end start