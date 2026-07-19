#!/usr/bin/env lua

-- ------------------------------------ --
-- mos6502-asm.lua v0.01                --
--               copyright iss (c) 2022 --
-- ------------------------------------ --

local iasm = 'sdas'
local oasm = 'ca65'

local mos6502op = {
  ['ADC'] = 3,['AND'] = 3,['ASL'] = 3,['BCC'] = 2,['BCS'] = 2,
  ['BEQ'] = 2,['BIT'] = 3,['BMI'] = 2,['BNE'] = 2,['BPL'] = 2,
  ['BVC'] = 2,['BVS'] = 2,['CLC'] = 1,['CLD'] = 1,['CLI'] = 1,
  ['CLV'] = 1,['CMP'] = 3,['CPX'] = 3,['CPY'] = 3,['DEC'] = 3,
  ['DEX'] = 1,['DEY'] = 1,['EOR'] = 3,['INC'] = 3,['INX'] = 1,
  ['INY'] = 1,['JMP'] = 3,['JSR'] = 3,['LDA'] = 3,['LDX'] = 3,
  ['LDY'] = 3,['LSR'] = 3,['NOP'] = 1,['ORA'] = 3,['PHA'] = 1,
  ['PHP'] = 1,['PLA'] = 1,['PLP'] = 1,['ROL'] = 3,['ROR'] = 3,
  ['RTI'] = 1,['RTS'] = 1,['SBC'] = 3,['SEC'] = 1,['SED'] = 1,
  ['SEI'] = 1,['STA'] = 3,['STX'] = 3,['STY'] = 3,['TAX'] = 1,
  ['TAY'] = 1,['TSX'] = 1,['TXA'] = 1,['TXS'] = 1,['TYA'] = 1,
  ['BRK'] = 1,
  }

local meta_sdas = {
  --   ['.ALIGN']  = '.align',
  --   ['.IDENT']  = '.ident',
  --   ['.ZERO'] = '.zeropage',
  --   ['.TEXT'] = '.code',
  --   ['.DATA'] = '.data',
  --   ['.BSS']  = '.bss',
  --   ['.ASC']  = '.byte',
  --   ['.DSB']  = '.res',
  --   ['.BYT']  = '.byte',
  --   ['.BYTE'] = '.byte',
  --   ['.WRD']  = '.word',
  --   ['.WORD'] = '.word',
  --   ['.RES']  = '.res',
  --   ['.ORG']  = '.org',
  --   ['.IMPORT']  = '.import',
  --   ['.EXPORT']  = '.export',

  ['.GLOBL'] = '.??port',
  ['.AREA'] = '.segment',
  ['.DS']   = '.res',
  ['.DB']   = '.byte',
  ['.BYTE']   = '.byte',
  ['.DW']   = '.word',
  ['.WORD']   = '.word',
  ['.ASCII']   = '.byte',
  ['.ORG']  = '.org',
  ['.MODULE'] = '.setcpu "6502"',
  ['.OPTSDCC'] = '.autoimport on',
  }

local metas = {
  sdas = meta_sdas,
}

local meta = metas[iasm]

local pio = {
  fi = io.input(),
  fo = io.output(),
  ok = function(this,v) return v and true or false end,
  r = function(this,...) return this.fi:read(...) end,
  w = function(this,...) this.fo:write(...) end,
  o = function(this,fname,mode)
    fname = fname and io.open(fname,mode) or nil
    fname = fname or (('w' == mode and io.output()) or io.input())
    return fname
    end,
  ropen = function(this,fname) this.fi = this:o(fname,'r') return this.fi end,
  wopen = function(this,fname) this.fo = this:o(fname,'w') return this.fo end,
  parse = function(this,r,w,process)
    this:ropen(r) local text = this:r('*a') this.fi:close()
    this:wopen(w) this:w(process(text)) this.fo:close()
    end
  }

local function warning(cond,...)
  if not cond then print(...) end
end

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local function split(delimiter,text)
  local list = {}; local pos = 1
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

local function trim(line)
  return line:gsub('^%s+',''):gsub('%s+$','')
end

local function strip(line)
  assert(line and 'string' == type(line))
  line = line:gsub('\r',''):gsub('\n',''):gsub('\t',' ')
  line = line:gsub('^%s+',''):gsub('%s+$','')
  line = line:gsub('%s%s*',' ')
  return line
end

local function strip_table(tab)
  return strip(table.concat(tab,''))
end

local function strip_label(s)
  local function cvt(s) return '@'..s:gsub('%$$','') end
  return s:gsub('(%d+%$)',cvt)
end



-- TODO:
-- local function strip_comments()
--   local comments = {
--     ['%;.*']        ='',-- ; ...
--     ['%/%/.*']      ='',-- // ...
--     ['%/%*.-%*%/']  ='',-- /* ... */
--     ['^%*.*']       ='',-- * ...
--     }
-- end

local function strip_side_comments(t,n)
  t = table.concat(t)
  -- TODO: handle side comments
--   warning(not t:find(';'),'Line: '..tostring(n)..
--          ': Side comments `'..t..'`')
  return t:gsub('%;.*$','')
end

local zpflag = false
local function zpflag_set(s)
  s = (s and s:sub(1,4)) or ''
  zpflag = ('OSEG' == s
    or 'DSEG' == s
    or 'ZERO' == s)
end


-- NOTE: pass one line ---------------------------
local function pass_one_line(lines,globals,labels,tab,n)
  local tt = {}
  table.insert(tt,'')

  if tab and 0<#tab then
    local T = tab[1]:upper()
    local F = T:sub(1,1)

    -- NOTE:preprocesor
    if '#' == F then
      tt.preprocesor = true

    -- NOTE:comments
    elseif ';' == F then
      tt.comment = true

    -- NOTE:empty lines
    elseif '' == F then
      tt.empty = true

    -- NOTE:opcodes
    elseif mos6502op[T] then
      table.insert(tt,tab[1])
      table.remove(tab,1)
      tab = strip_side_comments(tab,n)
      table.insert(tt,tab)
      tt.op = true

    -- NOTE:meta
    elseif meta[T] then
      table.insert(tt,tab[1])
      table.remove(tab,1)
      tab = strip_side_comments(tab,n)
      table.insert(tt,tab)
      tt.meta = true

      if '.AREA' == T then
        zpflag_set(tab[1])
      elseif '.GLOBL' == T then
        globals[tab] = tab
      end

    -- NOTE:labels
    else
      local L = tab[1]:gsub('%:*$','')
--       assert(not labels[L],
--              'Line: '..tostring(n)..': Symbol `'..L..'` is already defined')
      labels[L] = { name = L, zp = zpflag and 'zp' or '' }
      -- NOTE: recursion
      table.remove(tab,1)
      tt = pass_one_line(lines,globals,labels,tab,n) or {}
      assert('' == tt[1],'Line: '..tostring(n)..
             ': Unknown keyword `'..tt[1]..'`')
      tt[1] = L
      tt.label = true
    end

  end
  return tt
end

-- NOTE: pass one --------------------------------
local function pass_one(lines,globals,labels)
  for n,line in ipairs(lines) do
    local tab = split(' ',strip(line))
    lines[n] = {
      n = n,
      text = line,
      parsed = pass_one_line(lines,globals,labels,tab,n)
      }
  end
end

local function process_labels_sdas(labels)
  for k,v in pairs(labels) do
    labels[k].name = strip_label(v.name)
  end
end

local process_labels = {
  sdas = process_labels_sdas,
}

local function format_out(t)
  table.insert(t,'')
  table.insert(t,'')
  table.insert(t,'')
  t[1] = '' ~= t[1] and strip_label(t[1])..':' or ''
  return string.format('%-16s%-16s%-16s%-16s',table.unpack(t))
end

local function tohex(s)
  return (tonumber(s) and string.format('$%.2x',s)) or s
end

-- NOTE: pass two --------------------------------
local function pass_two_line(lines,globals,labels,line,n)

  local t = line.parsed
  if t.empty then
    lines[n].out = ''

  elseif t.preprocesor then
    lines[n].out = '' -- TODO: preprocesor line.text

  elseif t.comment then
    lines[n].out = '' -- TODO: comments line.text

  elseif t.op then
    local L = strip(t[3])
    -- TODO: be more ai
    t[3] = labels[L] and labels[L].name or t[3]
    t[3] = t[3]:gsub('(%#-)0x(%x+)','%1$%2')
    t[3] = t[3]:gsub('^%*(.+)','%1')
    -- HACK double parentheses
    t[3] = t[3]:gsub('%((.+)%)','%1')
    t[3] = t[3]:gsub('%((.+)%)','%1')

    -- NOTE: indirect zp index y
    t[3] = t[3]:gsub('%[%**(.+)%]','(%1)')

    -- HACK:
    if 'JMP' == t[2]:upper():sub(1,3) and '.' == t[3] then
      t[2] = 'rts'
      t[3] = ''
    end

    -- NOTE: fix negative decimals
    if '#-' == t[3]:sub(1,2) then
      if '' == t[3]:gsub('%#%-(%d+)(.*)','%2') then
        local val = t[3]:gsub('%#%-(%d+)(.*)','%1')
        val = 256-tonumber(val)
        t[3] = string.format('#$%x',val)
      end
    end

    -- NOTE: fix 16bit offs
    if '#_' == t[3]:sub(1,2) then
      t[3] ='#<'..t[3]:sub(2)
    end
    lines[n].out = format_out(t)

  elseif t.meta then
    local T = t[2]:upper()
    if '.AREA' == T then
      t[2] = meta[T]
      t[3] = '"'..t[3]:gsub('%(.+%)',''):upper()..'"'
      t[3] = t[3]:gsub('OSEG','ZEROPAGE')
      t[3] = t[3]:gsub('DSEG','ZEROPAGE')
      zpflag_set(t[3])

    elseif '.GLOBL' == T then
      local L = strip(t[3])
      if labels[L] then
        t[2] = '.export'..labels[L].zp
      else
        t[2] = '.import'
        -- HACK
        if '__TEMP' == L
        or '__BASEPTR' == L
        then
          t[2] = '.importzp'
        end
        -- HACK
        if '___SDCC_m6502_ret2' == L
        or '___SDCC_m6502_ret3' == L
        or '___SDCC_m6502_ret4' == L
        or '___SDCC_m6502_ret5' == L
        or '___SDCC_m6502_ret6' == L
        or '___SDCC_m6502_ret7' == L
        then
          t[2] = '.importzp'
        end
      end

    elseif '.ORG' == T then
      t[1] = ';---';
      t[2] = meta[T]
      t[3] = t[3]:gsub('0x(%x+)','$%1')

    elseif '.ASCII' == T then
      t[2] = meta[T]
      t[3] = trim(line.text:gsub('^.*%.ascii',''))

    elseif '.DB' == T
    or '.DW' == T
    or '.BYTE' == T
    or '.WORD' == T then
      t[2] = meta[T]
      t[3] = t[3]:gsub('%#*0x(%x+)','$%1')

    elseif '.DS' == T then
      t[2] = meta[T]
      t[3] = t[3]

    elseif '' == meta[T] then
      t[2] = ''
      t[3] = ''

    else
      local m = split(' ',meta[T])
      if 2 == #m then
        t[2] = m[1]
        t[3] = m[2]
      else
        t[2] = meta[T]
      end
    end
    lines[n].out = format_out(t)

  elseif t.label then
    t[1] = strip_label(t[1])
    lines[n].out = format_out(t)

  else
    assert(nil,
           'Line: '..tostring(n)..
          ': Unhandled case '..dump(line))
  end
end

-- NOTE: pass two --------------------------------
local function pass_two(lines,globals,labels)
  for n,line in ipairs(lines) do
    pass_two_line(lines,globals,labels,line,n)
  end
end

local function process(text)
  local globals = {}
  local labels = {}
  local lines = split('\n',text)
  --
  pass_one(lines,globals,labels)
  --
  process_labels[iasm](labels)
  --
  pass_two(lines,globals,labels)
  --
  -- HACK: sdcc exported by main module
  if labels['__sdcc_gs_init_startup'] then
    table.insert(lines,{})
    lines[#lines].out = '.export __sdcc_gs_init_startup'
    table.insert(lines,{})
    lines[#lines].out = '.export __sdcc_program_startup'
    table.insert(lines,{})
    lines[#lines].out = '.export __sdcc_init_data'
  end

  text = ''
  for n,line in ipairs(lines) do
    text = text..(line.out and line.out..'\n' or '')
  end
  return text
end

local ifile = arg[1]
local ofile = '-o'~=arg[2] and arg[2] or arg[3]
pio:parse(ifile,ofile,process)
