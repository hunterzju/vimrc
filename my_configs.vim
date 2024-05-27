call plug#begin("~/.vim_runtime/my_plugins/")
 Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --clangd-completer' }
 " Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
 " Plug 'ctrlpvim/ctrlp.vim'
 Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
 "Plug 'dkprice/vim-easygrep'
 Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
 "Plug 'vim-scripts/EasyGrep'
 "Plug 'rdnetto/YCM-Generator'
 Plug 'airblade/vim-gitgutter'
 "Plug 'ludovicchabant/vim-gutentags'
 Plug 'zivyangll/git-blame.vim'
 Plug 'antiagainst/vim-tablegen'
 Plug 'hunterzju/mlir-vim'
 Plug 'ilyachur/cmake4vim'
 Plug 'rhysd/vim-clang-format'
 Plug 'prabirshrestha/vim-lsp'
 Plug 'mattn/vim-lsp-settings'
 Plug 'hunterzju/vim-fileheader'
 Plug 'drmikehenry/vim-headerguard'
 Plug 'FittenTech/fittencode.vim'
 Plug 'goerz/jupytext.vim'
 "Plug 'KarimElghamry/vim-auto-comment'
 Plug 'preservim/nerdcommenter'
 "Plug 'vim-scripts/c.vim'
 "Plug 'vim-scripts/Conque-GDB'
 "Plug 'aliyun/tongyi-lingma-vim'
call plug#end()

set nu

" execute project related configuration in current directory
if filereadable(".workspace.vim")
    source .workspace.vim
endif 

" """" gutentags config
" " gutentags搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归 "
" let g:gutentags_project_root = [
" \'.root', '.svn', '.git', '.project', '.vscode', 
" \'docs', 'temp', 'test', 'docker']
" " 所生成的数据文件的名称 "
" let g:gutentags_ctags_tagfile = '.tags'
" " 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录 "
" let s:vim_tags = expand('~/.cache/tags')
" let g:gutentags_cache_dir = s:vim_tags
" " 检测 ~/.cache/tags 不存在就新建 "
" if !isdirectory(s:vim_tags)
"    silent! call mkdir(s:vim_tags, 'p')
" endif
" " 配置 ctags 的参数 "
" let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extras=+q']
" let g:gutentags_ctags_exclude = [
" \ '*.js', '*.rst', '*.md', '*.m', '*.mm', '*.mlir', '*.css', '.git',
" \ '*.sh', "*.ll", "*.txt"
" \]
" " let g:gutentags_ctags_extra_args = ['--exclude=*.js', '--exclude=*.rst', '--exclude=*.md']
" let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
" let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
" let g:gutentags_trace = 1

"""""" jupty config
let g:jupytext_enable = 1

"""""" YCM config
set completeopt=menu,menuone
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
" 跳转到函数定义
" nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
" 跳回原位置
" nnoremap <S-F12> <C-o>
" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 0
" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
let g:ycm_clangd_binary_path = "/usr/bin/clangd"

" LLVM Makefile highlighting mode
augroup filetype
  au! BufRead,BufNewFile *Makefile*     set filetype=make
augroup END

"""""""""""" easygrep config 
" let g:EasyGrepCommand = 1
" let g:EasyGrepRecursive = 1
" let g:GrepProgram = "grep"

"""""""""""" vim-lsp config
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_diagnostics_float_cursor = 1
if executable('pylsp')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    " setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    " nmap <buffer> gt <plug>(lsp-type-definition)
    " nmap <buffer> <leader>rn <plug>(lsp-rename)
    " nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    " nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    " nmap <buffer> K <plug>(lsp-hover)
    " nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    " nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    " autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

"""""""""""" Gitgutter
let g:gitgutter_enabled = 1
let g:gitgutter_set_sign_backgrounds = 1
let g:gitgutter_highlight_linenrs = 1
let g:gitgutter_preview_win_floating = 1

highlight! link SignColumn LineNr
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

"""""""""""" LeaderF
" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
" popup mode
let g:Lf_WindowPosition = 'popup'
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }
let g:Lf_WorkingDirectoryMode = 'Af'

let g:Lf_ShortcutF = "<leader>ff"
noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
noremap <C-F-C> :<C-U><C-R>=printf("Leaderf! rg -e %s -t cpp", expand("<cword>"))<CR>
" nnoremap <C-F> :Leaderf rg -e

""""""" auto_comment
" let g:inline_comment_dict = {
" 		\'//': ["js", "ts", "cpp", "c", "dart"],
" 		\'#': ['py', 'sh'],
" 		\'"': ['vim'],
" 		\}
" 
" let g:block_comment_dict = {
" 		\'/*': ["js", "ts", "cpp", "c", "dart"],
" 		\'"""': ['py'],
" 		\}
" 

"""""""""" NerdComment
" Create default mappings
let g:NERDCreateDefaultMappings = 1
" Add spaces after comment delimiters by default
" let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1

