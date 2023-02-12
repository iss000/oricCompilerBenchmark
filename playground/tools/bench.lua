#!/usr/bin/env lua

--              _
--  ___ ___ _ _|_|___ ___
-- |  _| .'|_'_| |_ -|_ -|
-- |_| |__,|_,_|_|___|___|
--  iss@raxiss(c)2020,2023

-- usage:
--  bench.lua <size|speed> [compiler|bench|<compiler bench>]
--    where compiler and bench are ... (see arrays below)

local opt = assert(arg[1])
local csvfile = 'www/bench-'..opt..'.csv'

local verbose = false         -- verbose compile and run

local debug_compile = 0       -- verbose compilation level (0,1,2,3)
local debug_run_info = 1      -- mos6502vm shows some info (0,1)
local debug_run_dump = 0      -- dumps mos6502vm memory to file (0,1)
local debug_run_trace = 0     -- 6502 step-by-step disassembler (0,1,2)

local scondstorun = 60*5
local sastringhex = '0800'
local sanumber = tonumber('0x'..sastringhex)
local sastring = tostring(sanumber)
--
local function err(s) print('[ERR] '..(s or 'Unknown error.')) os.exit(1) end
local function msg(...) if verbose then print(...) end end
local function exec(cmd) return os.execute(table.concat(cmd,' ')) end
local function cmdadd(...) table.insert(...) end

local compilers = {
  'cc65',
  'gcc-6502',
  'kickc',
  'llvm-mos',
  'osdk-lcc65',
  'sdcc',
  'vbcc',
  }

local benches = {
  'dummy',
  'hello-world',
  'type-sizes',
  'memcopy',
  'sieve',
  'aes256',
  'mandelbrot',
  'bytecpy',
  'frogmove',
  'pi',
  'bubble-sort',
  'selection-sort',
  'insertion-sort',
  'merge-sort',
  'quick-sort',
  'counting-sort',
  'radix-sort',
  'shell-sort',
  'heap-sort',
  }

local benches_output = {
  ['dummy'] = nil,

  ['hello-world'] =
                'HELLO 6502 WORLD!',

  ['type-sizes'] = nil,
                -- "SIZE OF CHAR  :1"..
                -- "SIZE OF SHORT :2"..
                -- "SIZE OF INT   :2"..
                -- "SIZE OF LONG  :4",

  ['memcopy'] = nil,

  ['sieve'] = nil,

  ['aes256'] =  'TXT: AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55'..
                'KEY: 000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F'..
                '---- ----------------------------------------------------------------'..
                'ENC: DD2EF27CA800C474EB1B13C853D45EC0DD2EF27CA800C474EB1B13C853D45EC0'..
                'OK?: DD2EF27CA800C474EB1B13C853D45EC0DD2EF27CA800C474EB1B13C853D45EC0'..
                '---- ----------------------------------------------------------------'..
                'DEC: AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55',

  ['mandelbrot'] = nil,

  ['bytecpy'] = nil,

  ['frogmove'] = 'Moved!',

  ['pi'] =      -- https://www.piday.org/million/
                'pi=3.1415926535897932384626433832795028841971693993751058209749445923'..
                '078164062862089986280348253421170679821480865132823066470938446095505'..
                '82231725359408128481117450',

  ['bubble-sort']     = '0,2,9,11,24,45,57,71,88,100',
  ['selection-sort']  = '0,2,9,11,24,45,57,71,88,100',
  ['insertion-sort']  = '0,2,9,11,24,45,57,71,88,100',
  ['merge-sort']      = '0,2,9,11,24,45,57,71,88,100',
  ['quick-sort']      = '0,2,9,11,24,45,57,71,88,100',
  ['counting-sort']   = '0,2,9,11,24,45,57,71,88,100',
  ['radix-sort']      = '0,2,9,11,24,45,57,71,88,100',
  ['shell-sort']      = '0,2,9,11,24,45,57,71,88,100',
  ['heap-sort']       = '0,2,9,11,24,45,57,71,88,100',
  }

--
-- see share/*/x-cc.sh for more compiler flags
--
local compilers_make_param = {
  ['cc65'] = '',
  ['gcc-6502'] = '',
  ['kickc'] = '',
  ['llvm-mos'] = '-D__LLVM_MOS__ -Wno-shift-negative-value',
  ['osdk-lcc65'] = '',
  ['sdcc'] = '',
  ['vbcc'] = '',
  }

local compilers_make_param_size = {
  ['cc65']        = '-O',
  ['gcc-6502']    = '-O2',
  ['kickc']       = '',
  ['llvm-mos']    = '-O2',
  ['osdk-lcc65']  = '-O2',
  ['sdcc']        = '--opt-code-size',
  ['vbcc']        = '-O=991',
  }

local compilers_make_param_speed = {
  ['cc65']        = '-Oirs',
  ['gcc-6502']    = '-O3',
  ['kickc']       = '-Ocoalesce -Oliverangecallpath -Oloophead',
  ['llvm-mos']    = '-O3',
  ['osdk-lcc65']  = '-O3',
  ['sdcc']        = '--opt-code-speed --peep-asm --peep-return',
  ['vbcc']        = '-O=1023',
  }

local compilers_make_param_default = {
  ['cc65']        = '',
  ['gcc-6502']    = '',
  ['kickc']       = '',
  ['llvm-mos']    = '-O',
  ['osdk-lcc65']  = '',
  ['sdcc']        = '',
  ['vbcc']        = '-O=-1',
  }

--
local function min(a,b)
  if not a then return b end
  if not b then return a end
  return a<b and a or b
end

local function max(a,b)
  if not a then return b end
  if not b then return a end
  return a>b and a or b
end


local function compile(c,b,bdir)
  bdir = bdir or b
  local cmd = {}
  cmdadd(cmd,'make -f share/Makefile ') --.. --silent')
  cmdadd(cmd,'START='..sastring)
  cmdadd(cmd,'BASE=../bin/'..c)
  cmdadd(cmd,'BENCH="'..b..'"')
  cmdadd(cmd,'BENCHD="'..bdir..'"')
  cmdadd(cmd,'COMPILER='..c)
  cmdadd(cmd,'CFLAGS="'..(compilers_make_param[c] or '')..'"')

  if 'size' == opt then cmdadd(cmd,'OPT="'..(compilers_make_param_size[c] or '')..'"')
  elseif 'speed' == opt then cmdadd(cmd,'OPT="'..(compilers_make_param_speed[c] or '')..'"')
  else cmdadd(cmd,'OPT="'..(compilers_make_param_default[c] or '')..'"')
  end

  cmdadd(cmd,0<debug_compile and 'SILENT=""' or '')
  cmdadd(cmd,0<debug_compile and 'QQQ=@echo' or '')
  cmdadd(cmd,1<debug_compile and 'QQ=' or '')
  cmdadd(cmd,2<debug_compile and 'Q=' or '')

  cmdadd(cmd,0<debug_compile and '' or '>/dev/null 2>&1')

  msg(table.concat(cmd,'\n'))
  return exec(cmd)
end

local function run(c,b,bdir,fres)
  msg('running:',b,c)
  local cmd = {}
  cmdadd(cmd,'../bin/mos6502vm')
  cmdadd(cmd,0<debug_run_trace and '-v' or '')
  cmdadd(cmd,1<debug_run_trace and '-v' or '')
  cmdadd(cmd,0<debug_run_dump and ('-d bin/'..c..'-'..b..'-dump.bin') or '')
  cmdadd(cmd,0<debug_run_info and '' or '-q')
  cmdadd(cmd,'-a '..sastringhex)
  cmdadd(cmd,'-s '..scondstorun)
  cmdadd(cmd,sastringhex..':bin/'..c..'-'..b..'.bin')
  msg(table.concat(cmd,'\n'))

  local r = '"'..c..'","'..b..'",'
  local t = ''
  local f = io.popen(table.concat(cmd,' '))
  local stat = '"Pass"'
  for l in f:lines() do
    l = l:gsub('\r',''):gsub('\n','')
    if l then
      if '[' == l:sub(1,1) and l:find('] ') then
        if 0<debug_run_info then print(l) end
      elseif '[' == l:sub(1,1) and ']' == l:sub(#l,#l) then
        if 'exit:' == l:sub(2,6) then
          l = l:sub(7,#l-1)
          local wc = 1
          for w in l:gmatch('[^,%s]+') do
            if 4 == wc then
              stat = w
            else
              r = r..w..','
            end
            wc = wc+1
          end
        end
      else
        --print("|"..l.."|")
        t=t..'\n'..l
      end
    end
  end

  if 0<debug_run_info then print(t..'\n') end

  if '"Pass"' == stat then
    if benches_output[b] then
      if t:gsub('\r',''):gsub('\n','') == benches_output[b]:gsub('\r',''):gsub('\n','') then
        stat = '0'
      else
        stat = '3'
      end
    else
      stat = '0'
    end
  else
    stat = '2'
  end

  r = r..stat..'\n'
  io.write(r)
  if fres then fres:write(r) end

  msg''
end

local function bench(c,b,bdir,fres)
  msg('bench '..c..':'..b)
  if compile(c,b,bdir) then
    run(c,b,bdir,fres)
  else
    local t = '"'..c..'","'..b..'",0,0,0,1'
    io.write(t..'\n')
    if fres then fres:write(t..'\n') end
  end
end

local benches_dirs= {}

for i = 1,#benches do
  benches_dirs[benches[i]] =
      string.format("%02d-%s",i-1,benches[i])
end

local function one_bench(c,b)
  bench(c,b,benches_dirs[b])
end

local function by_compiler(b)
  for c=1,#compilers do
    bench(compilers[c],b,benches_dirs[b])
  end
end

local function by_bench(c)
  for b=1,#benches do
    if '' ~= benches[b] then
      bench(c,benches[b],benches_dirs[benches[b]])
    end
  end
end

local function allbench(first,last)
  debug_compile = 0
  debug_run_dump = 0
  debug_run_info = 0
  debug_run_trace = 0
  local fres = io.open(csvfile,'w')
  for b=max(1,first),min(last,#benches) do
    if '' ~= benches[b] then
      for c=1,#compilers do
        bench(compilers[c],benches[b],benches_dirs[benches[b]],fres)
      end
    end
  end
  if fres then fres:close() end
end

local function is_compiler(s)
  local rc = nil
  for _,ss in ipairs(compilers) do
    if s == ss then rc = s end
  end
  return rc
end

if arg[3] then
  one_bench(arg[2],arg[3])
elseif arg[2] then
  if is_compiler(arg[2]) then
    by_bench(arg[2])
  else
    by_compiler(arg[2])
    end
else
  allbench()
end
