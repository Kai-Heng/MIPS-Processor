.data

numbers: .word 37,-3,298,100,0,-1,5,28,3,5,29		
result: .asciiz "Sorted: "			        # prompt result


.text
main:
	lui $s7, 0x1001					#load address of numbers into $s7
	li $s0, 0					#initialize counter 1 for loop 1
	li $s6, 9 					#n - 1
	li $s1, 0 					#initialize counter 2 for loop 2
	li $t3, 0					#initialize counter for printing
	li $t4, 10
	li $v0, 4,					#print out message
	lasw $a0, result
	syscall

bubbleSort:
	sll $t7, $s1, 2					#multiply $s1 by 2 and put it in t7
	nop
	nop
	nop
	add $t7, $s7, $t7 				#add the address of numbers to t7
	nop
	nop
	nop
	lw $t0, 0($t7)  				#load numbers[j]	
	lw $t1, 4($t7) 					#load numbers[j+1]
	nop
	nop
	nop
	slt $t2, $t0, $t1				#if t0 < t1
	nop
	nop
	nop
	bne $t2, $zero, increment
	nop
	nop
	nop
	nop
	sw $t1, 0($t7) 					#swap
	nop
	nop
	nop
	sw $t0, 4($t7)

increment:	
	addi $s1, $s1, 1				#increment t1
	sub $s5, $s6, $s0 				#subtract s0 from s6
	nop
	nop
	nop
	bne  $s1, $s5, bubbleSort			#if s1 (counter for second loop) does not equal 9, bubbleSort
	nop
	nop
	nop
	nop
	addi $s0, $s0, 1 				#otherwise add 1 to s0
	li $s1, 0 					#reset s1 to 0
	nop
	nop
	bne  $s0, $s6, bubbleSort			# go back through loop with s1 = s1 + 1
	nop
	nop
	nop
	nop
	
print:
	beq $t3, $t4, exit				#if t3 = t4 go to final
	nop
	nop
	nop
	nop
	lw $t5, 0($s7)					#load from numbers
	li $v0, 1					#print the number
	nop
	nop
	move $a0, $t5
	syscall
	nop
	nop
	li $a0, 32					#print space
	li $v0, 11
	syscall
	
	addi $s7, $s7, 4				#increment through the numbers
	addi $t3, $t3, 1				#increment counter
	j print
	nop
	nop
	nop
	nop

exit:	
	li $v0, 10					#end program
	syscall
	
halt
