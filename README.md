# nixCats-nvim

![Image](https://github.com/user-attachments/assets/348796ea-d9d5-4d02-a529-a15ad9acb6c9)

Accompanying article: https://devctrl.blog/posts/how-to-use-nixcat-nvim-in-nix-os/

## Changes

I recommend you compare and contrast mine with the [example template](https://github.com/BirdeeHub/nixCats-nvim/tree/main/templates/example). Here's a high-level overview:

1. Removed the fallback `paq-nvim` package manager when not on Nix. I will never *NOT* be on Nix and I don't want to maintain a separate plugin list.
2. Keep a minimal `categories` to simplify the setup, i.e., I don't need to toggle on and off and risk wondering why the new plugin is not working (it's not enabled).
3. Get rid of `for_cat` handler for this fine control I don't need
4. I absolutely did not touch `nixCatsUtils`
