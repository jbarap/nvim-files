" Linters --------------------------------------------------------------------
let g:ale_linters_explicit = 1
let g:ale_linters = {
    \    'python': ['flake8', 'pylint', 'mypy'],
    \}
" add mypy

let g:ale_python_flake8_options = '--max-line-length=110'

" let g:ale_python_pylint_executable = 'python3'
let g:ale_python_pylint_options = '--disable=missing-module-docstring,
    \too-few-public-methods,missing-class-docstring,missing-function-docstring,
    \invalid-name,import-error,no-else-return,line-too-long,trailing-newlines
    \ --generated-members=pandas.,cv2.,cv2.aruco.'

let g:ale_python_mypy_options = '--ignore-missing-import'


" Fixers ---------------------------------------------------------------------
let g:ale_fixers = {
    \    'python': ['black', 'isort', 'add_blank_lines_for_python_control_statements'],
    \}

let g:ale_python_black_options = '--skip-string-normalization'

" Globals --------------------------------------------------------------------
" signs    ✖!
let g:ale_disable_lsp = 1

let g:ale_sign_error = ' ●'
let g:ale_sign_warning = ' .'
let g:ale_sign_style_error = '>'
let g:ale_sign_style_warning = '-'

let g:ale_warn_about_trailing_blank_lines = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_insert_save = 1
" Was never
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_delay = 200


" Mappings
nmap <F7> <Plug>(ale_fix)
nmap <silent> <C-e> <Plug>(ale_next_wrap)

