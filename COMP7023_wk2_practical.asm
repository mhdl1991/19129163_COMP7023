%include "/home/malware/asm/joey_lib_io_v9_release.asm"

section .data
    msg_thing: DB "SIGNED MULTIPLICATION OF TWO 64-BIT NUMBERS", 0
    msg_answer: DB "THE PRODUCT OF MULTIPLICATION IS ", 0
    msg_fail: DB "OVERFLOW OCCURRED", 0
    msg_succ: DB "SUCCESS", 0
section .text

global main
    
main:
    mov rbp, rsp; for correct debugging

    ; compatibility
    push rbp
    mov rbp, rsp
    sub rsp, 32

    ; We load up the message to explain stuff
    mov rdi, DWORD msg_thing
    call print_string_new
    call print_nl_new
    
    ; multiplication
    mov rax, 0xFFFFFFFFFFFFFFFF
    mov rbx, 0xFFFFFFFFFFFFFFFF
    call MULTPROC
    
    ; print out the answer
    push rax ; fucking print thing keeps overwriting my answer
    mov rdi, DWORD msg_answer
    call print_string_new
    call print_nl_new
    
    pop rdi ;pop the result off the stack
    call print_int_new
    call print_nl_new
    
    ; compatability
    add rsp, 32
    pop rbp

    ret
    
MULTPROC:
    ; Multiply time
    mul rbx
    push rax ; push the result onto the stack
    jo Overflow
    
    NoOverflow:
    mov rdi, DWORD msg_succ
    call print_string_new
    call print_nl_new
    pop rax
    jmp Finally
    
    Overflow:
    mov rdi, DWORD msg_fail
    call print_string_new
    call print_nl_new
    pop rax
    xor rax, rax ; zero out rax
    jmp Finally
    
    Finally:    
    ret