# Author: Kaden Jessee
# Date:	17 Jan 2022
# Desc: This program asks for a list of integers from the user and verifies
#	that the integers are in ascending order.

#Used Registers
#	$a0 	- String address to print
#	$v0	- Syscall and return value
#	$t0	- Store the user inputed value



.data	# your "data"

welcome_txt: .asciiz "Welcome to the sorted list verifier\n"
prompt_txt: .asciiz "Enter a number(negative value to finish): "
favorite_txt: .asciiz "That's my favorite number\n"
plain_txt: .asciiz "That's a plain old number\n"
negative_txt: .asciiz "That is a negative number\n"

fav_num: .word 7

.align 2
items: .space 40

.text	# actual instructions

.globl main
main:
	la $a0, welcome_txt	#print("welcome...")
	li $v0, 4
	syscall

	la $a0, prompt_txt	#print("Enter a...")
	li $v0, 4
	syscall
	
	li $v0, 5		#read int
	syscall
	move $t0, $v0
	sw $t0, items		#Store user input into items
	
	lw $t1, fav_num		#Load fav_num into $t1
	bne $t0, $t1, elseif	#if $t0 == fav_num:
	la $a0, favorite_txt	#	print: That's my...
	li $v0, 4
	syscall
	j endif
elseif:	bgez $t0, else 		#else if $t0 < 0:
	la $a0, negative_txt	
	li $v0, 4		#	print: That is a negative number
	syscall
	j endif
else:
	la $a0, plain_txt
	li $v0, 4
	syscall
				#else:
				#	print: That is just a plain old number
	
endif:	#... more code
	

exit:
	# exit the program using syscall 10 - exit
	li $v0, 10
	syscall
	