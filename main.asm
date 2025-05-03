section .data
    dir_name db "28878_Dir", 0           ; Ime imenika (null-terminated string)
    dir_mode equ 0o755                   ; Pravice za imenik (rwxr-xr-x)

    file_name db "28878_file.dat", 0     ; Ime datoteke
    file_mode equ 0o644                  ; Za open syscall (privzete pravice ob ustvarjanju)
    new_file_mode equ 0o640              ; Za chmod: rw-r-----

section .text
    global _start

_start:
    ; ================================
    ; KORAK 1: Ustvarjanje imenika
    ; ================================
    mov eax, 39           ; syscall: mkdir
    mov ebx, dir_name
    mov ecx, dir_mode
    int 0x80

    ; ================================
    ; KORAK 2: Premik v imenik
    ; ================================
    mov eax, 12           ; syscall: chdir
    mov ebx, dir_name
    int 0x80

    ; ================================
    ; KORAK 3: Ustvarjanje datoteke
    ; ================================
    mov eax, 5            ; syscall: open
    mov ebx, file_name
    mov ecx, 0x41         ; O_WRONLY | O_CREAT
    mov edx, file_mode    ; Začetne pravice 
    int 0x80
    mov esi, eax          ; Shrani file descriptor v ESI

    ; ================================
    ; KORAK 4: Spreminjanje pravic z chmod
    ; ================================
    mov eax, 15           ; syscall: chmod
    mov ebx, file_name    ; kazalec na ime datoteke
    mov ecx, new_file_mode
    int 0x80

    ; ================================
    ; KORAK X: Izhod iz programa
    ; ================================
    mov eax, 1
    xor ebx, ebx
    int 0x80
