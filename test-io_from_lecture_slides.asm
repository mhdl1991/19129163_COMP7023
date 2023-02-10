; Test programme for io

; Build with the build script, or:

; To build: 
; nasm -g -f elf64 -o test-io_from_lecture_slides.o test-io_from_lecture_slides.asm

; To link:
; gcc test-io_from_lecture_slides.o /usr/lib/libasm_io.a -no-pie -o test-io_from_lecture_slides
; (Manually pointing the linker to "libasm_io.a" archive file.)
; or
; gcc test-io_from_lecture_slides.o -lasm_io -no-pie -o test-io_from_lecture_slides
; (Using the "-lasm_io" switch.)

; You'll need to point this to your version of the IO library
; the %include path is an absolute path - change this if you want

%include "/home/malware/asm/joey_lib_io_v9_release.asm"

global main

section .data
 	echo_request:	db	"Please enter a number: ",0
 	echo_number: 	db	"The number you entered was:",0
 	echo_bye:	db	"Goodbye!",0

section .text

main:
    mov rbp, rsp; for correct debugging
    ; We have these three lines for compatability only
    push rbp
    mov rbp, rsp
    sub rsp,32

    ; We load up the message to ask for a number
    mov rdi, DWORD echo_request
    call print_string_new
    ; we read in an int
    call read_int_new
    push rax		; we save the int for safeties sake

    ; we print out our message
    mov rdi, DWORD echo_number
    call print_string_new
    call print_nl_new

    ; we copy back the int we saved and print it
    pop rdi
    call print_int_new
    call print_nl_new

    ; we print our goodbye message
    mov rdi, QWORD echo_bye
    call print_string_new
    call print_nl_new

    ; and these lines are for compatability
    add rsp, 32
    pop rbp

    ret