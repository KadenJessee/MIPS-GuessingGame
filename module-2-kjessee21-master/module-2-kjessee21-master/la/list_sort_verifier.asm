# Author: Kaden Jessee
# Date:	17 Jan 2022
# Desc: This program asks for a list of integers from the user and verifies
#	that the integers are in ascending order.

#Used Registers
#	$a0 	- String address to print
#	$v0	- Syscall and return value
#	$t0	- Store the user inputed value
#	$t1	- Loop counter
#	$t2	- Loop endpoint
#	$t3	- Item offset
#	$t4	- Verifier Loop Counter
#	$t5	- First item
#	$t6	- Second item


.data	# your "data"

welcome_txt: .asciiz "Welcome to the sorted list verifier\n"
prompt_txt: .asciiz "Enter a number(negative value to finish): "
bad_order_txt: .asciiz "Those values are out of order\n"
in_order_txt: .asciiz "Everything is in order\n"


.align 2
items: .space 40

.text	# actual instructions

.globl main
main:
	la $a0, welcome_txt	#print("welcome...")
	li $v0, 4
	syscall
	
	
	li $t1, 0
	li $t2, 10
	#do
input_loop:	la $a0, prompt_txt	#print("Enter a...")
	li $v0, 4
	syscall
	
	li $v0, 5		#read int
	syscall
	move $t0, $v0
	bltz $t0, end_input	#if $t0 < 0:	break
	sll $t3, $t1, 2		# $t3 = $t1 * 4
	sw $t0, items($t3)	#Store user input into item[$t3]
	add $t1, $t1, 1		#i++
	# while $t1 < $t2
	blt $t1, $t2, input_loop
end_input:
	
	li $t4, 1
sort_loop:	
	bge $t4, $t1, end_sort	#while $t4 < $t1
	sub $t3, $t4, 1		#$t3 = $t4 - 1
	sll $t3, $t3, 2		#$t3 = ($t4-1)*4
	lw $t5, items($t3)	#$t5 = items[$t3] 
	sll $t3, $t4, 2		#$t3 = $t4 * 4
	lw $t6, items($t3)
	ble $t5, $t6, endif	#if $t5 > $t6:
	la $a0, bad_order_txt	#	print("Out of order")
	li $v0, 4		
	syscall	
	j exit
endif:
	add $t4, $t4, 1
	j sort_loop
end_sort:
	la $a0, in_order_txt	#print("Everything is in order")
	li $v0, 4		#
	syscall

exit:
	# exit the program using syscall 10 - exit
	li $v0, 10
	syscall
	