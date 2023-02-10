%include "/home/malware/asm/joey_lib_io_v9_release.asm"

section .data
    msg_intro: DB "List of Marks:", 0
    msg_number_nonzeros: DB "Number of non-zero marks:", 0
    msg_average: DB "The average is:", 0
    msg_remainder: DB "Remainder is: ", 0
    msg_error_allzeros: DB "All marks are 0!", 0
    
    mark1: DQ 10
    mark2: DQ 32
    mark3: DQ 34
    mark4: DQ 0
    mark5: DQ 55
    
section .text
    global main
main:
    mov rbp, rsp
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    mov rdi, DWORD msg_intro
    call print_string_new
    call print_nl_new
    
    mov rax, 0 ;rax is running total of marks
    mov rcx, 0 ;rcx is number of nonzero marks
    
    mov rbx, [mark1]
    push rax
    mov rdi, rbx
    call print_int_new
    call print_nl_new
    pop rax
    
    cmp rbx, 0
    je DontAddMark1
    add rax, rbx
    inc rcx
    DontAddMark1:

    mov rbx, [mark2]
    push rax
    mov rdi, rbx
    call print_int_new
    call print_nl_new
    pop rax
    
    cmp rbx, 0
    je DontAddMark2
    add rax, rbx
    inc rcx
    DontAddMark2:
    
    mov rbx, [mark3]
    push rax
    mov rdi, rbx
    call print_int_new
    call print_nl_new
    pop rax
    
    cmp rbx, 0
    je DontAddMark3
    add rax, rbx
    inc rcx
    DontAddMark3:
    
    mov rbx, [mark4]
    push rax
    mov rdi, rbx
    call print_int_new
    call print_nl_new
    pop rax
    
    cmp rbx, 0
    je DontAddMark4
    add rax, rbx
    inc rcx
    DontAddMark4:
    
    mov rbx, [mark5]
    push rax
    mov rdi, rbx
    call print_int_new
    call print_nl_new
    pop rax
    
    cmp rbx, 0
    je DontAddMark5
    add rax, rbx
    inc rcx
    DontAddMark5:
    
    ;check if all of the numbers are 0
    push rax
    cmp rcx, 0
    je OopsAllZeros
    
    PrintResult:
    push rax 
    
    mov rdi, DWORD msg_number_nonzeros
    call print_string_new
    call print_nl_new
    
    mov rdi, rcx
    call print_int_new
    call print_nl_new
    
    mov rdi, DWORD msg_average
    call print_string_new
    call print_nl_new
   
    ; print average
    pop rax
    mov rdx, 0 ;rax is the dividend
    div rcx ;rax is now the average, rdx is the reminder;
    
    push rax
    mov rdi, rax
    call print_int_new
    call print_nl_new 
    pop rax
    
    push rax
    mov rdi, DWORD msg_remainder
    call print_string_new
    call print_nl_new
    mov rdi, rdx
    call print_int_new
    call print_nl_new
    pop rax
    
    
    jmp finally
    
    
    OopsAllZeros:
    xor rax, rax
    xor rdx, rdx
    mov rdi, DWORD msg_number_nonzeros
    call print_string_new
    call print_nl_new
        
    
    finally:
    ; compatability
    xor rax, rax ;clear rax
    add rsp, 32
    pop rbp
    ret