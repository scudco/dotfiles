if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet do do<CR>".st.et."<CR>end".st.et
exec "Snippet class class ".st."className".et."<CR>".st.et."<CR>end".st.et
exec "Snippet begin begin<CR>".st.et."<CR>rescue ".st."Exception".et." => ".st."e".et."<CR>".st.et."<CR>end".st.et
exec "Snippet each_with_index each_with_index do |".st."element".et.", ".st."index".et."|<CR>".st.et."<CR>end".st.et
exec "Snippet collecto collect { |".st."element".et."| ".st.et." }".st.et
exec "Snippet forin for ".st."element".et." in ".st."collection".et."<CR>".st.et."<CR>end".st.et
exec "Snippet doo do |".st."object".et."|<CR>".st.et."<CR>end".st.et
exec "Snippet : :".st."key".et." => \"".st."value".et."\"".st.et."".st.et
exec "Snippet def def ".st."methodName".et."<CR>".st.et."<CR>end".st.et
exec "Snippet case case ".st."object".et."<CR>when ".st."condition".et."<CR>".st.et."<CR>end".st.et
exec "Snippet collect collect do |".st."element".et."|<CR>".st.et."<CR>end".st.et
exec "Snippet eacho each { |".st."element".et."| ".st.et." }".st.et
exec "Snippet each_with_indexo each_with_index { |".st."element".et.", ".st."idx".et."| ".st.et." }".st.et
exec "Snippet if if ".st."condition".et."<CR>".st.et."<CR>end".st.et
exec "Snippet each each do |".st."element".et."|<CR>".st.et."<CR>end".st.et
exec "Snippet unless unless ".st."condition".et."<CR>".st.et."<CR>end".st.et
exec "Snippet ife if ".st."condition".et."<CR>".st.et."<CR>else<CR>".st.et."<CR>end".st.et
exec "Snippet when when ".st."condition".et."".st.et
exec "Snippet select select do |".st."element".et."|<CR>".st.et."<CR>end".st.et
exec "Snippet inject inject(".st."object".et.") do |".st."injection".et.", ".st."element".et."| <CR>".st.et."<CR>end".st.et
exec "Snippet rejecto reject { |".st."element".et."| ".st.et." }".st.et
exec "Snippet reject reject do |".st."element".et."| <CR>".st.et."<CR>end".st.et
exec "Snippet injecto inject(".st."object".et.") { |".st."injection".et.", ".st."element".et."| ".st.et." }".st.et
exec "Snippet selecto select { |".st."element".et."| ".st.et." }".st.et
exec "Snippet mapo map { |".st."element".et."| ".st.et." }".st.et
exec "Snippet map map do |".st."element".et."| <CR>".st.et."<CR>end".st.et
