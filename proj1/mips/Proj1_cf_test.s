    .data
msg1:   .asciiz "This is the main program.\n"
msg2:   .asciiz "This is function A.\n"
msg3:   .asciiz "This is function B.\n"
msg4:   .asciiz "This is function C.\n"
msg5:   .asciiz "This is function D.\n"
msg6:   .asciiz "This is function E.\n"

.text
.globl main

main:
    # Print message from main
    li $v0, 4          # load system call code for printing a string
    la $a0, msg1       # load the address of the string to be printed
    syscall            # execute the system call

    # Call function A
    jal functionA

    j exit
    

functionA:
    # Print message from function A
    li $v0, 4          # load system call code for printing a string
    la $a0, msg2       # load the address of the string to be printed
    syscall            # execute the system call

    add $t1, $zero, $ra
    
    # Call function B
    jal functionB

    # Return to main program
    jr $t1

functionB:
    # Print message from function B
    li $v0, 4          # load system call code for printing a string
    la $a0, msg3       # load the address of the string to be printed
    syscall            # execute the system call
    
    add $t2, $zero, $ra
    # Call function C
    jal functionC
     
    # Return to function A
    jr $t2

functionC:
    # Print message from function C
    li $v0, 4          # load system call code for printing a string
    la $a0, msg4       # load the address of the string to be printed
    syscall            # execute the system call
    
    add $t3, $zero, $ra    
    
    # Call function D
    jal functionD
    
    # Return to function B
    jr $t3

functionD:
    # Print message from function D
    li $v0, 4          # load system call code for printing a string
    la $a0, msg5       # load the address of the string to be printed
    syscall            # execute the system call
    
    add $t4, $zero, $ra
    
    # Call function E
    jal functionE

    # Return to function C
    jr $t4

functionE:
    # Print message from function E
    li $v0, 4          # load system call code for printing a string
    la $a0, msg6       # load the address of the string to be printed
    syscall            # execute the system call

    # Return to function D
    jr $ra

exit:
    li $v0, 10         # load system call code for exit
    syscall            # execute the system call
    halt
