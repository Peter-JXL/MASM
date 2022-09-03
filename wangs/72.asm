;用si和di实现将字符串'welcome to masm!'  复制到它后面的数据区中
assume cs:codesg, ds:datasg

datasg segment
	db 'welcome to masm!'
	db '................'
datasg ends

codesg segment
start: 	mov di, datasg
		mov ds, di
	
		mov cx, 8 ;共16个字符串, 8个字，所以循环8次
		mov si, 0  ;定位第1个字符串中的字符
		mov di, 16  ;定位第2个字符串中的字符
	s:	mov ax, ds:[si]
		mov ds:[di], ax
		inc si
		inc si
		inc di
		inc di
		loop s
	
	mov ax, 4c00h
	int 21h
codesg ends
end start	