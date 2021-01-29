#!/usr/bin/env lua
-- add tap header to binary

--
local s = tonumber(assert(arg[2]))
local f = assert(arg[1])
f = io.open(f,"r")
assert(f)
local bin = f:read("a")
f:close()
--
f = io.open(arg[1]..".tap","w")
assert(f)
f:write(string.format("\x16\x16\x16\x16\x24\x00\x00\x80\xc7"))
f:write(string.char(math.floor((s+#bin)/256)))
f:write(string.char((s+#bin)%256))
f:write(string.char(math.floor(s/256)))
f:write(string.char(s%256))
f:write(string.format("%s\x00",arg[1]))
f:write(bin)
f:close()
