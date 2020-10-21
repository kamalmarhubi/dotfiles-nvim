# my neovim config & plugins

This is the new thing. The [old thing][dotfiles-vim] is old.

[dotfiles-vim]: https://github.com/kamalmarhubi/dotfiles-vim

## lua

This is all in lua because I'm not working right now and I have the time. Until
[neovim #7895][issue-init.lua] is resolved, this requires a small `init.vim`
that just loads the lua config.

[issue-init.lua]: https://github.com/neovim/neovim/issues/7895

## plugin management

I have decided to vendor plugins using git-subtree(1). There's a bash script
called vinstall to handle thiss. It's in bash because I have problems.

The main reason for this is I would like to just clone my nvim config and move
on. A step like `PlugInstall` or the equivalent can fail, and making it
deterministic is a pain of specifying git commits or tags.
