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
        # load the address of the string to be printed
    lasw $a0, msg1
    syscall            # execute the system call

    # Call function A
    jal functionA
    nop
    nop
    nop
    nop

    j exit
    nop
    nop
    nop
    nop
    

functionA:
    # Print message from function A
    li $v0, 4          # load system call code for printing a string
    lasw $a0, msg2       # load the address of the string to be printed
    syscall            # execute the system call

    add $t1, $zero, $ra
    
    # Call function B
    jal functionB
    nop
    nop
    nop
    nop

    # Return to main program
    jr $t1
    nop
    nop
    nop
    nop

functionB:
    # Print message from function B
    li $v0, 4          # load system call code for printing a string
    lasw $a0, msg3       # load the address of the string to be printed
    syscall            # execute the system call
    
    add $t2, $zero, $ra
    # Call function C
    jal functionC
    nop
    nop
    nop
    nop
     
    # Return to function A
    jr $t2
    nop
    nop
    nop
    nop

functionC:
    # Print message from function C
    li $v0, 4          # load system call code for printing a string
    lasw $a0, msg4       # load the address of the string to be printed
    syscall            # execute the system call
    
    add $t3, $zero, $ra    
    
    # Call function D
    jal functionD
    nop
    nop
    nop
    nop
    
    # Return to function B
    jr $t3
    nop
    nop
    nop
    nop

functionD:
    # Print message from function D
    li $v0, 4          # load system call code for printing a string
    lasw $a0, msg5       # load the address of the string to be printed
    syscall            # execute the system call
    
    add $t4, $zero, $ra
    
    # Call function E
    jal functionE
    nop
    nop
    nop
    nop

    # Return to function C
    jr $t4
    nop
    nop
    nop
    nop

functionE:
    # Print message from function E
    li $v0, 4          # load system call code for printing a string
    lasw $a0, msg6       # load the address of the string to be printed
    syscall            # execute the system call

    # Return to function D
    jr $ra
    nop
    nop
    nop
    nop

exit:
    li $v0, 10         # load system call code for exit
    syscall            # execute the system call
    halt
    nop
    nop
    nop
    nop
