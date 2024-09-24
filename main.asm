section .data
    ; Bitmap file header (14 bytes)
    bmp_file_header:
        db 'B', 'M'                      ; Signature
        dd 54 + 300 * 200 * 3            ; File size
        dw 0                             ; Reserved 1
        dw 0                             ; Reserved 2
        dd 54                            ; Offset to pixel data

    ; Bitmap info header (40 bytes)
    bmp_info_header:
        dd 40                            ; Header size
        dd 300                           ; Image width
        dd 200                           ; Image height
        dw 1                             ; Planes
        dw 24                            ; Bits per pixel
        dd 0                             ; Compression
        dd 300 * 200 * 3                 ; Image size
        dd 2835                          ; Horizontal resolution (pixels per meter)
        dd 2835                          ; Vertical resolution (pixels per meter)
        dd 0                             ; Colors used
        dd 0                             ; Important colors

section .bss
    pixel_data resb 300 * 200 * 3        ; Space for pixel data (300x200, 3 bytes per pixel)

section .text
    global _start

_start:
    ; Initialize pixel data (red background)
    mov rdi, pixel_data
    mov ecx, 300 * 200

fill_pixels:
    mov byte [rdi], 0x00                 ; Blue
    mov byte [rdi + 1], 0x00             ; Green
    mov byte [rdi + 2], 0xFF             ; Red
    add rdi, 3
    loop fill_pixels

    ; Open the file "output.bmp" (O_CREAT | O_WRONLY)
    mov rax, 2                           ; syscall: sys_open
    lea rsi, [rel filename]              ; Filename pointer
    mov rdi, rsi                         ; Filename
    mov rsi, 0x241                       ; O_CREAT | O_WRONLY | O_TRUNC
    mov rdx, 0o644                       ; File permissions
    syscall

    ; Save file descriptor
    push rax

    ; Check if file was created (check return value in rax)
    test rax, rax
    js file_creation_error               ; Jump if there was an error

    ; Write file header
    pop rdi                              ; Restore file descriptor
    push rdi                             ; Save file descriptor again
    mov rax, 1                           ; syscall: sys_write
    lea rsi, [rel bmp_file_header]
    mov rdx, 14                          ; File header size
    syscall

    ; Write info header
    pop rdi                              ; Restore file descriptor
    push rdi                             ; Save file descriptor again
    mov rax, 1                           ; syscall: sys_write
    lea rsi, [rel bmp_info_header]
    mov rdx, 40                          ; Info header size
    syscall

    ; Write pixel data
    pop rdi                              ; Restore file descriptor
    mov rax, 1                           ; syscall: sys_write
    lea rsi, [rel pixel_data]
    mov rdx, 300 * 200 * 3               ; Image size
    syscall

    ; Close file
    mov rax, 3                           ; syscall: sys_close
    syscall

    ; Exit program
    mov rax, 60                          ; syscall: sys_exit
    xor rdi, rdi                         ; status 0
    syscall

file_creation_error:
    ; Print error message if file creation fails
    mov rax, 1                           ; syscall: sys_write
    mov rdi, 1                           ; file descriptor (stdout)
    lea rsi, [rel error_msg]
    mov rdx, 25                          ; length of error message
    syscall

    ; Exit with non-zero status
    mov rax, 60                          ; syscall: sys_exit
    mov rdi, 1                           ; status 1
    syscall

section .rodata
    filename db 'output.bmp', 0
    error_msg db 'Error: File creation failed', 0

