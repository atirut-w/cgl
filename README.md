# OpenComputers **C**ommon **G**raphics **L**ibrary
A general purpose graphics library for OpenComputers

# Features
As of currently, the library is very basic and only have functions for drawing bitmaps, caching bitmaps, and drawing framebuffers at a specified position.

# Using the library
1. Clone this repository into the same directory as your main Lua script. Even better, if your project already uses Git, add this repository as a submodule.
2. Simply `require` the library by the name of the directory you cloned this library to. For example, if you cloned the repository as-is, the directory name would be `cgl`:
```lua
local cgl = require("cgl")
```
