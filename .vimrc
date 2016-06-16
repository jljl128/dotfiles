" source $VIMRUNTIME/mswin.vim
" behave mswin

" No need for vi compatibility
set nocompatible

" Pathogen plugin
execute pathogen#infect()
Helptags

syntax on
filetype plugin indent on

set tags=./tags;                                " look for tags in directory of the current file and its parent directories

if has('gui_running')
    colorscheme slate
    set guioptions-=T                           " remove toolbar
    set guioptions-=rL                          " remove right and left scrollbars
    winpos 0 0                                  " put gui at top left corner of display
endif

let s:is_windows = has('win32') || has('win64')

if s:is_windows
    set shell=c:\windows\system32\cmd.exe
    set guifont=Consolas:h10:cANSI
endif

" Save vim session on exit
set ssop-=options                               " do not store global and local values in a session
autocmd VimLeavePre * mksession! ~/session.vim

" Restore vim session when launched without arguments
function RestoreSession()
    if argc() == 0 "vim called without arguments
        execute 'source ~/session.vim'
    end
endfunction
autocmd VimEnter * call RestoreSession()

let g:netrw_liststyle=3                         " netrw style

set tabstop=4
set shiftwidth=4
set expandtab                                   " tab key is expanded to 4 spaces
set smartindent                                 " semi-intelligent indentation when editing
set backspace=indent,eol,start                  " sane backspace
set nowrap textwidth=0 wrapmargin=0             " turn off physical wrap (auto-insert of newlines) and visual wrap
set lines=80 columns=120
set title
set laststatus=2
set ruler
set relativenumber number
set nobackup nowritebackup noswapfile
set hlsearch incsearch ignorecase smartcase     " search
set colorcolumn=90                              " add a color highlight showing the edge of 'wide' lines
set cursorline                                  " highlight the current line
set hidden                                      " don't prompt for save on buffer switch
set wildmenu                                    " cmd completion
set clipboard=unnamed                           " use system clipboard

" Disable beep and flash. It needs to be done on GUIEnter because starting
" the GUI (which occurs after vimrc is read) resets 't_vb' to its default value.
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Define the patterns for the ExtraWhitespace highlight group
autocmd syntax * if &buftype == "" | syn match ExtraWhitespace "\s\+$" | endif
autocmd syntax * if &buftype == "" | syn match ExtraWhitespace "\t" | endif

" Colorscheme modifications need to be done here, because session restore
" (done after .vimrc has been run) will re-apply the colorscheme, resetting it
" to its default values. This here allows the mods to be set at VimEnter after
" session restore.
function <SID>ModifyColorScheme()
    highlight Normal cterm=NONE ctermbg=254 ctermfg=NONE guifg=#C4C4C1
    highlight ColorColumn cterm=NONE ctermbg=254 ctermfg=NONE guibg=#323228
    highlight CursorLine cterm=NONE ctermbg=254 ctermfg=NONE guibg=black
    highlight ExtraWhitespace ctermbg=red guibg=red
endfunction
autocmd VimEnter * call <SID>ModifyColorScheme()

" Auto-delete trailing whitespace before buffer is written
function <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction
autocmd FileType c,cpp,cs,java,php,ruby,python,js,css,xml,cspoj,proj,targets autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" Customize statusline (airline plugin was too much)
set statusline=
set statusline+=%<%F\                                " full filepath
set statusline+=%{fugitive#statusline()}\            " git status
set statusline+=%=\                                  " start right-aligned items
set statusline+=\ %{''.(&fenc!=''?&fenc:&enc).''}    " encoding
set statusline+=\ %{(&bomb?\",BOM\":\"\")}\          " encoding2
set statusline+=\ %5l%*                              " current line
set statusline+=/%L%*                                " total lines
set statusline+=%4v\ %*                              " virtual column number

let mapleader = ","

" Expand %% to the current file's directory
cabbr <expr> %% expand('%:p:h')

" Expand da to the root of source repositories
cabbr da ~/dev/appature

" Close a buffer without closing the window
nnoremap <leader>d :b#<bar>bd#<CR>

" Open a new vertical/horizontal split and switch over to it
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>h <C-w>s<C-w>j

" Window switching
nnoremap <leader>wj <C-w>j
nnoremap <leader>wk <C-w>k
nnoremap <leader>wh <C-w>h
nnoremap <leader>wl <C-w>l

" Close window
nnoremap <leader>wc <C-w>c

" Map filetypes
augroup filetypedetect
    autocmd BufNewFile,BufRead *.aspx setfiletype=html
    autocmd BufNewFile,BufRead *.master setfiletype=html
    autocmd BufNewFile,BufRead *.ascx setfiletype=cs
    autocmd BufNewFile,BufRead *.nxu set filetype=sql
    autocmd BufNewFile,BufRead *.config set filetype=xml
    autocmd BufNewFile,BufRead *.template set filetype=xml
    autocmd BufNewFile,BufRead *.csproj set filetype=xml
    autocmd BufNewFile,BufRead *.projs set filetype=xml
    autocmd BufNewFile,BufRead *.targets set filetype=xml
    autocmd BufNewFile,BufRead *.gaz set filetype=xml
augroup END

" CtrlP plugin
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg|gif)$',
\}

" YouCompleteMe plugin
if s:is_windows
    let g:ycm_auto_start_csharp_server = 0
else
    let g:ycm_auto_start_csharp_server = 1
    let g:ycm_csharp_server_port = 2000
endif
let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_confirm_extra_conf = 0
nnoremap <leader>gt :YcmCompleter GoTo<CR>
nnoremap <leader>gd :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gi :YcmCompleter GoToImplementation<CR>
nnoremap <leader>rs :YcmCompleter ReloadSolution<CR>

" let g:neocomplete#enable_at_startup = 1
" let g:OmniSharp_selector_ui = 'ctrlp'
" let g:Omnisharp_start_server = 0
" 
" augroup omnisharp_commands
"     autocmd!
" 
"     "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
"     autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
" 
"     " Synchronous build (blocks Vim)
"     "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
"     " Builds can also run asynchronously with vim-dispatch installed
"     autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
"     " automatic syntax check on events (TextChanged requires Vim 7.4)
" "    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck
" 
"     " Automatically add new cs files to the nearest project on save
"     autocmd BufWritePost *.cs call OmniSharp#AddToProject()
" 
"     "show type information automatically when the cursor stops moving
"     autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
" 
"     "The following commands are contextual, based on the current cursor position.
" 
"     autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
"     autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
"     autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
"     autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
"     autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
"     "finds members in the current buffer
"     autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
"     " cursor can be anywhere on the line containing an issue
"     autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
"     autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
"     autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
"     autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
"     "navigate up by method/property/field
"     autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
"     "navigate down by method/property/field
"     autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>
" 
" augroup END
" " Contextual code actions (requires CtrlP or unite.vim)
" nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
" " Run code actions with text selected in visual mode to extract method
" vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>
"


