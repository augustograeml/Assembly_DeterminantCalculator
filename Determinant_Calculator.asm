section .data
    hello: db "Informe os elementos da matriz 2x2 para calcular o determinante:", 10 ;string to print
    helloLen: equ $-hello   ;length of string
    hello_1: db "O determinante eh:", 10 ;string to print
    helloLen_1: equ $-hello_1   ;length of string
    tamMat: equ 5           ; tamanho suficiente para ler até 2 dígitos e o sinal
    tamDet: equ 5           ; tamanho suficiente para imprimir o determinante com sinal
    ;constants

section .bss 
    m1 resb tamMat
    m2 resb tamMat
    m3 resb tamMat
    m4 resb tamMat
    det resb tamDet

section .text
    global _start           

    _start:

    ;print "Informe os elementos da matriz 2x2 para calcular o determinante:"
    mov     rax, 1      ; sys_write
    mov     rdi, 1      ; stdout
    mov     rsi, hello
    mov     rdx, helloLen
    syscall

    ;lendo o primeiro valor
    mov     rax, 0      ; sys_read
    mov     rdi, 0      ; stdin
    lea     rsi, [m1]   ; endereço do buffer m1
    mov     rdx, tamMat ; máximo de bytes a ser lido
    syscall

    ;lendo o segundo valor
    mov     rax, 0      ; sys_read
    mov     rdi, 0      ; stdin
    lea     rsi, [m2]   ; endereço do buffer m2
    mov     rdx, tamMat ; máximo de bytes a ser lido
    syscall

    ;lendo o terceiro valor
    mov     rax, 0      ; sys_read
    mov     rdi, 0      ; stdin
    lea     rsi, [m3]   ; endereço do buffer m3
    mov     rdx, tamMat ; máximo de bytes a ser lido
    syscall

    ;lendo o quarto valor
    mov     rax, 0      ; sys_read
    mov     rdi, 0      ; stdin
    lea     rsi, [m4]   ; endereço do buffer m4
    mov     rdx, tamMat ; máximo de bytes a ser lido
    syscall
    
    ; Convertendo ASCII para inteiro

    ; Convertendo m1 para inteiro
    movzx   eax, byte [m1]  ; Move o primeiro byte de m1 para eax
    sub     eax, '0'        ; Converte de ASCII para inteiro
    mov     [m1], al        ; Armazena o valor convertido de volta em m1

    ; Convertendo m2 para inteiro
    movzx   eax, byte [m2]  ; Move o primeiro byte de m2 para eax
    sub     eax, '0'        ; Converte de ASCII para inteiro
    mov     [m2], al        ; Armazena o valor convertido de volta em m2

    ; Convertendo m3 para inteiro
    movzx   eax, byte [m3]  ; Move o primeiro byte de m3 para eax
    sub     eax, '0'        ; Converte de ASCII para inteiro
    mov     [m3], al        ; Armazena o valor convertido de volta em m3

    ; Convertendo m4 para inteiro
    movzx   eax, byte [m4]  ; Move o primeiro byte de m4 para eax
    sub     eax, '0'        ; Converte de ASCII para inteiro
    mov     [m4], al        ; Armazena o valor convertido de volta em m4

        ; Calculando o determinante
    mov     al, [m1]        ; Move m1 para al
    mov     bl, [m4]        ; Move m4 para bl
    imul    ax, bx          ; Calcula m1 * m4
    mov     [det], ax       ; Armazena o resultado em det

    mov     al, [m2]        ; Move m2 para al
    mov     bl, [m3]        ; Move m3 para bl
    imul    ax, bx          ; Calcula m2 * m3
    sub     [det], ax       ; Subtrai de det

    ; Converte o determinante de inteiro para string para imprimir
    mov     rsi, det        ; Endereço da string do determinante
    mov     rax, [det]      ; Move det para rax
    mov     rbx, 10         ; Divisor para conversão decimal
    xor     rcx, rcx        ; Contador para o número de dígitos

convert_loop:
    xor     rdx, rdx        ; Limpa rdx antes da divisão
    div     rbx             ; Divide rax por 10, resultado em rax, resto em rdx
    add     dl, '0'         ; Converte o resto para ASCII
    push    rdx             ; Empilha o dígito convertido
    inc     rcx             ; Incrementa o contador de dígitos
    test    rax, rax        ; Checa se rax é zero
    jnz     convert_loop    ; Se não, continua o loop

print_loop:
    dec     rcx             ; Decrementa o contador de dígitos
    pop     rax             ; Desempilha o dígito
    mov     [rsi], al       ; Move o dígito para a string
    inc     rsi             ; Incrementa o ponteiro da string
    test    rcx, rcx        ; Checa se ainda há dígitos
    jnz     print_loop      ; Se sim, continua o loop

    ; Adiciona o caractere de nova linha e terminador nulo
    mov     byte [rsi], 10  ; Nova linha
    inc     rsi             ; Incrementa o ponteiro da string
    mov     byte [rsi], 0   ; Terminador nulo

    ;O determinante eh:"
    mov     rax, 1      ; sys_write
    mov     rdi, 1      ; stdout
    mov     rsi, hello_1
    mov     rdx, helloLen_1
    syscall


    ; Imprime o determinante
    mov     rax, 1          ; sys_write
    mov     rdi, 1          ; stdout
    mov     rsi, det        ; Endereço da string do determinante
    mov     rdx, tamDet     ; Número de bytes a serem escritos
    syscall

    ;exit
    mov     rax, 60     ; sys_exit
    xor     rdi, rdi    ; Status 0
    syscall