;
; Primer 5
; Branje PID x64
;

; Kako je s sistemskimi klici na 64-bitni arhitekturi

; Sistemski klic se izvede s syscall inštrukcijo
; Registri imajo predpono r (pri 32-bitni arh. je predpona e)
; Po klicu jedro uniči registra rcx in r11
; Register rax vsebuje rezultat sistemskega klica

; standardna vstopna točka
        global    _start

; sekcija "inicializiranih spremenljivk"
        section   .data
format: db        "PID: %d", 10, 0 ; format izpisa

; sekcija "kode"
        section   .text
        extern printf           ; za izpis se bomo poslužili printf funkcije

        ; Branje PID
_start: mov       rax, 0x27     ; številka sistemskega klica
        syscall                 ; klic jedra - rezultat se po klicu vedno shrani v register eax
        
        ; Izpis - v x64 se argumenti prenašajo preko registrov - ni cdecl načina (preko sklada)
        ; Prenese se prvih 6 parametrov po vrsti (RDI, RSI, RDX, RCX, R8 in R9)
        ; Ker printf prejema variablilno število parametrov (variadic function) moramo pred klicem register rax nastaviti na 0
        mov       rdi, format   ; format izpisa
        mov       rsi, rax      ; PID
        xor       rax, rax      ; nastavimo rax register na 0
        call      printf        ; pokličemo funkcijo printf

        ; Izhod iz programa
        mov       rax, 0x3c     ; številka sistemskega klica za exit
        xor       rdi, rdi      ; register rdi na 0
        syscall                 ; klic jedra - izvede se enako kot bi zapisali return 0;