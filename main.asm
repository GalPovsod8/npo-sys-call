; Sistemski klic je vmesnik (interface) med aplikacijo v uporabniškem prostoru in storitvijo, ki jo nudi jedro.
; Ker je storitev zagotovljena znotraj jedra, direktni klic ni mogoč.
; Zato moramo uporabiti postopek, s katerim preidemo mejo med uporabniškim prostorom in jedrom

; Postopek se razlikuje glede na arhitekturo, zato se bomo trenutno omejili na x86-32.

; Sistemski skic se jedru pošlje preko ene vstopne točke
; Postopek začnemo z zapisom številke sistemskega klica v register eax
; Nadaljujemo z vzbujanjem programske prekinitve (interrupt 0x80)

;
; Primer 1
; Izpis besedila na standardni izhod
;

; Sistemski klic s parametri
; Parametre sistemskega klica nastavimo preko splošno namenskih registrov
; ebx, ecx, edx, esi, edi, ebp
; Kako?: https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#x86-32_bit

; Izpišimo informacijo uporabniku
; write(1, output, 6);

; standardna vstopna točka
        global    _start

; sekcija "inicializiranih spremenljivk" - obstajajo v času prevajanja ali izvajaja?
        section   .data
message:db        "Zdravo", 10 ; sporočilo za izpis uporabniku z znakom za novo vrstico (db - define byte)
length: equ       $-message    ; dolžina sporočila ($ predstavlja trenutni naslov in $- izračuna dolžino sporočila) (equ - equate) - #define ali const

; sekcija "kode"
        section   .text

        ; Izpis na standardni izhod
_start: mov       ebx, 0x01    ; standardni izhod - oprimek 1 - zakaj ebx?
        mov       ecx, message ; kazalec na sporočilo - zakaj ecx?
        mov       edx, length  ; dolžina - zakaj edx?
        mov       eax, 0x04    ; številka sistemskega klica - zakaj eax in 4?
        int       0x80         ; klic jedra

        ; Izhod iz programa
        mov       eax, 0x01    ; številka sistemskega klica za exit
        xor       ebx, ebx     ; register ebx na 0
        int       0x80         ; klic jedra - izvede se enako kot bi zapisali return 0;

        ; Zakaj operacija "xor ebx, ebx"? Zakaj ne "mov ebx, 0"
        ; Način z xor je hitrejši, ker ne vsebuje nalaganja vrednosti iz pomnilnika
        ; Intelov priporočen način "čiščenja" registrov
        ; gcc v procesu optimizacije (vsaj -O1; -O0 uporabi mov operacijo) uvede takšen način "čiščenja" registrov

; Kako poiščemo kaj pomenijo parametri?
; Več o tem: https://man7.org/linux/man-pages/man2/write.2.html