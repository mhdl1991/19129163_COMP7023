; hello.asm
; Linux, Intel, gcc Hello World program
; assemble: nasm -g -f elf64 -o hello.o hello.asm
; link: gcc hello.o -no-pie -o hello
; run: ./hello

section .data ;data section
	msg: db"Hello World",10 ;the string. db is define byte
	len: equ $-msg ;size of the string

section .text
        global main
        main:
        mov rdx, len
        mov rcx, msg
        mov rbx, 1 ;arg1 where to write, screen
        mov rax, 4 ;write sysout command to int 80 hex (call kernel)
        int 0x80 ;interrupt 80 hex (Call kernel)

