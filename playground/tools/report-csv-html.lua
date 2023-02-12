#!/usr/bin/env lua

--              _
--  ___ ___ _ _|_|___ ___
-- |  _| .'|_'_| |_ -|_ -|
-- |_| |__,|_,_|_|___|___|
--  iss@raxiss(c)2020,2023

-- Obsolete! Do not use it.

-- usage:
--  report-csv-html.lua <input.csv> <output.html>

--
local csvfile = assert(arg[1])
local htmlfile = assert(arg[2])

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
    data[compiler..'+'..bench..'+clocks'] = tonumber(clocks)
    data[compiler..'+'..bench..'+status'] = status
  end
  frep:close()
end

local function o(...) fo:write(string.format(...)) end

local html = [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="en">
<head>
<meta charset="UTF-8">
<title>MOS6502 compiler suite &copy;</title>
<link type="text/css" rel="stylesheet" href="bench.css" media="all" />

<script>
(function() {
var favIcon = "AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAA"+
"QAABILAAASCwAAAAAAAAAAAAAAAAAAAAAABAALFBEADBgbAAoUIAAJEiQAChImAAUIJQAEBy"+
"UAChImAAkSJAAJFCEACxccAAsUEwAAAAYAAAEAABwnAAAABggFia+CGKXEwx6mw8IZocHDA5"+
"e/wx5virUja4SyAZW+wxaewcMepMPCGqTEwwiMsY8AGioPAEtoAACGuQDp//8AI7PXf3Tc7f"+
"6J5vL/dd7v/xe53f9Vma7/YZmr/w+02v9p2e7/ieXy/33f7/82utuQAABKAQCMwAAAAAAARL"+
"nbACax2g6IvsuYpNDa/3rD1f9srb//rbS2/7O3uf9xrr//b7/T/6HP2v+Uws2iV8HgFHfO5Q"+
"AAWZ8AAAAAABAODgAAAAAIaGhoqri9v/+/xMX/ycfH/8zMzP/NzMz/y8nI/8HExv+2u73/Zm"+
"dnswAAAAsdGxsAAAAAAAQEBAQAAAAAAAAAMEREROvNzMz/1NTU/9PT0//T09P/09PT/9PT0/"+
"/U1NT/ycnJ/z4+PvEAAAA6AAAAAB4eHgUUFBR6HR0ddQAAAGcxMTH6z8/P/9zc3P/b29v/29"+
"vb/9vb2//b29v/3Nzc/8rKyv8pKSn9AQEBfRYWFoYLCwtyNzc3SkBAQNsSEhLvExMT/rq6uv"+
"/o6Oj/5uXl/97c3P/d3Nz/5eXl/+jo6P+zs7P/Dg4O/w0NDfclJSXmFBQUTqioqABaWlo+MT"+
"Ex0gUFBf9mZmb/7Ozs/+Tk5f+LxND/g8bS/+nr6//r6+v/XV1d/"+
"wYGBv8xMTHeQkJCTgAAAAESEhIAHBwcACEhITUICAjeCwsL/4aEhP+Ru8b/H8ro/0nd7v/B2t3/gH9//"+
"wgICP8MDAzhJCQkPzk5OQAPDw8AAAAAAAUFBQAAAAAAAAAAiAYGBv+JiIj/scvS/1Wjsv+AsLf/u8nL/"+
"3V0dP8HBwf/AQEBfgAAAAADAwMAAAAAAAAAAAAAAAAAAAAAAAAAAFsWFhb+uLi4/9PR0f9lY2P/ampq/"+
"9va2v/BwcH/Ghoa+QAAAEkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA1GRkZ7aCgoP/q6ur/pKSk/"+
"29vb/+urq7/eXl5/w0NDeUAAAAnAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACTg4OKqIiIj/p6en/"+
"5WVlf+Wlpb/k5OT/39/f/"+
"8dHR2oAAAABwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFZWVgA4ODgsoaGhysjIyP/U1NT/2NjY/"+
"87Ozv5/f3/ICAgILhkZGQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAwMA////"+
"AHZ2dim2trabzc3N2crKytOioqKMQkJCI8rKygAAAAAAAAAAAAAAAAAAAAAAgAEAAIABAADAAQAAwAMA"+
"AMADAABAAgAAAAAAAAAAAACAAAAAwAMAAOAHAADgBwAA4AcAAOAHAADwDwAA+B8AAA==";
var docHead = document.getElementsByTagName('head')[0];
var newLink = document.createElement('link');
newLink.rel = 'shortcut icon';
newLink.type = 'image/x-icon';
newLink.href = 'data:image/png;base64,'+favIcon;
docHead.appendChild(newLink);
})();
</script>
</head>

<body>
]]

local htmlend = [[
</body>
</html>
]]


local hdr = [[<br><div><table><thead><tr align="center"><th style="min-width:190px;" align="center">%s</th>]]
local hdrcell = '<th align="center">%s</th>'
local hdrend = [[</tr></thead><tbody><tr>]]

local row = '<td align="right">%s</td>'
local cell = '<td align="right">%s</td>'
local rowend = '</tr>'

local ftr = [[</tbody></table></div><br><br>]]

local function report_form(title,criteria)
  --
  o(hdr,title)
  for c = 1,#compilers do
    o(hdrcell,compilers[c])
  end
  o(hdrend)
  --
  for b = 1,#benches do
    o(row,benches[b])
    for c = 1,#compilers do
      local size = data[compilers[c]..'+'..benches[b]..'+'..criteria]
      if 0 == tonumber(size) then
        size = '<text style="color:#888">C</text>'
      elseif 300000000 <= tonumber(size) then
        size = '<text style="color:#888">R</text>'
      end
      o(cell,size)
    end
    o(rowend)
  end
  o(ftr)
end

local function report(frep)
  --
  report_load(frep)
  --
  fo = assert(io.open(htmlfile,'w'))
  --
  o(html)
  report_form('Size / Compiler','size')
  report_form('CPU-cycles / Compiler','clocks')
  o(htmlend)
  --
  fo:close()
end

report(csvfile)
