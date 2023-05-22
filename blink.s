.include "gpio.inc"    @ Includes definitions from gpio.inc file

.thumb              @ Assembles using thumb mode
.cpu cortex-m3      @ Generates Cortex-M3 instructions
.syntax unified

.include "nvic.inc"
@ Función para habilitar el reloj en el puerto A
enable_clock:
    push    {r7}
    sub	    sp, sp, #12
    add	    r7, sp, #0
    ldr     r0, =RCC_APB2ENR     @ move 0x40021018 to r0
    str	    r0, [r7, #4]
    mov     r3, 0x04            @ loads 4 in r3 to enable clock in port A (IOPA bit)
    str	    r3, [r7]
    str     r3, [r0]            @ M[RCC_APB2ENR] gets 4
    adds    r7, r7, #12
    mov	    sp, r7
    @ sp needed
    pop	    {r7}
    bx	    lr

configure_pins:
    push    {r7}
    sub	    sp, sp, #12
    add	    r7, sp, #0
    ldr     r0, =GPIOA_CRL      @ move address of GPIOA_CRL register to r0
    str	    r0, [r7, #4]
    ldr     r3, =0x88833333     @ PA0-PA4 set to output mode, PA5-PA6 set to input mode with pull-down
    str	    r3, [r7]
    str     r3, [r0]            @ M[GPIOA_CRL] gets 0x88883333
    mov     r1, #0
    adds    r7, r7, #12
    mov	    sp, r7
    @ sp needed
    pop	    {r7}
    bx	    lr
    
set_led_output:
    push    {r7}
    sub	    sp, sp, #20
    add	    r7, sp, #0
    ldr     r0, =GPIOA_ODR  @ moves address of GPIOA_ODR register to r0
    str	    r0, [r7, #4]
    ldr     r2, =0x1F       @ mask to set PA0-PA4 bits
    str	    r2, [r7, #12]
    and     r3, r1, r2      @ get the 5 least significant bits of variable
    str	    r3, [r7]
    str     r3, [r0]        @ M[GPIOA_ODR] gets r3 value
    adds    r7, r7, #12
    mov	    sp, r7
    @ sp needed
    pop	    {r7}
    bx	    lr
    
read_input:
    push    {r7}
    sub	    sp, sp, #20
    add	    r7, sp, #0
    ldr     r0, =GPIOA_IDR  @ moves address of GPIOA_IDR register to r0
    str	    r0, [r7, #4]
    ldr     r3, [r0]        @ loads the value of GPIOA_IDR into r3
    str	    r3, [r7, #12]
    ands    r3, #0x60      @ mask off all bits except bits 5-6 (PA5-PA6)
    str	    r3, [r7]
    adds    r7, r7, #12
    mov	    sp, r7
    @ sp needed
    pop	    {r7}
    bx	    lr
    
setup:
    bl      enable_clock
    bl      configure_pins
    bl      set_led_output
loop:
    # delay to see LED outputs
    ldr r2, =265000 @ r2 gets 270000
    b L1
  L2: sub r2, r2, #1
  L1: cmp r2, #0
    bge L2
    bl set_led_output
    bl read_input
    # check if both A5 and A6 are high
    cmp r3, #0x60
    beq reset_variable

    # check if input value in A5 is high
    cmp r3, #0x20
    beq increment_variable

    # check if input value in A6 is high
    cmp r3, #0x40
    beq decrement_variable

    # if neither A5 nor A6 are high, turn off LEDs
    b loop

 reset_variable:
    mov r1, #0
    b loop

increment_variable:
    add r1, r1, #1
    cmp r1, #31
    ble loop
    b loop

decrement_variable:
    sub r1, r1, #1
    cmp r1, #0
    bge loop
    mov r1, #31
    b loop
