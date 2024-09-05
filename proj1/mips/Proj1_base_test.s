.data
    num1: .word 10
    num2: .word 5
    result: .word 0

.text
main:

checkAdd:
    # add
    lw $t0, num1
    lw $t1, num2
    add $t2, $t0, $t1

checkAddi:
    # addi
    lw $t3, num1
    addi $t4, $t3, 5

checkAddiu:
    # addiu
    lw $t5, num1
    addiu $t6, $t5, -2

checkAddu:
    # addu
    lw $t7, num1
    lw $t8, num2
    addu $t9, $t7, $t8

checkAnd:
    # and
    lw $t0, num1
    lw $t1, num2
    and $t2, $t0, $t1

checkAndi:
    # andi
    lw $t3, num1
    andi $t4, $t3, 3

checkLui:
    # lui
    lui $t5, 0xABCD

checkLw:
    # lw
    lw $t6, num1

checkNor:
    # nor
    lw $t7, num1
    lw $t8, num2
    nor $t9, $t7, $t8

checkXor:
    # xor
    lw $t0, num1
    lw $t1, num2
    xor $t2, $t0, $t1

checkXori:
    # xori
    lw $t3, num1
    xori $t4, $t3, 2

checkOr:
    # or
    lw $t5, num1
    lw $t6, num2
    or $t7, $t5, $t6

checkOri:
    # ori
    lw $t8, num1
    ori $t9, $t8, 7

checkSlt:
    # slt
    lw $t0, num1
    lw $t1, num2
    slt $t2, $t0, $t1

checkSlti:
    # slti
    lw $t3, num1
    slti $t4, $t3, 15

checkSll:
    # sll
    lw $t5, num1
    sll $t6, $t5, 2

checkSrl:
    # srl
    lw $t7, num1
    srl $t8, $t7, 3

checkSra:
    # sra
    lw $t9, num1
    sra $t0, $t9, 4

checkSw:
    # sw
    lw $t1, num1
    sw $t1, result

checkSub:
    # sub
    lw $t2, num1
    lw $t3, num2
    sub $t4, $t2, $t3

checkSubu:
    # subu
    lw $t5, num1
    lw $t6, num2
    subu $t7, $t5, $t6


exit:
  li $v0, 10
  syscall
  
halt
   
