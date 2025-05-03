section .data
    dir_name db "28878_Dir", 0     ; Ime imenika (null-terminated string)
    dir_mode equ 0o755             ; Pravice za imenik (rwxr-xr-x)
    
    file_name db "28878_file.dat", 0     ; Ime datoteke
    file_mode equ 0o644                  ; Privzeta dovoljenja za datoteko (rw-r--r--)

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
    ; KORAK 3: Ustvarjanje zbirke datoteke
    ; ================================
    mov eax, 5            ; syscall številka za open
    mov ebx, file_name    ; EBX = ime datoteke
    mov ecx, 0x41         ; ECX = zastavice: O_WRONLY | O_CREAT
    mov edx, file_mode    ; EDX = dovoljenja: rw-r--r--
    int 0x80              ; izvedi open
    mov esi, eax          ; shrani datotečni opisovalec v ESI

    ; ================================
    ; KORAK X: Izhod iz programa
    ; ================================
    mov eax, 1            ; syscall številka za exit
    xor ebx, ebx          ; exit code = 0
    int 0x80              ; zaključi program
