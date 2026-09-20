.intel_syntax noprefix

.global itoa
.global atoi
.global _start

_start:
cmp qword ptr [rsp],4
je foarg
cmp qword ptr [rsp],3
je toarg
call dec

toarg:
mov r15, qword ptr [rsp+16]
cmp byte ptr [r15],'-'
je negator
cmp byte ptr [r15], '~'
je prox
call dec

foarg:
mov r15,qword ptr [rsp+24]
cmp byte ptr [r15],'+'
je addit
cmp byte ptr [r15],'*'
je mult
cmp byte ptr [r15],'&'
je an
cmp byte ptr [r15],'|'
je orz
cmp byte ptr [r15],'^'
je xo
cmp byte ptr [r15],'-'
jne dec
mov rdi,qword ptr [rsp+16]
call atoi
mov r13,rax
mov rdi,qword ptr [rsp+32]
call atoi
mov r14,rax
sub r13,r14
mov rdi,r13
sub rsp, 32
mov rsi, rsp
mov r14,rsi
call itoa
mov rsi,r14
call wr
call ex

dec:
mov rax,60
mov rdi,2
syscall

wr:
mov rdx,rax
mov rdi,1
mov rax,1
syscall
ret
ex:
mov rax,60
mov rdi,0
syscall
ret

itoa:
    xor r8, r8
    xor r9, r9
    xor r10, r10
    xor rdx, rdx
    xor rcx, rcx
    mov rax, rdi
    cmp rax, 0
    je zero
    mov r9, 1
    cmp rax, 0
    jl negate
    call loop
    ret

negate:
    neg rax
    mov byte ptr [rsi], '-'
    mov r10, 1
    call loop
    ret

zero:
    mov byte ptr [rsi], '0'
    mov rax, 1
    ret

loop:
    xor rdx, rdx
    mov rcx, 10
    div rcx
    push rdx
    cmp rax, 0
    je prntr
    inc r9
    jmp loop

prntr:
    xor r8, r8
cmp r10,1
jne prnt
inc rsi

prnt:
    pop rax
    add al, '0'
    mov byte ptr [rsi + r8], al
    inc r8
    cmp r8, r9
    jne prnt
    mov rax, r9
    add rax, r10
    ret

atoi:
    xor rdx, rdx
    cmp byte ptr [rdi], '-'
    je rem
    call atoi_f
    ret

rem:
    inc rdi
    call atoi_f
    neg rax
    ret

atoi_f:
    cmp byte ptr [rdi], '9'
    ja don
    cmp byte ptr [rdi], '0'
    jb don
    call atoi_digit
    imul rdx, 10
    add rdx, rax
    inc rdi
    call atoi_f
    ret

don:
    mov rax, rdx
    ret

atoi_digit:
    movsx rax, byte ptr [rdi]
    sub rax, 48
    ret

addit:
mov rdi,qword ptr [rsp+16]
call atoi
mov r13,rax
mov rdi,qword ptr [rsp+32]
call atoi
mov r14,rax
add r13,r14
mov rdi,r13
sub rsp, 32
mov rsi, rsp
call itoa
call wr
call ex

mult:
mov rdi,qword ptr [rsp+16]
call atoi
mov r13,rax
mov rdi,qword ptr [rsp+32]
call atoi
mov r14,rax
imul r13,r14
mov rdi,r13
sub rsp, 32
mov rsi, rsp
call itoa
call wr
call ex

an:
mov rdi,qword ptr [rsp+16]
call atoi
mov r13,rax
mov rdi,qword ptr [rsp+32]
call atoi
mov r14,rax
and r13,r14
mov rdi,r13
sub rsp, 32
mov rsi, rsp
call itoa
call wr
call ex

orz:
mov rdi,qword ptr [rsp+16]
call atoi
mov r13,rax
mov rdi,qword ptr [rsp+32]
call atoi
mov r14,rax
or r13,r14
mov rdi,r13
sub rsp, 32
mov rsi, rsp
call itoa
call wr
call ex

xo:
mov rdi,qword ptr [rsp+16]
call atoi
mov r13,rax
mov rdi,qword ptr [rsp+32]
call atoi
mov r14,rax
xor r13,r14
mov rdi,r13
sub rsp, 32
mov rsi, rsp
call itoa
call wr
call ex

negator:
mov rdi,qword ptr [rsp+24]
call atoi
mov r13,rax
neg r13
mov rdi,r13
sub rsp,32
mov rsi,rsp
mov r14,rsi
call itoa
mov rsi,r14
call wr
call ex

prox:
mov rdi,qword ptr [rsp+24]
call atoi
mov r13,rax
not r13
mov rdi,r13
sub rsp,32
mov rsi,rsp
mov r14,rsi
call itoa
mov rsi,r14
call wr
call ex
