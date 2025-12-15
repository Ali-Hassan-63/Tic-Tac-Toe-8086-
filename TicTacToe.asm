                     .model small
.stack 100h

.data
    board db '1','2','3','4','5','6','7','8','9'  ; Game board
    current_player db 'X'                         ; Current player (X starts)
    game_over db 0                               ; 0 = playing, 1 = game over
    win_msg db 'Player X wins!$', 0
    lose_msg db 'Player O wins!$', 0
    draw_msg db 'Game draw!$', 0
    input_prompt db 'Enter position (1-9): $', 0
    invalid_msg db 'Invalid move! Try again.$', 0
    newline db 13, 10, '$'

.code
main proc
    mov ax, @data
    mov ds, ax
    
game_loop:
    call clear_screen
    call display_board
    call get_player_move
    call check_game_status
    cmp game_over, 1
    je game_end
    
    call switch_player
    jmp game_loop

game_end:
    call clear_screen
    call display_board
    call display_result
    mov ah, 4ch
    int 21h
main endp

clear_screen proc
    mov ax, 0003h  ; Clear screen using BIOS interrupt
    int 10h
    ret
clear_screen endp

display_board proc
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Display board with grid
    mov cx, 3      ; 3 rows
    mov si, 0      ; board index
    
display_row:
    push cx
    
    ; Display row with separators
    mov cx, 3      ; 3 columns per row
display_col:
    mov ah, 02h    ; Display character
    mov dl, board[si]
    int 21h
    
    inc si
    
    cmp cx, 1      ; Don't print | after last column
    je no_pipe
    
    mov dl, '|'
    int 21h
    
no_pipe:
    loop display_col
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    pop cx
    cmp cx, 1      ; Don't print line after last row
    je no_line
    
    mov ah, 02h
    mov dl, '-'
    int 21h
    mov dl, '+'
    int 21h
    mov dl, '-'
    int 21h
    mov dl, '+'
    int 21h
    mov dl, '-'
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
no_line:
    loop display_row
    
    mov ah, 09h
    lea dx, newline
    int 21h
    ret
display_board endp

get_player_move proc
input_loop:
    ; Display prompt
    mov ah, 09h
    lea dx, input_prompt
    int 21h
    
    ; Get input
    mov ah, 01h
    int 21h
    
    ; Convert ASCII to number and validate
    sub al, '1'    ; Convert '1'-'9' to 0-8
    cmp al, 0
    jl invalid_input
    cmp al, 8
    jg invalid_input
    
    ; Check if position is available
    mov bl, al
    mov bh, 0
    mov cl, board[bx]
    cmp cl, '1'
    jl invalid_input   ; Position already taken
    cmp cl, '9'
    jg invalid_input
    
    ; Valid move - update board
    mov dl, current_player
    mov board[bx], dl
    ret

invalid_input:
    mov ah, 09h
    lea dx, newline
    int 21h
    lea dx, invalid_msg
    int 21h
    lea dx, newline
    int 21h
    jmp input_loop
get_player_move endp

switch_player proc
    cmp current_player, 'X'
    je switch_to_o
    mov current_player, 'X'
    ret
switch_to_o:
    mov current_player, 'O'
    ret
switch_player endp

check_game_status proc
    ; Check rows
    mov si, 0
    mov cx, 3
check_rows:
    mov al, board[si]
    cmp al, board[si+1]
    jne next_row
    cmp al, board[si+2]
    jne next_row
    jmp game_won
next_row:
    add si, 3
    loop check_rows
    
    ; Check columns
    mov si, 0
    mov cx, 3
check_cols:
    mov al, board[si]
    cmp al, board[si+3]
    jne next_col
    cmp al, board[si+6]
    jne next_col
    jmp game_won
next_col:
    inc si
    loop check_cols
    
    ; Check diagonals
    ; Main diagonal (0,4,8)
    mov al, board[0]
    cmp al, board[4]
    jne check_other_diag
    cmp al, board[8]
    jne check_other_diag
    jmp game_won
    
check_other_diag:
    ; Other diagonal (2,4,6)
    mov al, board[2]
    cmp al, board[4]
    jne check_draw
    cmp al, board[6]
    jne check_draw
    jmp game_won
    
check_draw:
    ; Check if board is full
    mov cx, 9
    mov si, 0
check_full:
    mov al, board[si]
    cmp al, '1'
    jl not_number
    cmp al, '9'
    jg not_number
    jmp still_playing  ; Found empty spot
not_number:
    inc si
    loop check_full
    
    ; Board is full - draw
    mov game_over, 1
    ret
    
still_playing:
    mov game_over, 0
    ret
    
game_won:
    mov game_over, 1
    ret
check_game_status endp

display_result proc
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Check who won by looking at current player
    ; (The player who just moved won)
    cmp current_player, 'X'
    je x_wins
    cmp current_player, 'O'
    je o_wins
    
    ; Must be a draw
    lea dx, draw_msg
    int 21h
    ret
    
x_wins:
    lea dx, win_msg
    int 21h
    ret
    
o_wins:
    lea dx, lose_msg
    int 21h
    ret
display_result endp

end main