" Use Vim's regexp engine for both file selection and the search register.
function! s:read_files() abort
    " readfile(..., 'b') splits at LF and replaces NUL with NL.
    let l:files = []
    let l:pending = ''
    for l:line in readfile($VGREP_FILES, 'b')
        let l:parts = split(l:line, "\n", 1)
        let l:parts[0] = l:pending . l:parts[0]
        let l:pending = remove(l:parts, -1) . "\n"
        call extend(l:files, l:parts)
    endfor
    return uniq(sort(l:files))
endfunction

function! s:vgrep() abort
    let l:pattern = '\m\C' . $VGREP_PATTERN
    let l:matches = []
    let l:wildignore = &wildignore
    try
        set wildignore=
        " Validate the pattern even when there are no readable files.
        call match('', l:pattern)
        for l:file in s:read_files()
            if !filereadable(l:file) || l:file =~# "\n"
                continue
            endif
            if $VGREP_TRACKED ==# '1' && getftype(l:file) ==# 'link'
                continue
            endif
            if fnamemodify(l:file, ':p') ==# fnamemodify($VGREP_FILES, ':p')
                continue
            endif
            let @/ = l:pattern
            try
                execute 'silent 1lvimgrep //j ' . fnameescape(fnamemodify(l:file, ':p'))
                call add(l:matches, l:file)
            catch /^Vim\%((\a\+)\)\=:E480:/
                " No match in this file.
            endtry
        endfor
        call setloclist(0, [], 'f')
        if empty(l:matches)
            echomsg 'vgrep: no matches'
            cquit 1
        endif
        execute 'args ' . join(map(l:matches, 'fnameescape(fnamemodify(v:val, ":p"))'))
        vertical all
        let @/ = l:pattern
        call histadd('search', @/)
        set hlsearch
    catch
        echohl ErrorMsg
        echomsg 'vgrep: ' . v:exception
        echohl None
        cquit 2
    finally
        let &wildignore = l:wildignore
    endtry
endfunction

call s:vgrep()
