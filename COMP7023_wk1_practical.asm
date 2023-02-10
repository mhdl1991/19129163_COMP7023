; COMP7023 Week 1 Practical
; Assemble: nasm -g -f elf64 -o <filename.o> <filename.asm>
; Link: ﻿gcc <filename.o> -no-pie -o <filename>

%include "/home/malware/asm/joey_lib_io_v9_release.asm"
global main

section .text    
    main:
    mov rbp, rsp; for correct debugging
        ;New stack
        push rbp 
        mov rbp, rsp
        sub rsp, 32
        
        mov rax, 12 ;num1
        mov rbx, 14 ;num2
        add rax, rbx        
        mov rdi, rax
        
        call print_int_new
        call print_nl_new
        
        ;Return stack
        add rsp, 32
        pop rbp
        ret