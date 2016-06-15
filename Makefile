ARMGNU = arm-none-eabi

COPS = -Wall -Os -nostdlib -nostartfiles -ffreestanding -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
THIRD_PARTY = ./third-party
DUKTAPE = $(THIRD_PARTY)/duktape
STM32 = ./stm32f4
BIN = ./bin

all: $(BIN)/firmware2.bin

$(BIN)/firmware2.bin: $(STM32)/vectors.s $(STM32)/main.c $(DUKTAPE)/duktape.c
	# $(ARMGNU)-gcc -nostdlib -fno-math-errno --specs=rdimon.specs -mcpu=cortex-m4 -mthumb -mlittle-endian -mfloat-abi=soft -mthumb-interwork -Os -T $(STM32)/stm32_flash.ld $^ -o $@
	$(ARMGNU)-gcc -Wall -D DUK_OPT_NO_FILE_IO -nostdlib -nostartfiles -ffreestanding -mcpu=cortex-m4 -mthumb -Os -T $(STM32)/stm32_flash.ld $^ -o $@



$(STM32)/vectors.o: $(STM32)/vectors.s
	$(ARMGNU)-as $(STM32)/vectors.s -o $(STM32)/vectors.o

$(DUKTAPE)/duktape.o: $(DUKTAPE)/duktape.c
	$(ARMGNU)-gcc $(COPS) -Os -pedantic -std=c99 -Wall -fstrict-aliasing -fomit-frame-pointer -c $(DUKTAPE)/duktape.c -o $(DUKTAPE)/duktape.o -lm
#	$(ARMGNU)-gcc -pedantic -std=c99 -Wall -fstrict-aliasing -fomit-frame-pointer -c $(DUKTAPE)/duktape.c -lm -o $(DUKTAPE)/duktape.o
	# $(ARMGNU)-gcc -o $@ -lm -DDUK_OPT_SELF_TESTS $(COPS) -pedantic -std=c99 -fstrict-aliasing -fomit-frame-pointer -I./src -Imath.h -c $(DUKTAPE)/duktape.c -lm
#	gcc -o $@ -DDUK_OPT_SELF_TESTS -Os -pedantic -std=c99 -Wall -fstrict-aliasing -fomit-frame-pointer -I./src $(DUKTAPE)/duktape.c -lm

$(STM32)/main.o: $(STM32)/main.c
	$(ARMGNU)-gcc $(COPS) -c $(STM32)/main.c -o $(STM32)/main.o -lm

$(BIN)/firmware.bin: $(STM32)/memmap $(STM32)/vectors.o $(STM32)/main.o $(DUKTAPE)/duktape.o
	$(ARMGNU)-gcc -nostartfiles -o $(BIN)/firmware.elf -T $(STM32)/memmap $(STM32)/vectors.o $(STM32)/main.o $(DUKTAPE)/duktape.o -lm
	# $(ARMGNU)-gcc -o $(BIN)/firmware.elf $(STM32)/vectors.o $(STM32)/main.o -lm
	$(ARMGNU)-objdump -D $(BIN)/firmware.elf > $(BIN)/firmware.list
	$(ARMGNU)-objcopy $(BIN)/firmware.elf $(BIN)/firmware.bin -O binary

clean_bin:
	rm -f $(BIN)/*.elf
	rm -f $(BIN)/*.bin

clean:
	rm -f $(STM32)/*.o
	rm -f $(DUKTAPE)/*.o
	rm -f $(BIN)/*.elf
	rm -f $(BIN)/*.bin