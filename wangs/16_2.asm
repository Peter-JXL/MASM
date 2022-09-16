; 检测点16.2 下面的程序将code段中a处的8个数据累加，结果存储到b处的双字中，补全程序。

assume cs:code, es:data

data segment
	a db 1,2,3, 4,5, 6, 7,8 
	b dw 0
data ends

code segment
start:	mov ax,data	; 填空
		mov es, ax	; 填空
		mov si,0
		mov cx,8
s: 		mov al, a[si]
		mov ah, 0
		add b, ax
		inc si
		loop s

		mov ax,4c00h
		int 21h
code ends
end start

; 实验结果：b = 24h = 32，计算完毕