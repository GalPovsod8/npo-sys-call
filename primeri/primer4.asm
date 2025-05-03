;
; Primer 4
; Izpis navodila in branje vnosa od uporabnika ter zapis v datoteko
;

; standardna vstopna točka
        global    _start        

; sekcija "neinicializiranih statičnih in globalnih spremenljivk"
        section .bss
buff    resb      10            ; rezerviramo 10 zlogov pomnilnika za uporabnikov vhod (reserve uninitialized memory (bytes))          
fd      resd      1             ; oprimek - rezerviramo 1 double-word oz. 4 zloge

; sekcija "inicializiranih spremenljivk"
        section   .data
filen:  db        "msg.txt", 0  ; ime datoteke
format: db        "%s", 10, 0   ; format izpisa
message:db        "Vnesi: ", 0  ; sporočilo
lengthm:db        $-message     ; dolžina sporočila

; sekcija "kode"
        section   .text
        extern dprintf          ; za izpis se bomo poslužili dprintf funkcije

        ; Izpis navodila
_start: mov       ebx, 0x01    ; standardni izhod - oprimek 1
        mov       ecx, message ; kazalec na sporočilo
        mov       edx, lengthm ; dolžina
        mov       eax, 0x04    ; številka sistemskega klica
        int       0x80         ; klic jedra

        ; Branje vnosa
        mov       eax, 0x03    ; številka sistemskega klica
        mov       ebx, 0x00    ; standardni vhod - oprimek 0
        mov       ecx, buff    ; naslov spremenljivke kamor bomo brali
        mov       edx, 10      ; število zlogov, ki jih bomo prebrali
        int       0x80         ; klic jedra

        ; Ustvarjanje datoteke
        mov       eax, 0x05     ; številka sistemskega klica
        mov       ebx, filen    ; ime datoteke
        mov       ecx, 2|64|512 ; zastavice (Linux file flags - fcntl.h) (0-O_RDONLY; 1-O_WRONLY; 2-O_RDWR; 64-O_CREATE; 512-O_TRUNC; 1024-O_APPEND)
        mov       edx, 0o777    ; dovoljenja
        int       0x80          ; klic jedra
        mov       [fd], eax     ; shranimo oprimek - [fd] - shranimo na naslov fd 

        ; Zapis v datoteko z uporabo dprintf
        push      buff         ; vsebina za zapis  
        push      format       ; formatiranje
        push      dword [fd]   ; oprimek datoteke - preberemo vrednost iz fd
        call      dprintf      ; klic dprintf(fd, "%s\n", buff)
        add       esp, 12      ; čiščenje sklada 

        ; Zapiranje datoteke
        mov       eax, 0x06    ; številka sistemskega klica
        mov       ebx, [fd]    ; oprimek datoteke
        int       0x80         ; klic jedra        

        ; Izhod iz programa
        mov       eax, 0x01     ; številka sistemskega klica za exit
        xor       ebx, ebx      ; register ebx na 0
        int       0x80          ; klic jedra - izvede se enako kot bi zapisali return 0;