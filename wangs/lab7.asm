;编程，将data段中的数据按如下格式写入到table段中，并计算21年中的人均收入（取整），结果也按照下面的格式保存在table段中。


assume ds:data, cs:codesg, ss:stack
data	segment
	db	'1975', '1976', '1977', '1978','1979', '1980', '1981', '1982', '1983'
	db	'1984', '1985', '1986', '1987','1988', '1989', '1990', '1991', '1992'
	db	'1993', '1994', '1995'
	;以上是表示21年的21个字符串

	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000 
	;以上是表示21年公司总收入的21个dword型数据

	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
	;以上是表示21年公司雇员人数的21个word型数据
data ends

table segment
	db 21 dup ('year summ ne ?? ')
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
		mov di, 0 ;用于定位table段
		
s:		mov bx, [si]  ;复制年份到bx
		push [si]	;将年份的前两位进栈
		push [si+2]	;将年份的后两位进栈
		pop	es:[di+2]
		pop es:[di]
	
		add di, 16
		add si, 4
		
		loop s
		mov ax, 4c00h
		int 21h
codesg ends
end start