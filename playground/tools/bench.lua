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

local debug_compile = 3       -- verbose compilation level (0,1,2,3)
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

--
-- load optimizations params
--
dofile(arg[0]:gsub('bench.lua','bench-params.lua'))

local compilers = {
  'cc65',
  'gcc-6502',
  'kickc',
  'llvm-mos',
  'osdk-lcc65',
  'sdcc',
  'vbcc',
  '6502-c++',
  }

local benches = {
  'type-sizes',
  'dummy',
  'hello-world',
  'bytecpy',
  'memcopy',
  '0xcafe',
  'sieve',
  'aes256',
  'mandelbrot',
  'frogmove',
  'pi',
  'shuffle',
  'bubble-sort',
  'selection-sort',
  'insertion-sort',
  'merge-sort',
  'quick-sort',
  'counting-sort',
  'radix-sort',
  'shell-sort',
  'heap-sort',
  'eight-queens',
  }

local sort_output =     '0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,'..
                        '17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,'..
                        '33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,'..
                        '49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,'..
                        '65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,'..
                        '81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,'..
                        '97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,'..
                        '113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,'..
                        '129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,'..
                        '145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,'..
                        '161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,'..
                        '177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,'..
                        '193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,'..
                        '209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,'..
                        '225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,'..
                        '241,242,243,244,245,246,247,248,249,250,251,252,253,254,255'

local benches_output = {
  ['dummy'] = nil,

  ['hello-world'] =
                'HELLO 6502 WORLD!',

  ['type-sizes'] = nil,

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

  ['frogmove'] = 'FROG MOVED MOVED',

  ['pi'] =      -- https://www.piday.org/million/
                'pi=3.1415926535897932384626433832795028841971693993751058209749445923'..
                '078164062862089986280348253421170679821480865132823066470938446095505'..
                '82231725359408128481117450',

  ['bubble-sort']     = sort_output,
  ['selection-sort']  = sort_output,
  ['insertion-sort']  = sort_output,
  ['merge-sort']      = sort_output,
  ['quick-sort']      = sort_output,
  ['counting-sort']   = sort_output,
  ['radix-sort']      = sort_output,
  ['shell-sort']      = sort_output,
  ['heap-sort']       = sort_output,

  ['shuffle']         = '65,24,184,38,214,96,55,231,138,193,186,75,20,94,189,63,242,132,124,74,11,29,226,200,'..
                        '26,15,170,69,35,211,32,40,129,92,4,22,161,6,27,153,54,213,142,148,140,68,23,91,47,245,'..
                        '204,13,36,175,18,177,162,117,120,85,100,110,164,9,128,81,143,17,119,206,62,185,58,157,'..
                        '130,134,107,99,126,180,34,59,49,232,178,45,252,248,168,199,93,125,0,165,70,122,98,196,'..
                        '28,111,234,95,80,158,156,197,151,112,203,221,240,205,89,90,150,241,166,51,108,249,97,3,'..
                        '60,73,44,83,144,191,190,163,174,208,56,218,50,247,61,76,237,115,154,173,104,183,37,233,'..
                        '64,30,210,77,114,194,229,48,152,255,8,243,160,246,136,188,43,228,235,123,86,201,172,141,'..
                        '225,147,121,57,212,87,71,182,10,217,113,31,16,192,131,236,42,198,159,149,103,219,139,167,'..
                        '116,5,118,53,88,25,250,1,14,202,78,230,106,169,7,171,19,227,137,216,220,195,79,155,102,'..
                        '209,187,222,176,251,207,135,238,33,244,67,84,179,52,101,127,21,66,133,109,215,254,181,'..
                        '72,105,12,253,39,41,46,223,2,145,146,224,82,239',

  ['0xcafe']          = '0XCAFE == 0XCAFE :)',

  ['eight-queens']    = 'SOLUTIONS: 92'..
                        ' 12345678'..
                        '1-------Q'..
                        '2---Q----'..
                        '3Q-------'..
                        '4--Q-----'..
                        '5-----Q--'..
                        '6-Q------'..
                        '7------Q-'..
                        '8----Q---',
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

  if 'size' == opt then
    cmdadd(cmd,'OPT="'..(compilers_make_param_size[c] or '')..'"')
  else
    cmdadd(cmd,'OPT="'..(compilers_make_param_speed[c] or '')..'"')
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
  -- redirect trace output from stderr to file
  cmdadd(cmd,0<debug_run_trace and '2>bin/'..c..'-'..b..'-trace.txt' or '')


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
      if b == 'type-sizes' then
        r = '"'..c..'","'..b..'",'
        t = t:gsub('\r',''):gsub('\n','')
        t = t:gsub('[^%d% ]*','')
        t = t:gsub('%s*',',')
        t = t:sub(2,#t-1)
        r = '"'..c..'","'..b..'",'..t:sub(1,#t-2)
        stat = t:sub(#t-1)
        -- print(r)
      end
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
