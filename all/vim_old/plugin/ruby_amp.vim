" ruby_amp.vim - Vim version of the awesome RubyAMP.tmbundle by Tim C Harper
" Maintainer:   Joe Tanner

" Exit quickly when:
" - this plugin was already loaded (or disabled)
" - when 'compatible' is set
if (exists("g:loaded_ruby_amp") && g:loaded_ruby_amp) || &cp
  finish
endif
let g:loaded_ruby_amp = 1

" Code {{{1

"
" Run Commands
"

function s:run_rspec_examples()
  call s:ruby_amp_command_in_terminal("run_rspec_examples")
endfunction

function s:run_rspec_single_example()
  call s:ruby_amp_command_in_terminal("run_rspec_single_example")
endfunction

"
" Debug Commands
"

function s:debug_rspec_examples()
  call s:ruby_amp_command_in_terminal("debug_rspec_examples", {'exit_when_done':1})
endfunction

function s:debug_rspec_single_example()
  call s:ruby_amp_command_in_terminal("debug_rspec_single_example", {'exit_when_done':1})
endfunction

function s:debug_set_breakpoint_at_current_line()
  echo s:ruby_amp_command("debug_set_breakpoint_at_current_line")
endfunction

function DebugInspectWithPrettyPrint(is_visual)
  echo s:ruby_amp_command("debug_inspect_with_pretty_print", {'is_visual': a:is_visual})
endfunction

function DebugInspectAsString(is_visual)
  echo s:ruby_amp_command("debug_inspect_as_string", {'is_visual': a:is_visual})
endfunction


"
" Misc Commands
"

" Open a Terminal window and cd to the root of the GIT project
function s:project_terminal()
  call s:run_in_terminal('cd ' . expand('%:p:h') . '; while [ ! -d .git ] && [ \$PWD != "/" ]; do cd ..; done')
endfunction



"
" Run Mappings
"
command RunRSpecExamples      call s:run_rspec_examples()
command RunRSpecSingleExample call s:run_rspec_single_example()
map <unique> <D-r> :RunRSpecExamples<CR>
map <unique> <D-R> :RunRSpecSingleExample<CR>

"
" Debug Mappings
"
command DebugRSpecExamples                 call s:debug_rspec_examples()
command DebugRSpecSingleExample            call s:debug_rspec_single_example()
command DebugSetBreakpointAtCurrentLine    call s:debug_set_breakpoint_at_current_line()
map <unique> <D-d>      :DebugRSpecExamples<CR>
map <unique> <D-D>      :DebugRSpecSingleExample<CR>
map <unique> <Leader>bb :DebugSetBreakpointAtCurrentLine<CR>

"
" Debug Inspect Mappings
"
command DebugInspectWithPrettyPrint              call DebugInspectWithPrettyPrint(0)
command -range DebugVisualInspectWithPrettyPrint call DebugInspectWithPrettyPrint(1)
nmap <unique> <D-i> :DebugInspectWithPrettyPrint<CR>
vmap <unique> <D-i> :DebugVisualInspectWithPrettyPrint<CR>
command DebugInspectAsString              call DebugInspectAsString(0)
command -range DebugVisualInspectAsString call DebugInspectAsString(1)
nmap <unique> <D-I> :DebugInspectAsString<CR>
vmap <unique> <D-I> :DebugVisualInspectAsString<CR>

"
" Misc Mappings
"
command ProjectTerminal call s:project_terminal()
nnoremap <silent> <Leader>pp :ProjectTerminal<CR>


"
" Helper functions
"

function s:ruby_amp_command(command, ...)
  if a:0 > 0
    let options = a:1
  else
    let options = {}
  endif
  let script = s:ruby_amp_script(a:command, options)
  return system(script)
endfunction

function s:ruby_amp_command_in_terminal(command, ...)
  if a:0 > 0
    let options = a:1
  else
    let options = {}
  endif
  let script = s:ruby_amp_script(a:command, options)
  call s:run_in_terminal(script)
endfunction

function s:ruby_amp_script(command, options)
  let envs = ""
  let stdin = ""
  let env_variables = {'TM_FILEPATH': expand('%:p'), 'TM_LINE_NUMBER': line('.'), 'TM_COLUMN_NUMBER': col('.')}
  if has_key(a:options, 'is_visual') && remove(a:options, 'is_visual')
    let env_variables['TM_SELECTED_TEXT'] = s:get_selection()
  else
    let stdin = "echo ". shellescape(getline(line('.'))) ." | "
  endif
  for key in keys(env_variables)
    let envs .= key ."=". substitute(shellescape(env_variables[key]), "\\\\\n", "\n", 'g') ." "
  endfor

  let exit = ""
  if has_key(a:options, 'exit_when_done') && remove(a:options, 'exit_when_done')
    let exit = ";exit"
  endif

  let args = ""
  for key in keys(a:options)
    let args .= " --". key ." '". a:options[key] ."'"
  endfor

  return stdin . envs ." ruby ". shellescape($HOME ."/.vim/ruby/ruby_amp/script/run") ." -c ". a:command . args . exit
endfunction

function s:run_in_terminal(script)
  call system("ruby -e \"" .
    \ "require 'rubygems'; require 'appscript';" .
    \ "term = Appscript.app('Terminal');" .
    \ "term.activate;" .
    \ "term.do_script \\\"" . substitute(a:script, '"', '\\\\\\"', 'g') . "\\\"\"")
endfunction

function s:get_selection()
  let begline = line("'<")
  let endline = line("'>")
  let multiline = begline != endline
  let line = begline
  let selection = ""
  while line <= endline
    if selection != ""
      let selection .= "\n"
    endif
    let txt = getline(line)
    let begcol = virtcol("'<")
    let endcol = virtcol("'>")
    if !multiline || visualmode() == "\<c-v>"
      let selection .= strpart(txt, begcol-1, endcol-begcol+1)
    elseif multiline && line == begline
      let selection .= strpart(txt, begcol-1, strlen(txt)-begcol+1)
    elseif multiline && line == endline
      let selection .= strpart(txt, 0, endcol)
    else
      let selection .= strpart(txt, 0, strlen(txt))
    endif
    let line= line + 1
  endwhile
  return selection
endfunction


" }}}1

" vim:set ft=vim ts=2 sw=2 sts=2:
