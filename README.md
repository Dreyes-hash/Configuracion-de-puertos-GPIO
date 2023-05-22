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
el programa configura los pines A0-A4 como salidas estas nos serviran para representar nuestra variable con los LEDs  y A5-A6 como salidas pull-dpown para leer nuestros botones
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
la forma en la que se configuro el hardware dentro del protoboard es la siguiente:
NOTA: el recuadro amarillo representa la placa de desarrollo y las notas dentro de la imagen, los puertos a los que va conectado el hardware
![esquema](https://github.com/Dreyes-hash/Configuracion-de-puertos-GPIO/assets/126710580/539c5162-8b5f-428c-bdc9-d9c0f4158ad6)


