.text

.globl power
.align 2
power:
    # Note the ABI: x will be in a0, e in a1, and the return value is expected in a0.
    add     t0, zero, a0
    addi    a0, zero, 1
1:  blez    a1, 2f
    mul     a0, a0, t0
    addi    a1, a1, -1
    j       1b
2:  ret
