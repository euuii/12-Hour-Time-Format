.model small
.stack 100h

.data
    hours db ?
    minutes db ?
    meridiem db ?
    header db 0dh, 0ah, "=== 12-Hour Time Format ===", 0dh, 0ah, "$"
    prompt db 0dh, 0ah, "Enter time (HHMMam/pm) or 00 to exit", 0dh, 0ah, "Example: 0830am, 1200pm", 0dh, 0ah, "Time: $"
    morning db 0dh, 0ah, "Good Morning!", 0dh, 0ah, "$"
    afternoon db 0dh, 0ah, "Good Afternoon!", 0dh, 0ah, "$"
    evening db 0dh, 0ah, "Good Evening!", 0dh, 0ah, "$"
    error db 0dh, 0ah, "Invalid Input!", 0dh, 0ah, "$"

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    lea dx, header
    int 21h

    menu:
    mov ah, 09h
    lea dx, prompt
    int 21h

    ;tens hours
    mov ah, 01h
    int 21h
    sub al, 30h     ;Convert input into ASCII
    mov bl, 10      ;Move 10 to bl
    mul bl          ;Multiply input from bl
    mov hours, al   ;Move input to "hours" variable

    ;ones hours
    mov ah, 01h
    int 21h
    sub al, 30h
    add hours, al

    ;hours must be greater than 0
    cmp hours, 0
    jg continue_input

    ;if hours == 0, exit program
    mov ax, 4c00h
    int 21h

    ;display colon
    continue_input:
    mov ah, 02h
    mov dl, ":"
    int 21h

    ;tens minutes
    mov ah, 01h
    int 21h
    sub al, 30h
    mov bl, 10
    mul bl
    mov minutes, al 

    ;ones minutes
    mov ah, 01h
    int 21h
    sub al, 30h
    add minutes, al 

    ;am/pm
    mov ah, 01h
    int 21h
    mov meridiem, al
    mov ah, 01h
    int 21h

    ;minutes must be less than 60
    cmp minutes, 60
    jge display_error

    ;6th input must be "m"
    cmp al, "m"
    je compare_meridiem
    jmp display_error

    ;Meridiem must be either "a" or "p"
    compare_meridiem:
    cmp meridiem, "a"
    je compare_am

    cmp meridiem, "p"
    je compare_pm

    jmp display_error

    compare_am:
    cmp hours, 12
    jle display_morning
    jmp display_error

    compare_pm:
    cmp hours, 5
    jle display_afternoon

    cmp hours, 11
    jle display_evening

    cmp hours, 12
    je display_afternoon

    jmp display_error

    display_morning:
    mov ah, 09h
    lea dx, morning
    int 21h
    jmp menu

    display_afternoon:
    mov ah, 09h
    lea dx, afternoon
    int 21h
    jmp menu

    display_evening:
    mov ah, 09h
    lea dx, evening
    int 21h
    jmp menu

    display_error:
    mov ah, 09h
    lea dx, error
    int 21h
    jmp menu

main endp
end main