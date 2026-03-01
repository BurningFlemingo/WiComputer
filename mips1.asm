addi $t0, $zero, -32768  # framebuffer base
addi $t1, $zero, 0       # y counter
addi $t2, $zero, 120     # height (rows)
addi $t4, $zero, 160     # width (cols)

loop_y:
    addi $t3, $zero, 0   # x counter
loop_x:
    xor $t5, $t1, $t3    # color = x XOR y
    sw $t5, ($t0)        # write pixel
    addi $t0, $t0, 1     # advance framebuffer
    addi $t3, $t3, 1
    slt $s1, $t3, $t4
    bne $s1, $zero, loop_x

addi $t1, $t1, 1
slt $s0, $t1, $t2
bne $s0, $zero, loop_y