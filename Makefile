SRC = main.asm
OUT = sys_calls

all: build run

build:
	nasm -f elf32 $(SRC) -o main.o
	ld -m elf_i386 main.o -o $(OUT)

run:
	./$(OUT)

clean:
	@rm -f main.o $(OUT) || true
