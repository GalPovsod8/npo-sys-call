;
; Primer 2
; Branje PID
;

; Pridobimo PID na različne načine

; Z uporabo C-knjižnice - wrapped
; int pid = (int) getpid(); 
; printf("PID procesa (getpid): %d\n", pid); 

; Z uporabo direktnega sistemskega klica
; int pid = syscall(SYS_getpid); 
; printf("PID procesa (syscall): %d\n", pid); 

; standardna vstopna točka
        global    _start

; sekcija "neinicializiranih statičnih in globalnih spremenljivk" - obstajajo v času prevajanja ali izvajaja?
        section .bss
v_pid   resb      1                ; rezerviramo 1 zlog pomnilnika za PID (reserve uninitialized memory (bytes))          

; sekcija "inicializiranih spremenljivk"
        section   .data
format1:db        "PID: %d", 10, 0 ; format izpisa 1
format2:db        "PID: %x", 10, 0 ; format izpisa 2

; sekcija "kode"
        section   .text
        extern printf           ; za izpis se bomo poslužili printf funkcije

        ; Branje PID
_start: mov       eax, 0x14     ; številka sistemskega klica
        int       0x80          ; klic jedra - rezultat se po klicu vedno shrani v register eax
        
        ; Premik PID
        mov       ecx, eax      ; PID premaknemo v register ecx

        ; Pripravimo število za prištevanje k PID - brez posebnega razloga
        mov       eax, 3        ; v eax nastavimo vrednost 3
        mov       ebx, 4        ; v ebx nastavimo vrednost 4
        mul       ebx           ; množimo eax in ebx - rezultat bo shranjen v eax

        ; K PID prištejemo vrednost iz eax
        add       ecx, eax      ; brez posebnega razloga

        ; Kopiranje PID
        mov       [v_pid], ecx  ; ecx kopiramo v spremenljivko - shranimo na naslov v_pid 

        ; Izpis - argumenti za printf sledijo cdecl (C declaration) načinu - prenos argumentov preko sklada
        push      ecx           ; na sklad potisnemo PID
        push      format1       ; na sklad potisnemo kazalec na format izpisa
        call      printf        ; pokličemo funkcijo printf
        add       esp, 8        ; kazalec esp povečamo za 8 - esp kaže na vrh sklada (najnižji naslov)
                                ; sklad raste od najvišjega proti nižjemu naslovu
                                ; povečanje za 8 pomeni, da bomo skočili nazaj za 2x4B oz. odstranili vrh sklada

        ; rax [# # # # # # # #]
        ; eax [- - - - # # # #]
        ; ax  [- - - - - - # #]
        ; ah  [- - - - - - # -]
        ; al  [- - - - - - - #]

        ; Izpis hex
        push      dword [v_pid] ; PID iz spremenljivke - preberemo vrednost iz v_pid
        push      format2       ; format izpisa
        call      printf        ; pokličemo funkcijo printf
        add       esp, 8        ; počistimo sklad

        ; Izpis hex - ax
        mov       ax, [v_pid]   ; izluščimo ax
        movzx     eax, ax       ; zero-extend; lahko tudi "xor eax, eax" pred nalaganjem
        push      eax           ; PID - register ax
        push      format2       ; format izpisa
        call      printf        ; pokličemo funkcijo printf
        add       esp, 8        ; počistimo sklad

        ; Izhod iz programa
        mov       eax, 0x01     ; številka sistemskega klica za exit
        xor       ebx, ebx      ; register ebx na 0
        int       0x80          ; klic jedra - izvede se enako kot bi zapisali return 0;