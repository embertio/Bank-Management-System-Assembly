
default rel

section .data
    menu db 10,"------ Simple Bank System ------",10
         db "1. Check Balance",10
         db "2. Deposit",10
         db "3. Withdraw",10
         db "4. Exit",10
         db "Choose option: "
    menu_len equ $-menu

    bal_prefix db 10,"Current Balance: RM "
    bal_prefix_len equ $-bal_prefix

    nl db 10
    nl_len equ 1

    deposit_text db 10,"Enter deposit amount: "
    deposit_len equ $-deposit_text

    withdraw_text db 10,"Enter withdraw amount: "
    withdraw_len equ $-withdraw_text

    invalid_opt db 10,"Invalid option! Please choose 1-4.",10
    invalid_opt_len equ $-invalid_opt

    invalid_amt db 10,"Invalid amount! Enter digits only (e.g., 50).",10
    invalid_amt_len equ $-invalid_amt

    insufficient db 10,"Insufficient funds!",10
    insufficient_len equ $-insufficient

    success db 10,"Transaction successful!",10
    success_len equ $-success

    exit_msg db "Thank you for using the Banking System!",10
    exit_len equ $ -exit_msg

section .bss
    balance  resq 1
    inbuf    resb 64
    numbuf   resb 32

section .text
global _start

print_str:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

read_line:
    mov rax, 0
    mov rdi, 0
    syscall
    ret

parse_uint:
    xor rax, rax
    xor rcx, rcx

.parse_loop:
    mov bl, byte [rsi]
    cmp bl, 10
    je .done
    cmp bl, 13
    je .done
    cmp bl, 0
    je .done
    cmp bl, '0'
    jb .bad
    cmp bl, '9'
    ja .bad
    imul rax, rax, 10
    movzx rdx, bl
    sub rdx, '0'
    add rax, rdx
    inc rcx
    inc rsi
    jmp .parse_loop

.done:
    cmp rcx, 0
    je .bad
    clc
    ret

.bad:
    stc
    ret

print_uint:
    lea rsi, [numbuf + 31]
    mov byte [rsi], 0
    mov rbx, 10
    cmp rax, 0
    jne .convert
    dec rsi
    mov byte [rsi], '0'
    jmp .emit

.convert:
.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rsi
    mov byte [rsi], dl
    cmp rax, 0
    jne .loop

.emit:
    lea rdx, [numbuf + 31]
    sub rdx, rsi
    call print_str
    ret

_start:
    mov qword [balance], 100

menu_loop:
    mov rsi, menu
    mov rdx, menu_len
    call print_str

    mov rsi, inbuf
    mov rdx, 64
    call read_line

    mov al, byte [inbuf]
    cmp al, '1'
    je check_balance
    cmp al, '2'
    je do_deposit
    cmp al, '3'
    je do_withdraw
    cmp al, '4'
    je exit_program

    mov rsi, invalid_opt
    mov rdx, invalid_opt_len
    call print_str
    jmp menu_loop

check_balance:
    mov rsi, bal_prefix
    mov rdx, bal_prefix_len
    call print_str
    mov rax, [balance]
    call print_uint
    mov rsi, nl
    mov rdx, nl_len
    call print_str
    jmp menu_loop

do_deposit:
    mov rsi, deposit_text
    mov rdx, deposit_len
    call print_str

    mov rsi, inbuf
    mov rdx, 64
    call read_line

    mov rsi, inbuf
    call parse_uint
    jc .bad_amount

    mov rbx, [balance]
    add rbx, rax
    mov [balance], rbx

    mov rsi, success
    mov rdx, success_len
    call print_str
    jmp menu_loop

.bad_amount:
    mov rsi, invalid_amt
    mov rdx, invalid_amt_len
    call print_str
    jmp do_deposit

do_withdraw:
    mov rsi, withdraw_text
    mov rdx, withdraw_len
    call print_str

    mov rsi, inbuf
    mov rdx, 64
    call read_line

    mov rsi, inbuf
    call parse_uint
    jc .bad_amount_w

    mov rbx, [balance]
    cmp rax, rbx
    ja .insufficient

    sub rbx, rax
    mov [balance], rbx

    mov rsi, success
    mov rdx, success_len
    call print_str
    jmp menu_loop

.bad_amount_w:
    mov rsi, invalid_amt
    mov rdx, invalid_amt_len
    call print_str
    jmp do_withdraw

.insufficient:
    mov rsi, insufficient
    mov rdx, insufficient_len
    call print_str
    jmp menu_loop

exit_program:
    mov rax, 1
    mov rdi, 1
    mov rsi, exit_msg
    mov rdx, exit_len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
