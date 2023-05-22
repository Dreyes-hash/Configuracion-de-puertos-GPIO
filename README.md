# Configuracion-de-puertos-GPIO
Configuracion de puertos GPIO para Stm32 
Profesor: Dr. Adán Geovanni Medrano Chávez  
UEA: Microcontroladores
## Integrantes del equipo 
Diego Reyes Blancas - 2213026667

## Objetivo de la práctica
1. Configurar 5 puertos GPIO como salidas de forma que los LEDs conectados a estos representen el valor binario de una variable.
2. Configurar 2 puertos como entradas. Si se oprime el botón A, la variable incrementa en 1; si se oprime el botón B, la variable decrementa.
3. Al presionar los botones A y B simultáneamente, la variable se reinicia a 0.  
## hardware y software utilizados para este proyecto
1. placa de desarrollo STM32F103 BluePill
2. st-link v2
3. 5 leds
4. 5 resistencias-220 ohmios
5. 2 resistencias-10 kiloohm
6. cables dupont macho-macho y hembra-hembra
## Instalación de software de compilación para µC arm
En las distribuciones GNU/Linux, es necesario instalar algunos paquetes con el siguiente comando:
````
sudo apt install gcc-arm-none-eabi stlink-tools libusb-1.0-0-dev
````
Una vez realizada la instalación, conviene definir una serie de alias aplicados a los comando de compilación
,Si estás empleando Bash, puedes agregar en el archivo ~/.bashrc los siguientes alias:
````
alias arm-gcc=arm-none-eabi-gcc

alias arm-as=arm-none-eabi-as

alias arm-objdump=arm-none-eabi-objdump

alias arm-objcopy=arm-none-eabi-objcopy
````
## Grabación de la tarjeta de desarrollo blue pill
una vez se verifique el sistema operativo reconoce el
dispositivo, para esto se utiliza el comando 
````
lsusb en GNU/Linux o Get-PnpDevice en PowerShell
````
La salida del comando debería mostrar que el ST-Link v2 está conectado.

Conecta los pines de la blue pill con los del ST-LINK V2 usando los
cables dupont hembra-hembra según la siguiente imagen.
![TcZ4NTdLbkhnWQ](https://github.com/Dreyes-hash/Configuracion-de-puertos-GPIO/assets/126710580/29ca05e9-fc9c-45d4-b530-605128cd8f19)

para cargar el programa dentro de la tarjeta de desarrollo es necesario escribir los siguientes comandos:
````
arm-as blink.s -o blink.o
arm-objcopy -O binary blink.o blink.bin
st-flash write 'blink.bin' 0x8000000
````
## configuracion del hardware
el programa configurá los pines A0-A4 como salidas estas nos serviran para representar nuestra variable con los LEDs  y A5-A6 como salidas pull-dpown para leer nuestros botones
````
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
````
la forma en la que se configuró el hardware dentro del protoboard es la siguiente:

NOTA: el recuadro amarillo representa la placa de desarrollo y las notas dentro de la imagen, los puertos a los que va conectado el hardware
![esquema](https://github.com/Dreyes-hash/Configuracion-de-puertos-GPIO/assets/126710580/539c5162-8b5f-428c-bdc9-d9c0f4158ad6)

## funcionamiento general de la implementación
Este código de ensamblador para STM32 utiliza el conjunto de instrucciones Thumb-2 para programar un microcontrolador Cortex-M3. A continuación, se proporciona una descripción de las funciones y el flujo del programa:

1. La función `enable_clock` habilita el reloj para el puerto A. Guarda el estado de r7 en la pila y reserva espacio en la pila. Luego, carga la dirección del registro `RCC_APB2ENR` en r0 y la guarda en la pila. A continuación, carga el valor 0x04 en r3 para habilitar el reloj en el puerto A y lo guarda en la pila. Después, guarda el valor de r3 en la dirección de memoria apuntada por r0 y restaura el estado de la pila y r7.

2. La función `configure_pins` configura los pines del puerto A. Al igual que `enable_clock`, guarda el estado de r7 en la pila y reserva espacio en la pila. Luego, carga la dirección del registro `GPIOA_CRL` en r0 y la guarda en la pila. A continuación, carga el valor 0x88833333 en r3 para configurar los pines PA0-PA4 como salidas y los pines PA5-PA6 como entradas con pull-down. Guarda el valor de r3 en la pila y en la dirección de memoria apuntada por r0. Luego, restaura el estado de la pila y r7.

3. La función `set_led_output` establece la salida del LED. Al igual que las funciones anteriores, guarda el estado de r7 en la pila y reserva espacio en la pila. Luego, carga la dirección del registro `GPIOA_ODR` en r0 y la guarda en la pila. A continuación, carga el valor 0x1F en r2 como una máscara para establecer los bits de PA0-PA4. Guarda el valor de r2 en la pila y realiza una operación AND entre r1 y r2 para obtener los 5 bits menos significativos de la variable. Luego, guarda el valor de r3 en la pila y en la dirección de memoria apuntada por r0. Finalmente, restaura el estado de la pila y r7.

4. La función `read_input` lee la entrada del GPIOA. Al igual que las funciones anteriores, guarda el estado de r7 en la pila y reserva espacio en la pila. Luego, carga la dirección del registro `GPIOA_IDR` en r0 y la guarda en la pila. Lee el valor del registro `GPIOA_IDR` y lo guarda en r3. Luego, guarda el valor de r3 en la pila y realiza una operación AND entre r3 y la máscara 0x60 para obtener solo los bits 5 y 6 (PA5-PA6). Guarda el valor resultante en la pila y, finalmente, restaura el estado de la pila y r7.

5. La función `setup` llama a las funciones `enable_clock`, `configure_pins` y `set_led_output` en secuencia utilizando la instrucción `bl` (branch with link) para establecer la configuración inicial.

6. El programa principal se encuentra en el bucle `loop`. Primero, hay un retardo utilizando un contador decrementado en el registro r2. Después del retardo, se llama a las funciones `set_led




