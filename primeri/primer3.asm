;
; Primer 3
; Izpis navodila in branje vnosa od uporabnika ter izpis
;

; standardna vstopna točka
        global    _start        

; sekcija "neinicializiranih statičnih in globalnih spremenljivk"
        section .bss
buffrea resb      10            ; rezerviramo 10 zlogov pomnilnika za uporabnikov vhod (reserve uninitialized memory (bytes))          

; sekcija "inicializiranih spremenljivk"
        section   .data
message:db        "Vnesi: ", 0  ; sporočilo
lengthm:db        $-message     ; dolžina sporočila

; sekcija "kode"
        section   .text

        ; Izpis navodila
_start: mov       ebx, 0x01    ; standardni izhod - oprimek 1
        mov       ecx, message ; kazalec na sporočilo
        mov       edx, lengthm ; dolžina
        mov       eax, 0x04    ; številka sistemskega klica
        int       0x80         ; klic jedra

        ; Branje vnosa
        mov       eax, 0x03    ; številka sistemskega klica
        mov       ebx, 0x00    ; standardni vhod - oprimek 0
        mov       ecx, buffrea ; naslov spremenljivke kamor bomo brali
        mov       edx, 10      ; število zlogov, ki jih bomo prebrali
        int       0x80         ; klic jedra

        ; Izpis prebrane vrednosti
        mov       eax, 0x04    ; številka sistemskega klica
        mov       ebx, 0x01    ; standardni izhod - oprimek 1
        mov       ecx, buffrea ; naslov spremenljivke
        mov       edx, 10      ; število zlogov, ki jih bomo izpisali
        int       0x80         ; klic jedra
                                  
        ; Izhod iz programa
        mov       eax, 0x01     ; številka sistemskega klica za exit
        xor       ebx, ebx      ; register ebx na 0
        int       0x80          ; klic jedra - izvede se enako kot bi zapisali return 0;