-- Tests for adjusting window and contents

local helpers = require('test.functional.helpers')(after_each)
local Screen = require('test.functional.ui.screen')

local wait = helpers.wait
local clear = helpers.clear
local insert = helpers.insert
local command = helpers.command

if helpers.pending_win32(pending) then return end

describe('107', function()
  setup(clear)

  it('is working', function()
    local screen = Screen.new()
    screen:attach()

    insert('start:')
    wait()
    command('new')
    command('call setline(1, range(1,256))')
    command('let r=[]')
    command('func! GetScreenStr(row)')
    command('   let str = ""')
    command('   for c in range(1,3)')
    command('       let str .= nr2char(screenchar(a:row, c))')
    command('   endfor')
    command('   return str')
    command('endfunc')
    command([[exe ":norm! \<C-W>t\<C-W>=1Gzt\<C-W>w\<C-W>+"]])
    command('let s3=GetScreenStr(1)')
    command('wincmd p')
    command('call add(r, [line("w0"), s3])')
    command([[exe ":norm! \<C-W>t\<C-W>=50Gzt\<C-W>w\<C-W>+"]])
    command('let s3=GetScreenStr(1)')
    command('wincmd p')
    command('call add(r, [line("w0"), s3])')
    command([[exe ":norm! \<C-W>t\<C-W>=59Gzt\<C-W>w\<C-W>+"]])
    command('let s3=GetScreenStr(1)')
    command(':wincmd p')
    command('call add(r, [line("w0"), s3])')
    command('bwipeout!')
    command('$put=r')
    command('call garbagecollect(1)')

    screen:expect([[
      start:                                               |
      [1, '1  ']                                           |
      [50, '50 ']                                          |
      ^[59, '59 ']                                          |
      ~                                                    |
      ~                                                    |
      ~                                                    |
      ~                                                    |
      ~                                                    |
      ~                                                    |
      ~                                                    |
      ~                                                    |
      ~                                                    |
      :call garbagecollect(1)                              |
    ]])
  end)
end)
