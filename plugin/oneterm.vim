" oneterm.vim        one terminal in vim
"
" Author:   jiahut@gmail.com 
" HomePage: https://github.com/jiahut
"
" License:  The MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.
"
" Thread:    https://www.reddit.com/r/vim/comments/8vwq5a/vim_81_terminal_is_great/
if !has("terminal")
    echom "[oneterm.vim] vim (8.1+) should have compiled with enable +terminal feature "
    finish
endif

if !exists("g:oneterm") 
    let g:oneterm = {}
endif

let g:oneterm.row = 15
let g:oneterm.pos = "below"
let g:oneterm.opened = v:false


fun! oneterm.getOrCreate() dict
  if exists("self.main") && bufexists(self.main)
    " echom "show " . self.main
    exe self.pos .. ' ' .. self.row .. 'sp'
    exe "buf " .. self.main
    let cur = winnr()
    exe cur .. 'wincmd w'
  else
    let cur = winnr()
    exe self.pos .. ' terminal ++rows=' .. self.row .. ' ++kill=term'
    let self.main = bufnr("$")
    " echom "main " . self.main
    exe cur .. 'wincmd w'
  endif
  let self.opened = v:true
endfun

fun! oneterm.hide() dict
  if exists("self.main") && bufexists(self.main)
    let win = bufwinnr(self.main)
    let cur = winnr()
    let cur = win > cur ? cur : cur-1
    exe win .. 'hide'
    exe cur .. 'wincmd w'
  endif
  let self.opened = v:false
endfun

fun! oneterm.toggle() dict
    if self.opened
        call self.hide()
    else
        call self.getOrCreate()
    endif
endfun

" com! -nargs=*  Sshow call oneterm.getOrCreate(<q-args>)
" com! -nargs=0  Shide call oneterm.hide()
com! -nargs=0  Ttoggle call oneterm.toggle()

nnor <silent> <Leader>' :Ttoggle<CR>
