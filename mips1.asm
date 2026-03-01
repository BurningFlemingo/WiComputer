# 0 (px_x)
# 4 (px_y)
# 8->60 (main memory) 
# 32,768 (framebuffer) 

addi $t1, $zero, -32768

loop:
add $t2, $zero, $t1
addi $t1, $t1, 1
sw $t2, ($t1)
beq $zero, $zero, loop
