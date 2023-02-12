#!/usr/bin/env lua

--              _
--  ___ ___ _ _|_|___ ___
-- |  _| .'|_'_| |_ -|_ -|
-- |_| |__,|_,_|_|___|___|
--  iss@raxiss(c)2020,2023

-- usage:
--  report-csv-js.lua <date> <opt> <input-opt.csv> <output-opt.js> [date]

--
local opt = assert(arg[1])
local csvfile = assert(arg[2])
local jsfile = assert(arg[3])
local date = arg[4]

local fo = nil

local data = {}
local benches = {}
local compilers = {}

local function split(text,delimiter)
  local list,pos = {},1
  while 1 do
    local first,last = string.find(text,delimiter,pos)
    if first then
      table.insert(list,string.sub(text,pos,first-1))
      pos = last+1
    else
      table.insert(list,string.sub(text,pos))
      break
    end
  end
  return list
end

local function report_load(frep)
  frep = assert(io.open(frep,'r'))
  for l in frep:lines() do
    l = split(l:gsub('"',''),',')
    local compiler = l[1]
    local bench = l[2]
    local size = l[3]
    local clocks = l[5]
    local status = l[6]
    table.insert(data,{
      compiler = compiler,
      bench = bench,
      size = size,
      instructions = l[4],
      clocks = clocks,
      status = status,
    })
    if not compilers[compiler] then
      table.insert(compilers,compiler)
      compilers[compiler] = compiler
    end
    if not benches[bench] then
      table.insert(benches,bench)
      benches[bench] = bench
    end
    data[compiler..'+'..bench..'+size'] = tonumber(size)
    data[compiler..'+'..bench..'+speed'] = tonumber(clocks)
    data[compiler..'+'..bench..'+status'] = status
  end
  frep:close()
end

local function o(...) fo:write(string.format(...)) end

local js = 'var bench_'..opt..' = {\n'
local jsend = '};\n'

local row = '\t%s: [ '
local rowend = ' ],\n'

local cell = '%s,'

local function report_js(opt)
  --
  if date then o('var date_'..opt..' = "%s";',date) end
  --
  o(js)
  for b = 1,#benches do
    o(row,benches[b]:gsub('-','_'))
    for c = 1,#compilers do
      local val = data[compilers[c]..'+'..benches[b]..'+'..opt]
      local status = tonumber(data[compilers[c]..'+'..benches[b]..'+status'])
      if 0 == status then
        -- OK, no error
      elseif 1 == status then
        val = '"C"' -- Compile error
      elseif 2 == status then
        val = '"T"' -- Time-out error
      elseif 3 == status then
        val = '"R"' -- Run-time error
      end
      o(cell,val)
    end
    o(rowend)
  end
  o(jsend)
end

local function report(frep)
  --
  report_load(frep)
  --
  fo = assert(io.open(jsfile,'w'))
  report_js(opt)
  fo:close()
end

report(csvfile)
