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

  ['sieve'] =   '2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 '..
                '101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181 191 '..
                '193 197 199 211 223 227 229 233 239 241 251 257 263 269 271 277 281 283 '..
                '293 307 311 313 317 331 337 347 349 353 359 367 373 379 383 389 397 401 '..
                '409 419 421 431 433 439 443 449 457 461 463 467 479 487 491 499 503 509 '..
                '521 523 541 547 557 563 569 571 577 587 593 599 601 607 613 617 619 631 '..
                '641 643 647 653 659 661 673 677 683 691 701 709 719 727 733 739 743 751 '..
                '757 761 769 773 787 797 809 811 821 823 827 829 839 853 857 859 863 877 '..
                '881 883 887 907 911 919 929 937 941 947 953 967 971 977 983 991 997 1009 '..
                '1013 1019 1021 1031 1033 1039 1049 1051 1061 1063 1069 1087 1091 1093 1097 '..
                '1103 1109 1117 1123 1129 1151 1153 1163 1171 1181 1187 1193 1201 1213 1217 '..
                '1223 1229 1231 1237 1249 1259 1277 1279 1283 1289 1291 1297 1301 1303 1307 '..
                '1319 1321 1327 1361 1367 1373 1381 1399 1409 1423 1427 1429 1433 1439 1447 '..
                '1451 1453 1459 1471 1481 1483 1487 1489 1493 1499 1511 1523 1531 1543 1549 '..
                '1553 1559 1567 1571 1579 1583 1597 1601 1607 1609 1613 1619 1621 1627 1637 '..
                '1657 1663 1667 1669 1693 1697 1699 1709 1721 1723 1733 1741 1747 1753 1759 '..
                '1777 1783 1787 1789 1801 1811 1823 1831 1847 1861 1867 1871 1873 1877 1879 '..
                '1889 1901 1907 1913 1931 1933 1949 1951 1973 1979 1987 1993 1997 1999 2003 '..
                '2011 2017 2027 2029 2039 2053 2063 2069 2081 2083 2087 2089 2099 2111 2113 '..
                '2129 2131 2137 2141 2143 2153 2161 2179 2203 2207 2213 2221 2237 2239 2243 '..
                '2251 2267 2269 2273 2281 2287 2293 2297 2309 2311 2333 2339 2341 2347 2351 '..
                '2357 2371 2377 2381 2383 2389 2393 2399 2411 2417 2423 2437 2441 2447 2459 '..
                '2467 2473 2477 2503 2521 2531 2539 2543 2549 2551 2557 2579 2591 2593 2609 '..
                '2617 2621 2633 2647 2657 2659 2663 2671 2677 2683 2687 2689 2693 2699 2707 '..
                '2711 2713 2719 2729 2731 2741 2749 2753 2767 2777 2789 2791 2797 2801 2803 '..
                '2819 2833 2837 2843 2851 2857 2861 2879 2887 2897 2903 2909 2917 2927 2939 '..
                '2953 2957 2963 2969 2971 2999 3001 3011 3019 3023 3037 3041 3049 3061 3067 '..
                '3079 3083 3089 3109 3119 3121 3137 3163 3167 3169 3181 3187 3191 3203 3209 '..
                '3217 3221 3229 3251 3253 3257 3259 3271 3299 3301 3307 3313 3319 3323 3329 '..
                '3331 3343 3347 3359 3361 3371 3373 3389 3391 3407 3413 3433 3449 3457 3461 '..
                '3463 3467 3469 3491 3499 3511 3517 3527 3529 3533 3539 3541 3547 3557 3559 '..
                '3571 3581 3583 3593 3607 3613 3617 3623 3631 3637 3643 3659 3671 3673 3677 '..
                '3691 3697 3701 3709 3719 3727 3733 3739 3761 3767 3769 3779 3793 3797 3803 '..
                '3821 3823 3833 3847 3851 3853 3863 3877 3881 3889 3907 3911 3917 3919 3923 '..
                '3929 3931 3943 3947 3967 3989 4001 4003 4007 4013 4019 4021 4027 4049 4051 '..
                '4057 4073 4079 4091 4093 ',

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
