section .data
    dir_name db "28878_Dir", 0     ; Ime imenika (null-terminated string)
    dir_mode equ 0o755             ; Pravice za imenik (rwxr-xr-x)

section .text
    global _start

_start:
    ; ================================
    ; KORAK 1: Ustvarjanje imenika
    ; ================================
    mov eax, 39           ; syscall številka za mkdir
    mov ebx, dir_name     ; EBX = kazalec na ime imenika
    mov ecx, dir_mode     ; ECX = dovoljenja (rwxr-xr-x)
    int 0x80              ; izvedi sistemski klic (mkdir)

    ; ================================
    ; KORAK 2: Premik v ustvarjeni imenik
    ; ================================
    mov eax, 12           ; syscall številka za chdir
    mov ebx, dir_name     ; EBX = kazalec na ime imenika
    int 0x80              ; izvedi sistemski klic (chdir)

    ; ================================
    ; KORAK X: Izhod iz programa
    ; ================================
    mov eax, 1            ; syscall številka za exit
    xor ebx, ebx          ; exit code = 0
    int 0x80              ; zaključi program
