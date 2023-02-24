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

--
-- load optimizations params
--
dofile(arg[0]:gsub('report.csv.js.lua','bench-params.lua'))

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
    if 'type-sizes' == bench then
      data[compiler..'+'..bench..'+info'] =
        string.format('char:%s<br>short:%s<br>int:%s<br>long:%s',l[3],l[4],l[5],l[6])
    else
      data[compiler..'+'..bench..'+size'] = tonumber(size)
      data[compiler..'+'..bench..'+speed'] = tonumber(clocks)
      data[compiler..'+'..bench..'+status'] = status
    end
  end
  frep:close()
end

local function o(...) fo:write(string.format(...)) end

local js = 'var bench_'..opt..' = {\n'
local row = '\t%s: { size: [ %s ], speed: [ %s ] },\n'
local jsend = '};\n'

local function key_pairs(t)
  local a = {}
  for n in pairs(t) do
    table.insert(a, n)
  end
  table.sort(a)
  local i = 0
  local iter = function ()
    i = i + 1
    if a[i] == nil then
      return nil
    else
      return a[i], t[a[i]]
    end
  end
  return iter
end

local function report_js(opt)
  --
  o("var opt_size = {\n")
    for i,j in key_pairs(compilers_make_param_size) do
    o('\t"%s": "%s",\n',i,j)
  end
  o("};\n\n")
  --
  o("var opt_speed = {\n")
    for i,j in key_pairs(compilers_make_param_speed) do
    o('\t"%s": "%s",\n',i,j)
  end
  o("};\n\n")
  --
  o(js)
  for b = 1,#benches do
    local sizes =''
    local speeds =''
    if 'type-sizes' == benches[b] then
      for c = 1,#compilers do
        sizes = sizes..'"'..data[compilers[c]..'+'..benches[b]..'+info']..'"'..','
      end
      speeds = sizes
      o(row,'"'..benches[b]..'"',sizes,speeds)

    else
      -- size
      for c = 1,#compilers do
        local val = data[compilers[c]..'+'..benches[b]..'+size']
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
        sizes = sizes..val..','
      end
      -- speed
      for c = 1,#compilers do
        local val = data[compilers[c]..'+'..benches[b]..'+speed']
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
        speeds = speeds..val..','
      end
      o(row,'"'..benches[b]..'"',sizes,speeds)
    end
  end
  o(jsend)
end

local function report(frep)
  --
  report_load(frep)
  --
  if date then
    fo = assert(io.open(jsfile:gsub('bench','date'),'w'))
    o('var date_'..opt..' = "%s";\n',date)
    fo:close()
  end
  --
  fo = assert(io.open(jsfile,'w'))
  report_js(opt)
  fo:close()
  --
  fo = assert(io.open(jsfile,'w'))
  report_js(opt)
  fo:close()
end

report(csvfile)
