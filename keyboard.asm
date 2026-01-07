.data
buf: .space 100 # 100 bytes -> at most 100 chars (including NULL)


.text
main:
	# initialize address to buffer of size 100
	la $s0, buf
	
	# initialize a limit of size 100
	li $s1, 100
	
	# send args and call gets
	move $a0, $s0	# buf
	move $a1, $s1	# limit
	jal gets
	
	# send args and call puts
	move $a0, $s0	# buf
	jal puts
	
	
	# exit without dropping off
	li $v0, 10
	syscall

# gets char from transmitter		
getchar:
	lui $t0, 0xffff				# memory address 0xffff0000
	getchar_Waitloop:
		lw $t1, 0($t0)			# receiver control (0xffff0000)
		andi $t1, $t1, 0x0001		# check ready bit with mask
		beq $t1, $zero, getchar_Waitloop
		lw $v0, 4($t0)			# data transmitter (0xffff0004)
		jr $ra


# prints $a0				
putchar:
	lui $t0, 0xffff				# memory address 0xffff0000
	putchar_Waitloop:
		lw $t1, 8($t0)			# transmitter control (0xffff0008)
		andi $t1, $t1, 0x0001		# check ready bit with mask
		beq $t1, $zero, putchar_Waitloop
		sw $a0, 12($t0)			# transmitter dara (0xffff000c)
		jr $ra		


# int gets(char* buffer, int limit) reads string from keyboard without syscalls
# $a0 = address of a buffer where string will be stored
# $a1 = max string length, including null-term and newline before if applicable
# returns #v0 = length of string without null terminator
# repeatedly uses getchar to read characters from keyboard, when user presses [ENTER] or limit-1 chars read, append null and exit
gets:
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	
	# load args + assign vars
	move $s1, $a0		# $s1 = &buf
	move $s2, $a1		# $s2 = limit
	addi $s3, $s2, -1	# $s3 = limit w/o null = limit-1
	li $s4, 0		# $s4 = count
	
	# input validation
	ble $s2, $zero, gets_exit			# if limit <= 0 exit
	ble $s3, $zero, gets_append_null_only	# limit-1 = null so just append null and exit

	gets_loop:
		# check if limit-1 met
		beq $s3, $s4, gets_append_null	# if (count == limit-1) append and exit
	
		# call getchar
		jal getchar
		move $s5, $v0		# $s5 = cur_char
		
		# check for newline
		li $t0, 10			# 10 = newline
		beq $s5, $t0, gets_append_null	# if [enter], append and exit
	
		# append new char and loop
		sb $s5, 0($s1)		# buf[i] = cur_char
		addi $s1, $s1, 1	# i++
		addi $s4, $s4, 1	# count++
		j gets_loop
		
		
	gets_append_null:
		sb $zero, 0($s1) # append null
		# do not update count
		j gets_exit
		

	gets_append_null_only:	# buf[0] = NULL; exit
		li $s0, 0
		sb $s0, 0($s1)
		li $v0, 0
		j gets_exit
		

	gets_exit:
	# pop vals
	# set v0 to count
	# jr $ra
	
	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 28
	
	move $v0, $s4
	jr $ra
	

# int puts(char* buf) prints a string to the dsplay without syscalls
# $a0 = address of a null terminated string to print
# $v0 = length of the null terminated string, without the null terminator
puts:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	# load args + assign vars
	move $s0, $a0		# $s0 = &buf
	li $s2, 0		# $s2 = count
	
	
	puts_loop:
		lb $s1, 0($s0)	#s1 = cur char
		
		beq $s1, $zero, puts_exit	# if (buf[i] == NULL) exit
		
		move $a0, $s1		# call putchar
		jal putchar
		
		addi $s2, $s2, 1	# count++
		addi $s0, $s0, 1	# i++
		j puts_loop
		

	puts_exit:
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	move $v0, $s2		# return count
	jr $ra



