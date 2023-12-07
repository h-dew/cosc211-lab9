# Exception Handler Framework for COSC211 Assignment 7

	.kdata

save0:	.word 0		# $at
save1:	.word 0		# $a0
save2:	.word 0		# $v

badaddr:
	.asciiz "Unaligned address in store: "
of:
	.asciiz "Arithmetic overflow\n"
cr:	
	.asciiz "\n"


	.ktext 0x80000180

	.set noat		#otherwise, we cannot touch $at  
	sw 	$at, save0
	sw	$a0, save1	# I save these but if you don't use them you don't have to 
	sw	$v0, save2 


	# It's an exception, what kind is it?
	# use $k0 and $k1 to hold the Cause and EPC
	mfc0 	$k0, $13
	srl	$k1, $k0, 2
	andi	$k1, $k1, 0x1f

	# use a mask to determine what the cause of was for the exception
	#and the branch to the correct part of code to handle the exception

	# Determine if it's a break exception
	li	$a0, 0x9
	beq	$k1, $a0, breakn

	# Determine if it's an overflow
	li	$a0, 0xc
	beq	$k1, $a0, overflow

	# Determine if it's a bad address
	li 	$a0, 0x5
	beq 	$k1, $a0, bAddr 

	j 	done

	
	# break n -- replace with noop instruction
breakn:

	mfc0	$k0, $14
	li	$k1, 0x0
	sw	$k1, ($k0)
	j 	exit

	# overflow -- replace with noop instruction
overflow:
	li 	$v0, 4
	la	$a0, of
	syscall

	mfc0	$k0, $14
	li	$k1, 0x0
	sw	$k1, ($k0)
	j 	exit

	# bad addr -- replace with noop instruction
bAddr:	
	li 	$v0, 4
	la	$a0, badaddr
	syscall
	#get the bad address

	mfc0	$a0, $8		#get bad address and store in $a0
	li 	$v0,1
	syscall

	mfc0	$k0, $14
	li	$k1, 0x0
	sw	$k1, ($k0)
	j 	exit


done:	

#	mfc0 $k0, $14
#	addiu $k0, $k0, 4  	# if this is an exception, we add 4 to EPC

	#update the EPC and clear the Cause registers.  You may need to do something to Status as well
	

exit:
	# clear the cause register
	mtc0	$0, $13
	
	# fix status register
	mfc0	$k0, $12
	andi	$k0, 0xfffd
	ori	$k0, 0x1
	mtc0	$k0, $12

	# restore used register(s)
	lw 	$at, save0
	lw	$a0, save1
	lw	$v0, save2

	eret	              	# return to EPC	

	# startup rountine
	.text
	.globl __start

__start:
	
	jal main
	li $v0, 10
	syscall


