" vim:set foldmethod=marker:
" ========================================
" Setting
" ========================================
" {{{
scriptencoding utf-8
"set ff=unix
"set fileencoding=utf8
set ttyfast
set noswapfile
set nobackup
set hidden
set autoread
set autoindent
set smartindent
set smarttab
set tabstop=4
set shiftwidth=4
set expandtab
set virtualedit=onemore
set clipboard+=unnamed
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~
" fold
set foldmethod=marker
set foldlevel=0
set foldlevelstart=0
set foldcolumn=1
" view
syntax on
set re=0
set background=dark
set scrolloff=5
set title
set showcmd
set number
set cursorline
set cursorcolumn
set showmatch
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set ambiwidth=double
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END" status line
set ruler
set laststatus=2
" explorer
set splitright
filetype plugin on
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = 70
" search
set incsearch
set hlsearch
set ignorecase
set smartcase
set shortmess-=S
au QuickFixCmdPost *grep* cwindow
" completion
set wildmenu
set wildmode=full
set complete=.,w,b,u,U,k,kspell,s,i,d,t
set completeopt=menuone,noinsert,preview,popup
" }}}

" ========================================
" KeyMap
" ========================================
" {{{
let g:mapleader = "\<Space>"
" search ---------------------------------------
nnoremap <silent>* *N
nnoremap <silent># *N
nnoremap <silent><Leader>q :noh<CR>
" move ---------------------------------------
nnoremap j gj
nnoremap k gk
" TODO
" WinResizerStartResize
nnoremap <silent><Leader>t :bo terminal ++rows=10<CR>
nnoremap <silent><Leader>tp :call popup_create(term_start([&shell], #{ hidden: 1, term_finish: 'close'}), #{ border: [], minwidth: &columns/2, minheight: &lines/2 })<CR>
" language ----------------------------------------
nnoremap <Leader>d <Plug>(coc-definition)
nnoremap <Leader>r <plug>(coc-references)
nnoremap <Leader>v :cal IDEActions()<CR>
fu! IDEActions()
  echo 'rename: ReNaming'
  echo 'format: Format'
  echo 'run: Run'
  let cmd = inputdialog(">>")
  if cmd == ''
    retu
  endif
  echo '<<'
  if cmd == 'rename'
    cal CocActionAsync('rename')
    echo 'ok'
  elseif cmd == 'format'
    cal CocActionAsync('format')
    echo 'ok'
  elseif cmd == 'run'
    exe "QuickRun -hook/time/enable 1"
  endif
endf
nnoremap <Leader>? :cal CocAction('doHover')<CR>
nnoremap <Leader>, <plug>(coc-diagnostic-next)
nnoremap <Leader>. <plug>(coc-diagnostic-prev)
nnoremap <Leader>sh :cal execute('top terminal ++rows=10 ++shell eval ' . getline('.'))<CR>
" edit ---------------------------------------
nnoremap d "_d
vnoremap d "_d
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>l
inoremap <C-k> <C-o>k
inoremap <C-j> <C-o>j
vnoremap <C-j> "zx"zp`[V`]
vnoremap <C-k> "zx<Up>"zP`[V`]
" completion ---------------------------------------
inoremap <expr> <CR> pumvisible() ? '<C-y>' : '<CR>'
inoremap <expr> <Tab> '<C-n>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'
if glob('~/.vim/pack/plugins/start/coc.nvim') != '' " for coc
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
  inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
  inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
  let g:coc_snippet_next = '<Tab>'
  let g:coc_snippet_prev = '<S-Tab>'
endif
" filer ---------------------------------------
if glob('~/.vim/pack/plugins/start/nerdtree') != ''
  let g:NERDTreeShowBookmarks = 1
  let g:NERDTreeShowHidden = 1
  nnoremap <silent><Leader>e :NERDTreeToggle<CR>
  nnoremap <silent><Leader><Leader>e :NERDTreeFind<CR>zz
endif
" func - fzf ---------------------------------------batコマンドでsyntax hilight
nnoremap <silent><leader>f :cal FzfStart()<CR>
if glob('~/.vim/pack/plugins/start/fzf.vim') != ''
  set rtp+=~/.vim/pack/plugins/start/fzf
  nnoremap <silent><leader>f :Files<CR>
  nnoremap <silent><leader>h :History<CR>
  nnoremap <silent><leader>b :Buffers<CR>
  " if git repo, ref .gitignore
  let gitroot = system('git rev-parse --show-superproject-working-tree --show-toplevel')
  if v:shell_error
    nnoremap <silent><leader>f :Files<CR>
  else
    nnoremap <silent><leader>f :GFiles<CR>
  endif
endif
" airline ---------------------------------------
if glob('~/.vim/pack/plugins/start/vim-airline') != ''
  let g:airline_theme = 'deus'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_powerline_fonts = 1
  let g:airline_highlighting_cache = 1
  function! CloseBuf()
    let l:now_b = bufnr('%')
    bn
    execute('bd ' . now_b)
  endfunction
  nnoremap <silent><C-p> :bn<CR>
  nnoremap <silent><C-q> :bp<CR>
  nnoremap <silent><Leader>x :call CloseBuf()<CR>
endif

" func - mark ---------------------------------------
nnoremap <silent>mw :cal HiSet()<CR>
" favorite ---------------------------------------
nnoremap <Leader>n :Necronomicon 
nnoremap <Leader><Leader><Leader> :15sp ~/forge/cheat_sheet.md<CR>
" }}}

" ========================================
" Function
" ========================================

" color --------------------------------{{{
let s:colorscheme_arr_default = ['torte']
let s:colorscheme_arr = ['onedark', 'hybrid_material', 'molokai']
fu! ChangeColor()
  if glob('~/.vim/colors') != ''
    execute('colorscheme ' . s:colorscheme_arr[localtime() % len(s:colorscheme_arr)])
  else
    execute('colorscheme ' . s:colorscheme_arr_default[localtime() % len(s:colorscheme_arr_default)])
    cal SetStatusLine()
  endif
endf
cal ChangeColor()

fu! ColorInstall()
  let cmd = "mkdir -p ~/.vim/colors && cd ~/.vim/colors && curl https://raw.githubusercontent.com/serna37/vim-color/master/hybrid_material.vim > hybrid_material.vim && curl https://raw.githubusercontent.com/serna37/vim-color/master/molokai.vim > molokai.vim && curl https://raw.githubusercontent.com/serna37/vim-color/master/onedark.vim > onedark.vim"
  execute("bo terminal ++shell echo 'start' && ".cmd." && echo 'end'")
endf " }}}


" plugins --------------------------------------------{{{
let s:repos = [
    \ 'powerline/fonts',
    \ 'ryanoasis/nerd-fonts',
    \ 'ryanoasis/vim-devicons',
    \ 'vim-airline/vim-airline',
    \ 'vim-airline/vim-airline-themes',
    \ 'sheerun/vim-polyglot',
    \ 'preservim/nerdtree',
    \ 'Xuyuanp/nerdtree-git-plugin',
    \ 'junegunn/fzf',
    \ 'junegunn/fzf.vim',
    \ 'neoclide/coc.nvim',
    \ 'thinca/vim-quickrun',
    \ 'puremourning/vimspector',
    \ 'unblevable/quick-scope',
    \ 'yuttie/comfortable-motion.vim',
    \ 'simeji/winresizer',
    \ 'obcat/vim-hitspop',
    \ 't9md/vim-quickhl',
    \ 'junegunn/goyo.vim',
    \ 'junegunn/limelight.vim',
    \ 'serna37/vim-markanker',
    \ 'serna37/vim-grepmenu',
    \ 'serna37/vim-catbell',
    \ 'serna37/vim-setting',
\ ]
command! PlugInstall cal PlugInstall()
command! PlugUnInstall cal PlugUnInstall()
fu! PlugInstall(...)
  let cmd = "repos=('".join(s:repos,"' '")."') && mkdir -p ~/.vim/pack/plugins/start && cd ~/.vim/pack/plugins/start && for v in ${repos[@]};do git clone --depth 1 https://github.com/${v} ;done" . " && fzf/install --no-key-bindings --completion --no-bash --no-zsh --no-fish" . " && sh fonts/install.sh" . " && sh nerd-fonts/install.sh && rm -rf nerd-fonts"
  execute("bo terminal ++shell " . cmd)
endf
let g:vsnip_snippet_dir = "~/forge"
fu! PlugUnInstall(...)
  execute("bo terminal ++shell echo 'start' && rm -rf ~/.vim ~/.config && echo 'end'")
endf " }}}

" favorite  -----------------------------------{{{
command! -nargs=* Necronomicon cal Necronomicon(<f-args>)
fu! Necronomicon(...) abort
  if a:0 == 0
    e ~/work/necronomicon.md
  elseif a:0 == 1 && a:1 == 'Azathoth'
    cal Initiation()
  elseif a:0 == 1 && a:1 == 'YogSothoth'
    let backup_cmd = "cd ~/backup; LIMIT=12; PREFIX=bk; FOLDER_NAME=${PREFIX}".strftime("%Y-%m-%d")."; if [ ! -e ./${FOLDER_NAME} ]; then mkdir ${FOLDER_NAME}; fi; cp -rf ~/work ${FOLDER_NAME}; cp -rf ~/forge ${FOLDER_NAME}; CNT=`ls -l | grep ^d | wc -l`; if [ ${CNT} -gt ${LIMIT} ]; then ls -d */ | sort | head -n $((CNT-LIMIT)) | xargs rm -rf; fi"
    execute("bo terminal ++shell echo 'start' && ".backup_cmd." && echo 'end'")
  elseif a:1 == 'n'
    echo "c  : change colorscheme"
    echo "ss : static snippet"
    let mode = inputdialog("choose mode>>")
    if mode == "c"
      cal feedkeys("\<CR>")
      cal feedkeys(":cal ChangeColor()\<CR>")
      cal feedkeys(":colorscheme\<CR>")
    elseif mode == "ss"
      cal feedkeys(":15sp ~/forge/static_snippets.sh\<CR>")
      cal feedkeys("\<CR>")
    endif
  endif
endf
" }}}

" init ----------------------------------{{{
fu! Initiation()
cal system("mkdir -p ~/forge ~/work ~/backup && touch ~/work/necronomicon.md")
cal system("if [ -e ~/forge/cheat_sheet.md ]; then rm ~/forge/cheat_sheet.md; fi && touch ~/forge/cheat_sheet.md")
cal system("if [ ! -e ~/forge/static_snippets.sh ]; then touch ~/forge/static_snippets.sh; fi")
let cheat_sheet = [
\ "# Install",
\ "- call ColorInstall() : install colorscheme",
\ "- command PlugInstall : install plugin (need nodejs, yarn)",
\ "-   >> call coc#util#install()",
\ "-   >> CocInstall coc-snippets coc-tsserver coc-json coc-go coc-clangd",
\ "-   >> CocConfig",
\ "-   >> also see https://github.com/neoclide/coc.nvim/wiki/Language-servers",
\ "- command PlugUnInstall : uninstall plugin",
\ "",
\ "# IDE",
\ "(plugin coc)",
\ "- Space d : go to definition",
\ "- Space r : find references",
\ "- Space v : other IDE functions",
\ "- Space ? : hover document",
\ "- Space , : prev diagnostic",
\ "- Space . : next diagnostic",
\ "- Tab : completion, coc-snippet next",
\ "- Shift Tab : coc-snippet prev",
\ "",
\ "(plugin vim-vsnip)",
\ "- (insert mode) Ctrl s : vsnip expand / next",
\ "- (insert mode) Ctrl w : vsnip prev",
\ "",
\ "# Motion Window",
\ "- ↑↓←→ : resize window",
\ "- Ctrl + hjkl : move window forcus",
\ "- Ctrl + udfb : comfortable scroll",
\ "- (visual choose) Ctrl jk : move line text",
\ "- (insert mode) Ctrl hljk : move cursor",
\ "- Space t : terminal",
\ "- Space tp : terminal popup",
\ "",
\ "# Search",
\ "- Space q : clear search highlight",
\ "- * : search word (original vim but dont move cursor)",
\ "- # : search word (original vim but dont move cursor)",
\ "- Space f : file search",
\ "- Space g : grep",
\ "",
\ "# Mark",
\ "- Space m : mark list",
\ "- mm : marking",
\ "- mj : next mark",
\ "- mk : prev mark",
\ "- mw : mark word (highlight)",
\ "",
\ "# GodSpeed",
\ "- Tab / Shift+Tab :",
\ "  1. expand anker each 6 rows, jump to anker",
\ "  2. expand f-scope highlight",
\ "- Space w : clear anker, f-scope highlight, mark highlight",
\ "",
\ "# Favorit",
\ "- Space sh : run current line as shell",
\ "- Space n : Necronomicon",
\ "-   :Necronomicon > open necronomicon",
\ "-   :Necronomicon Azathoth > initiation",
\ "-   :Necronomicon YogSothoth > backup",
\ "-   :Necronomicon n > other funcs",
\ "- Space Space Space : this",
\ ]
for v in cheat_sheet
  cal system('echo "'.v.'" >> ~/forge/cheat_sheet.md')
endfor
let static_snippets_ini = [
\ "# git",
\ "git add . && git commit -m 'upd' && git push",
\ "",
\ ]
for v in static_snippets_ini
  cal system('echo "'.v.'" >> ~/forge/static_snippets.sh')
endfor
echo 'initiation end'
echo 'help to Space*3'
endf " }}}

