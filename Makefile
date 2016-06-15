ARMGNU = arm-none-eabi

CPU = -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
COPS = -nostartfiles -lm -specs=nosys.specs
COPTS = -Os

STM32 = ./stm32f4
BUILD_DIR = ./build
DUKTAPE_DIR = ./third-party/duktape
EXAMPLES_DIR = ./examples
OBJ = $(BUILD_DIR)/obj
BIN = $(BUILD_DIR)/bin

all: $(BIN)/firmware.bin

$(OBJ)/startup_stm32f4xx.o: $(STM32)/startup_stm32f4xx.s
	mkdir -p $(OBJ)
	$(ARMGNU)-as $(STM32)/startup_stm32f4xx.s -o $(OBJ)/startup_stm32f4xx.o

$(OBJ)/main.o: $(EXAMPLES_DIR)/main.c
	$(ARMGNU)-gcc $(COPS) $(CPU) $(COPTS) -c $(EXAMPLES_DIR)/main.c -o $(OBJ)/main.o

$(OBJ)/duktape.o: $(DUKTAPE_DIR)/duktape.c
	$(ARMGNU)-gcc $(COPS) $(CPU) $(COPTS) -c $(DUKTAPE_DIR)/duktape.c -o $(OBJ)/duktape.o

$(BIN)/firmware.bin: $(STM32)/stm32_flash.ld $(OBJ)/startup_stm32f4xx.o $(OBJ)/main.o $(OBJ)/duktape.o
	mkdir -p $(BIN)
	$(ARMGNU)-gcc $(COPS) $(CPU) -T $(STM32)/stm32_flash.ld $(OBJ)/startup_stm32f4xx.o $(OBJ)/main.o $(OBJ)/duktape.o -o $(BIN)/firmware.elf
	$(ARMGNU)-objdump -D $(BIN)/firmware.elf > $(BIN)/firmware.list
	$(ARMGNU)-objcopy $(BIN)/firmware.elf $(BIN)/firmware.bin -O binary

clean_bin:
	rm -f $(BIN)/*.elf
	rm -f $(BIN)/*.bin

clean:
	rm -f $(OBJ)/*.o
	rm -f $(BIN)/*.elf
	rm -f $(BIN)/*.bin