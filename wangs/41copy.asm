; (1)编程，向内存0:200〜0:23F  依次传送数据0〜63  (3FH)。这里0~63是十进制数据
; 0:200〜0:23F = 0000:2000 ~ 0000:023F = 0020:0 ~ 0020:003F
assume cs:code
code segment
	mov ax, 0020H
	mov ds, ax
	mov bx, 0
	mov cx,64  ;注意0~63 有64个数字
	s:mov [bx], bx
	inc bx
	loop s
	mov ax, 4c00H
	int 21H
code ends
end