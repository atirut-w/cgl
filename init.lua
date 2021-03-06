--- OpenComputers **C**ommon **G**raphics **L**ibrary
---
--- A general purpose graphics library for OpenComputers.
local cgl = {}
---@type GPUProxy
local gpu = require("component").gpu

--- Clear the screen with the given color.
---@param color integer
function cgl.clear(color)
    local old_bg = gpu.getBackground()
    color = color or 0x000000
    gpu.setBackground(color)
    local w,h = gpu.getResolution()
    gpu.fill(1,1,w,h," ")
    gpu.setBackground(old_bg)
end

--- Draw a bitmap image at the specified position.
---
--- The data array is a one-dimensional array of pixel values.
--- Each pixel value is an RGB color value in the 0xRRGGBB format.
---
--- When drawing in half-height mode, the image's height should be a multiple of 2. Otherwise, the image will end with an incomplete line.
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param data integer[]
---@param halfheight? boolean
function cgl.draw_bitmap(x, y, width, height, data, halfheight)
    assert(#data == width * height, "data array size mismatch")
    halfheight = halfheight or false
    local old_bg = gpu.getBackground()

    if not halfheight then
        for i = 1, #data do
            gpu.setBackground(data[i])
            gpu.set(x + (i - 1) % width, y + math.floor((i - 1) / width), " ")
        end
    else
        local row = 0
        for line = 1, height / 2 do
            for column = 1, width do
                gpu.setForeground(data[row * width + column])
                gpu.setBackground(data[(row + 1) * width + column] or 0x000000)
                gpu.set(x + column - 1, y + line - 1, utf8.char(0x2580))
            end
            row = row + 2
        end
    end

    gpu.setBackground(old_bg)
end

--- Cache a bitmap image into a framebuffer and return its index.
--- Can be used in combination with `cgl.draw_framebuffer()` to draw bitmaps more quickly.
---@param width integer
---@param height integer
---@param data integer[]
---@param halfheight? boolean
---@return integer
function cgl.cache_bitmap(width, height, data, halfheight)
    local old_fb = gpu.getActiveBuffer()
    local index = gpu.allocateBuffer(width, halfheight and height / 2 or height)
    gpu.setActiveBuffer(index)
    cgl.draw_bitmap(1, 1, width, height, data, halfheight)
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