# EVE-minimizer is a resource-saving tool

Its primary purpose is to fully-utilize EVE Online's "throttling" mechanics by putting inactive windows out of focus and minimizing them. Without minimizing windows, even if they're out of focus, they still use resources.

# Dependencies

EVE-minimizer requires `kdotool` which needs to be compiled. Install it here: https://github.com/jinliu/kdotool

# Installation

1) Clone this repo and put `kdotool` in the repo folder.
2) Update `characters.txt` with the format "EVE - yourname" with a linebreak after.
3) Copy `switch1.sh` for each client you need a keybind for, changing to `switch2.sh` etc and editing line 8.
   - Once I figure out how to use arguments in Plasma's Shortcuts menu, I'll remove this and use args.
5) Set up your window manager's shortcuts. For Plasma, use `sh '~/Documents/eve-minimizer/switch1.sh'` etc.
