let s:search_cmd = 'ag --nogroup --nocolor --column --ignore tags -w'

function! ag#coc_location_list()
    if exists("g:agpkg")
        let s:search_cmd = g:agpkg
    endif
    let l:locations = []
    let l:word = expand('<cword>')
    let l:word_len = strlen(l:word)
    let l:path = expand('<sfile>:p:h')
    let l:cmd = s:search_cmd . " " . l:word . " " . l:path
    let l:search_result = system(l:cmd)

    for line in split(l:search_result, "\n")
        let l:res = split(line, ':')
        let [l:file, l:line_nr, l:col, l:content] = [l:res[0], l:res[1], l:res[2], join(l:res[3:-1])]
        let l:col = str2nr(l:col)
        let l:end_col = str2nr(l:col) + l:word_len
        let l:item = {
            \ 'lnum': l:line_nr,
            \ 'end_lnum': l:line_nr,
            \ 'filename': l:file,
            \ 'end_col': l:end_col,
            \ 'col': l:col,
            \ 'range': {
            \   'end': {'character': l:end_col - 1, 'line': l:line_nr - 1}, 
            \   'start': {'character': l:col - 1, 'line': l:line_nr - 1}
            \ },
            \ 'text': l:content,
        \ }
        call add(l:locations, l:item)
    endfor
    return l:locations
endfunction

function! ag#agsearch() abort "{{{
    let g:coc_jump_locations=ag#coc_location_list()
    CocList --normal --auto-preview location
endfunction "}}}
