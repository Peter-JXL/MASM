;编程，将data段中的数据按如下格式写入到table段中，并计算21年中的人均收入（取整），结果也按照下面的格式保存在table段中。
; 空格的ascii码为20

assume ds:data, cs:codesg, ss:stack
data	segment
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
data ends

table segment
	db 21 dup ('year summ ne ?? ') ;summ是5开始， ne是10开始13
table ends

stack segment
	dw 0,0,0,0, 0,0,0,0
stack ends


codesg segment
start: 	mov ax, data
		mov ds, ax ;初始化数据段
		
		mov ax, stack
		mov ss, ax
		mov sp, 16  ;初始化栈段
		
		mov ax, table
		mov es, ax ;将table端移到es段寄存器
		
		mov cx, 21 ;循环21次
		mov si, 0 ;用于定位年份
		mov bx, 84 ;用于定位每年的收入，用作除数
		mov bp, 168 ; 用于定位每年的雇员人数
		mov di, 0 ;用于定位table段
	
s:		push [si]	;将年份的前两位进栈
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
		
		loop s
		mov ax, 4c00h
		int 21h
codesg ends
end start