; 测试一个算平方的7ch中断例程, 例如计算  3456的平方 * 2， 
; 参数ax为要计算的数据
; 返回值： dx，ax中存放结果的高16位和低16位，本例中应为23,887,872  也就是16C8000H

assume cs:codesg


codesg segment
start: 	mov ax, 3456
		int 7ch
		add ax, ax
		adc dx, dx
		
		mov ax, 4c00h
		int 21h
codesg ends
end start