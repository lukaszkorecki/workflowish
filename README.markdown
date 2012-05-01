# Workflowish

Simple TODO manager/plugin/whatever for Vim, inspired by [Workflowy.com](https://workflowy.com/)

## Screenshot

![vimshot](http://f.cl.ly/items/3A1n1J1e3m1R2u463a1t/Screen%20shot%202012-03-03%20at%2017.45.35.png)


## Why?

It started with a [tweet](https://twitter.com/#!/lukaszkorecki/status/175637968348917760)

![tweetshot](http://f.cl.ly/items/1M21383X350K3k0j1j2O/Screen%20shot%202012-03-03%20at%2017.15.00.png)

Here's what was "attached":

    # vi: fen foldmethod=indent :
    * lol
      * lol
        * wat
        * wut
    +---  2 lines: * wee ------------------------------------------------------
        * meh
      * ouch

Then I started hacking on a little plugin-ish thing and came up with `workflowish`

![folded](http://f.cl.ly/items/2G3d070b2c3u0m302X0j/Screen%20shot%202012-03-03%20at%2017.08.50.png)

# How?

By defining a simple syntax in Vim and using brilliant [folding capabilities](http://vim.wikia.com/wiki/Folding) *workflowish* can simulate 99% of *Workflowy's* features.


### Features?

- searching (duh, it's, like, in Vim, broseph)
- deleting (as above)
- folding as a substitute for great `zoom` feature
- notes (just add `\` in the beginning of the line to start a comment)
- [vimgrep](http://vimdoc.sourceforge.net/htmldoc/quickfix.html#:vimgrep) for filtering lines
- todos:
  - a todo which is not completed is a line which starts with `*`
  - completed todo starts with a `-`
- convert from workflowy plain text export
  - in a `.wofl` file or after `:set ft=workflowish`, run `:call workflowish#convert_from_workflowy()` to convert the whole buffer

Thanks to the long running tradition, *workflowish* files have `.wofl` extension.

## Installing

[Use Tim Pope's Pathogen](https://github.com/tpope/vim-pathogen)

# Legal

[WTFPL](http://sam.zoy.org/wtfpl/), but please tell me if you're doing anything with it, k?
