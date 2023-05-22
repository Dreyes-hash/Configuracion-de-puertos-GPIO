# Nombre del archivo Makefile: Makefile

# Variables
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy

CFLAGS = -mcpu=cortex-m3 -mthumb -std=c99 -Wall
ASFLAGS = -mcpu=cortex-m3 -mthumb
LDFLAGS = -T linker_script.ld

# Nombre del archivo fuente ensamblador
ASM_SOURCE = blink.s

# Nombre del archivo binario generado
BIN_NAME = blink.bin

# Regla principal
all: $(BIN_NAME)

# Regla para compilar el archivo fuente ensamblador
$(BIN_NAME): $(ASM_SOURCE)
    $(AS) $(ASFLAGS) $< -o object_file.o
    $(LD) object_file.o $(LDFLAGS) -o $(BIN_NAME)
    $(OBJCOPY) -O binary $(BIN_NAME) $(BIN_NAME)

# Regla para limpiar los archivos generados
clean:
    rm -f object_file.o $(BIN_NAME)

