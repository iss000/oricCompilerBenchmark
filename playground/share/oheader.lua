#!/usr/bin/env lua

--              _
--  ___ ___ _ _|_|___ ___
-- |  _| .'|_'_| |_ -|_ -|
-- |_| |__,|_,_|_|___|___|
--  iss@raxiss(c)2020,2023

-- add Oric autostart tap header to binary
-- usage: oheader <binary.bin> <load address>

--
local f = assert(io.open(arg[1],'r'))
local s = tonumber(assert(arg[2]))
local bin = f:read('a')
f:close()
--
f = assert(io.open(arg[1]:gsub('%.bin$','.tap'),'w'))
f:write(string.format('\x16\x16\x16\x16\x24\x00\x00\x80\xc7'))
f:write(string.char(math.floor((s+#bin)/256)))
f:write(string.char((s+#bin)%256))
f:write(string.char(math.floor(s/256)))
f:write(string.char(s%256))
f:write(arg[3] or string.char(0))
f:write(string.char(0))
f:write(bin)
f:close()
