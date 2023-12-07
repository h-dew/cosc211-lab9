#************************************************************
#	This is a test program for lab 9 for cosc 211
#	This program loops until the character 'Z' is 
#	detected in $s0
#************************************************************

	.text
	.globl main

main:

loop:	
	beq $s0, 90, done
	j loop	
done:	
	jr $ra
	
	
