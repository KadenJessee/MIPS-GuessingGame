# Author: Kaden Jessee
# Date:	18 Jan 2022
# Description: Get user input, create if/else/for/while, read and write arrays of memory


# Registers used:
#	$a0 - String address to print
#	$v0 - syscall and return value
#	$t0 - store the user inputed value
#	$t1 - store the secret value
#	$t2 - loop counter
#	$t3 - loop endpoint
#	$t4 - loop counter
#	$t5 - loop endpoint
#	$t8 - items store
#	$t9 - items load


.data  # Data used by the program
guess_num: .word 7
prompt_txt: .asciiz "Guess a number between 0 and 10: "
lar_txt: .asciiz "Try a larger value\n"
small_txt: .asciiz "Try a smaller value\n"
bad_guess: .asciiz "Sorry the number was "
right_guess: .asciiz "That's right!\nYou Win!!!"
guesses: .asciiz "\nYou guessed "
sep: .asciiz " "

.align 2
items: .space 40	# 40 bytes

.text  # Instructions/code of the actual program

.globl main
main:
	li $t2, 0		#index for loop
	li $t3, 5		#index for loop
	li $t8, 0		#index for array
	
	li $t4, 0		#loop counter for end
	li $t9, 0		#array counter for end
	
	lw $t1, guess_num	#load guess_num into $t1

loop:	
	#if $t2 == 5
	#	end
	beq $t2, $t3, wrong
	add $t2, $t2, 1
	la $a0, prompt_txt	#print: guess a number...
	li $v0, 4
	syscall
	
	li $v0, 5		#read int
	syscall
	move $t0, $v0
	sw $t0, items($t8)		#array items[t8] = t0
	addi $t8, $t8, 4		#increase array by 4
	
	#$t0 == $t1
	#	print: correct guess
	beq $t0, $t1, endif
	
	#if $t0 < $t1
	#	print: guess larger
	bgt $t0, $t1, lessThan
	#if $t0 > $t1
	#	print: guess smaller
	blt $t0, $t1, greaterThan

lessThan:
	la $a0, small_txt
	li $v0, 4
	syscall
	#increment by 1 and go to loop
	j loop
	
greaterThan:
	la $a0, lar_txt
	li $v0, 4
	syscall
	#increment by 1 and go to loop
	j loop
	
endif:
	#if equal, print right guess, end
	la $a0, right_guess
	li $v0, 4
	syscall
	j exit


wrong:
	la $a0, bad_guess	#print off bad guess
	li $v0, 4
	syscall
	
	lw $a0, guess_num	#show correct number
	li $v0, 1
	syscall
	
	la $a0, guesses	#print guesses
	li $v0, 4
	syscall
	j end
end:
	beq $t4, $t3, exit
	#to do: loop over number of iterations $t9
	lw $a0, items($t9)
	li $v0, 1
	syscall
		#print value at array through each iteration
		
	la $a0, sep	#print separator
	li $v0, 4
	syscall
	
	add $t4, $t4, 1		#increment counter by 1
	add $t9, $t9, 4		#increment array by 4
	#end of loop
	j end

exit:
	#exit the program using syscall 10 - exit
	li $v0, 10
	syscall
