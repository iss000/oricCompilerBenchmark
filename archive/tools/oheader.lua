#!/usr/bin/env lua
-- add tap header to binary

-- ChangeLog:
-- 2022-06025: update for lua 5.3 @Mihai Dragan

--
local s = tonumber(assert(arg[2]))
local f = assert(arg[1])
f = io.open(f,"r")
assert(f)
local bin = f:read("*all")
f:close()
--
f = io.open(arg[1]..".tap","w")
assert(f)
f:write(string.format("%c%c%c%c%c",0x16,0x16,0x16,0x16,0x24))
f:write(string.char(0x00))
f:write(string.char(0x00))
f:write(string.format("%c%c",0x80,0xc7))
f:write(string.char(math.floor((s+#bin)/256)))
f:write(string.char((s+#bin)%256))
f:write(string.char(math.floor(s/256)))
f:write(string.char(s%256))
f:write(string.format("%s",arg[1]))
f:write(string.char(0x00))
f:write(bin)
f:close()
