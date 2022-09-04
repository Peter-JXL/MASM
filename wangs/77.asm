;将datasg段中每个单词改为大写字母
assume cs:codesg, ds:datasg

datasg segment
	db 'ibm             '
	db 'dec             '
	db 'dos             '
	db 'vax             '
datasg ends

codesg segment
start:	
	mov ax, datasg
	mov ds, ax
	mov cx, 4
	mov bx, 0 ;用于定位行 共4行
s:	mov al, [bx]
	and al, 11011111b
	mov [bx], al
	add bx, 16
	loop s
	
	mov ax, 4c00h
	int 21h
codesg ends

end start	