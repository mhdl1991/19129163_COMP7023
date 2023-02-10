; Conditional branching in assembly
; Joe Norton, September 2021

%include "/home/malware/asm/joey_lib_io_v9_release.asm"

global main

section .data
     took_branch db "We took the branch.", 0
     did_not_branch db "We did NOT take the branch.", 0

section .text

main:    
    mov rbp, rsp; for correct debugging
    push rbp    ; this is just
    mov rbp, rsp; setting up the
    sub rsp, 32 ; stack frame 
    
  test_case_1:  ; these are labels
    mov rax, 1
    mov rbx, 1
    cmp rax, rbx
    je jump_1                   ;jump if equal
    mov rdi, did_not_branch
    call print_string_new
    call print_nl_new
    jmp test_case_2
  jump_1:
    mov rdi, took_branch
    call print_string_new
    call print_nl_new
    
  test_case_2:
    mov rax, 5
    mov rbx, 7
    cmp rax, rbx
    je jump_2                   ;jump if equal
    mov rdi, did_not_branch
    call print_string_new
    call print_nl_new
    jmp test_case_3
  jump_2:
    mov rdi, took_branch
    call print_string_new
    call print_nl_new
    
  test_case_3:
    mov rax, 5
    mov rbx, 7
    cmp rax, rbx
    jl jump_3                   ;jump if less than
    mov rdi, did_not_branch
    call print_string_new
    call print_nl_new
    jmp test_case_4
  jump_3:
    mov rdi, took_branch
    call print_string_new
    call print_nl_new
    
  test_case_4:
    mov al, 0xff ;255 decimal
    mov bl, 0x10 ;16 decimal
    add al, bl
    jc jump_4        ; jump if carry
    mov rdi, did_not_branch
    call print_string_new
    call print_nl_new
    jmp test_case_5
  jump_4:
    mov rdi, took_branch
    call print_string_new
    call print_nl_new
    
  test_case_5:
    mov al, 0x20 ;32 decimal
    mov bl, 0x10 ;16 decimal
    add al, bl
    jc jump_5        ; jump if carry
    mov rdi, did_not_branch
    call print_string_new
    call print_nl_new
    jmp test_case_6
  jump_5:
    mov rdi, took_branch
    call print_string_new
    call print_nl_new
    
  test_case_6:
    mov al, 0x20 ;32 decimal
    mov bl, 0x10 ;16 decimal
    add al, bl
    jnc jump_6        ; jump if NO carry
    mov rdi, did_not_branch
    call print_string_new
    call print_nl_new
    jmp that_is_all
  jump_6:
    mov rdi, took_branch
    call print_string_new
    call print_nl_new
    
  that_is_all:
    
    xor rax, rax ; return zero
    
    add rsp, 32 ; undoing the
    pop rbp     ; stack frame
    
    
    
    ret
