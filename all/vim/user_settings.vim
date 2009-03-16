if has("gui_running")
  colors vibrantink
  set guioptions=e
  set guioptions-=m
else
" MAKE ARROW KEYS WORK IN CONSOLE VI
 set term=xterm-256color
 colors vibrantink
endif

let clj_highlight_builtins = 1
let clj_paren_rainbow = 1
let clj_highlight_contrib = 1

let g:gist_clip_command = 'pbcopy'
map <leader>rd Orequire 'rubygems';require 'ruby-debug';debugger<Esc>j

" Visual mode mappings
vmap // y/<C-R>"<CR>

if version >= 600
  set foldenable
  set foldmethod=syntax
  set foldlevel=999
endif

