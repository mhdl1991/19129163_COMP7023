; Hello World
; Assemble: nasm -g -f elf64 -o <filename.o> <filename.asm>
; Link: ﻿gcc <filename.o> -no-pie -o <filename>

%include "/home/malware/asm/joey_lib_io_v9_release.asm"
global main

section .data
    ;a message to print when we enter main
    ;db stands for define bytes and the 0 at the end is the null terminator,
    ;so print_string knows when the string ends
    str_name: db"My name is: Mohammad Ali Khan",0
    str_id: db"My ID: 19129163",0
    str_uni: db"University: Oxford Brookes University",0


section .text
    main:
        ;set up a new stack frame, first save the old stack base pointer by pushing it
	push rbp
	
	;then slide the base of the stack down to RSP by moving RSP into RBP
	mov rbp, rsp

	;Windows requires a minimum of 32 bytes on the stack before calling any other functions
	;so this is for compatibility, its perfectly valid on Linux and Mac also
	sub rsp, 32

        ;Print variables to screen
        mov rdi, QWORD str_name
        call print_string_new
        call print_nl_new
        
        mov rdi, QWORD str_id
        call print_string_new
        call print_nl_new
        
        mov rdi, QWORD str_uni
        call print_string_new
        call print_nl_new

	;restore the stack frame of the function that called this function
	;first add back the amount that we subtracted from RSP
	;including any additional subtractions we made to RSP after the initial one (just sum them)
	add	rsp, 32
	
	;after we add what we subtracted back to RSP, the value of RBP we pushed is the only thing left
	;so we pop it back into RBP to restore the stack base pointer
	pop	rbp
	
	ret
