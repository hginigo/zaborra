" My personal statusline setup

" Disable --INSERT-- type indicators
set noshowmode

" Start statusline setup
set stl=
set stl+=%#Directory#\ 
" Current mode
set stl+=-%.1{GetMode()}-
" Modified flag
set stl+=%4m
" Read only flag
set stl+=%5r
" help flag
set stl+=%7h

set stl+=\ 
set stl+=%#CursorLineNr#
" Relative file path
set stl+=\ %f

set stl+=\%=
" Highlighted character in hex
set stl+=0x%02B
set stl+=\ %#WildMenu#
" File type and encoding
set stl+=\ %y\ %{&ff}
" Current line and column
set stl+=\ (%02l,%02c)\ \|
" Percentage and total lines
set stl+=\ %3p%%/%L
" Buffer number
set stl+=\ [%n]
set stl+=\ 

" Get current mode in uppercase
function GetMode()
    let curMode = mode()
    return toupper(curMode)
endfunction
