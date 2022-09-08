assume cs:codesg, ds:datasg

datasg segment
	db 'Welcome to masm!'  ;16个字符
datasg ends

codesg segment
	start:	mov ax, datasg
			mov ds, ax; 初始化数据段
			
			mov ax, 0B800H	;显存的地址
			mov es, ax	; 将显存的地址放到es段寄存器中
			
			mov bx, 0	;用于定位字符串
			mov bp, 640H	; 用于定位行，分别是11,12，13行
			mov di, 62	; 用于定位列，分别是32~48列  一行160个内存单元（80个字），
			mov cx, 16  ; 一次循环搞定
s:			mov al, [bx]  ;低位存储字符的ASCII码

			;第一行 
			mov es:[bp+di], al	;	复制字符到显存里
			mov ah, 02H			;	复制绿色属性
			mov es:[bp+di+1], ah ;  复制属性到显存里
			
			;第二行 
			mov es:[bp + 0A0H + di], al	;	复制字符到显存里
			mov ah, 24H					;	复制绿色属性
			mov es:[bp + 0A0H + di + 1], ah ;  复制属性到显存里
			
			;第三行 
			mov es:[bp + 140H + di], al	;	复制字符到显存里
			mov ah, 71H					;	复制绿色属性
			mov es:[bp + 140H + di + 1], ah ;  复制属性到显存里
			
			inc bx		; 数据段指向下一个字符
			add di, 2   ; 显存指向下一个字符
			loop s
			
			mov ax, 4c00h
			int 21h			
codesg ends
end start

; 编程：在屏幕中间分别显示绿色、绿底红色、白底蓝色的字符串 `Welcome to masm!`
; 在80x25彩色字符模式下，显示器可以显示25行，每行80个字符
; 偏移000-09F对应显示器上的第1行（80个字符占160个字节）;
; 我打算在第11,12,13行  第32~48列  显示，  第11行就是640-6DF   第12行就是6E0-77F  第13行就是780-81F
; 160/2 - 16/2 = 32 , 显示器中间是40列，那么从40列往前显示8个字符，40列往后显示8个字符 
; 00-01单元对应第1列； 02-03单元对应显示器上的第2列； 等差数列，  第32列就是an=a1+(n-1)d = 62
; 绿色的属性字节：0000 0010B 也就是02H
; 绿底红色的属性字节：0010 0100B 也就是24H
; 白底蓝色的属性字节：0111 0001B 也就是71H
; 
; 
; 
; 
; 