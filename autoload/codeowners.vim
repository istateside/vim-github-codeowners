scriptencoding utf-8

let s:cache = {}

function! codeowners#reset()
  let s:cache = {}
endfunction

function! codeowners#getGitRootDir()
  return split(system('git rev-parse --show-toplevel'))[0]
endfunction

function! codeowners#getCodeownersPath()
  let l:root = codeowners#getGitRootDir()
  return l:root . '/' . findfile('CODEOWNERS', l:root)
endfunction

function! codeowners#isCodeownersFileExist()
  return filereadable(codeowners#getCodeownersPath())
endfunction

function! codeowners#whoBufname()
  return codeowners#who(bufname())
endfunction

function! codeowners#who(file)
  if !has_key(s:cache, a:file)
    if !codeowners#isCodeownersFileExist()
      let s:cache[a:file] = "Unloved"
    else
      let s:bin = globpath(&rtp, "node_modules/.bin/github-codeowners") 
      let l:output = system(s:bin . " -c " . codeowners#getCodeownersPath() . " who " . a:file)
      let s:cache[a:file] = get(split(l:output), 1, "Unloved") 
    endif
  endif

  return s:cache[a:file]
endfunction
