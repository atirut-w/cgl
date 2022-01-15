--- OpenComputers **C**ommon **G**raphics **L**ibrary
---
--- A general purpose graphics library for OpenComputers.
local cgl = {}
---@type GPUProxy
local gpu = require("component").gpu

--- Clear the screen.
function cgl.clear()
    local old_bg = gpu.getBackground()
    gpu.setBackground(0x000000)
    local w,h = gpu.getResolution()
    gpu.fill(1,1,w,h," ")
    gpu.setBackground(old_bg)
end

--- Draw a bitmap image at the specified position.
---
--- The data array is a one-dimensional array of pixel values.
--- Each pixel value is an RGB color value in the 0xRRGGBB format.
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param data integer[]
function cgl.draw_bitmap(x, y, width, height, data)
    assert(#data == width * height, "data array size mismatch")
    local old_bg = gpu.getBackground()
    for i = 1, #data do
        gpu.setBackground(data[i])
        gpu.set(x + (i - 1) % width, y + math.floor((i - 1) / width), " ")
    end
    gpu.setBackground(old_bg)
end

--- Cache a bitmap image into a framebuffer and return its index.
--- Can be used in combination with `cgl.draw_framebuffer()` to draw bitmaps more quickly.
---@param width integer
---@param height integer
---@param data integer[]
function cgl.cache_bitmap(width, height, data)
    local old_fb = gpu.getActiveBuffer()
    local index = gpu.allocateBuffer(width, height)
    gpu.setActiveBuffer(index)
    cgl.draw_bitmap(1, 1, width, height, data)
    gpu.setActiveBuffer(old_fb)
    return index
end

--- Draw a framebuffer at the specified position.
---@param x integer
---@param y integer
---@param index integer
function cgl.draw_framebuffer(x, y, index)
    local current_fb = gpu.getActiveBuffer()
    gpu.bitblt(current_fb, x, y, nil, nil, index, 1, 1)
end

return cgl