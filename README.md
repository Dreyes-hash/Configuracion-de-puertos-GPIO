# Configuracion-de-puertos-GPIO
Configuracion de puertos GPIO para Stm32 
Profesor: Dr. Adán Geovanni Medrano Chávez  
UEA: Microcontroladores
## Integrantes del equipo 
Diego Reyes Blancas - 2213026667

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

## Objetivo de la práctica
1. Configurar 5 puertos GPIO como salidas de forma que los LEDs conectados a estos representen el valor binario de una variable.
2. Configurar 2 puertos como entradas. Si se oprime el botón A, la variable incrementa en 1; si se oprime el botón B, la variable decrementa.
