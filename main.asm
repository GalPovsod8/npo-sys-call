section   .data
    dir_name db "28878_Dir", 0        ; Ime imenika (null-terminated)
    dir_mode equ 0o755                ; Dovoljenja za imenik (rwxr-xr-x)   

section   .text
    global_start

_start:
    mov eax, 39           ; syscall številka za mkdir
    mov ebx, dir_name     ; kazalec na ime imenika
    mov ecx, dir_mode     ; pravice za dostop
    int 0x80              ; pokliči sistemski klic

    ; Končaj program
    mov eax, 1            ; syscall številka za exit
    xor ebx, ebx          ; status = 0
    int 0x80