#!/bin/bash
ofile=${1}; shift
test -z "${START}" && { echo "START undefined."; exit 1; }

LFLAGS=""

# unsupported :(
# LFLAGS="${LFLAGS} -nostdlib"
# LFLAGS="${LFLAGS} -nodefaultlibs"
# LFLAGS="${LFLAGS} -nostartfiles"

${BASE}/../cc65/bin/ld65 -D_start=${START} -C share/gcc-6502/none.cfg \
${LFLAGS} -vm -m ${ofile/.prg/.map} -o ${ofile} $* ${LDFLAGS} ${LIBS}

LUA_MAP_TO_SYM=$(cat << 'EOF'
local function error(s) print(s); os.exit(-1) end
-- print(">>>>>",#arg) for x,y in pairs(arg) do print(x,y) end
if 2 ~= #arg then error("Usage: "..arg[0].." <in file> <out file>") end
local fi = io.open(arg[1],"r") or error("Can't open '"..arg[1].."'")
local fo = io.open(arg[2],"w") or error("Can't open '"..arg[2].."'")
local flag = 0
local sym = {}
for l in fi:lines() do
  l = l:gsub("\n",""):gsub("\r","")
  if 1 == l:find("Exports list by value:") or "" == l then
    flag = 0 -- stop parser
  elseif 1 == l:find("Exports list by name:") then
    flag = 1 -- skip one separator line
  elseif(flag == 1) then
    flag = 2 -- start parser
  elseif(flag == 2) then
    l:gsub("([^ ]*) *([^ ]*) *([^ ]*) *([^ ]*) *([^ ]*) *([^ ]*)",
    function(s1,a1,t1,s2,a2,t2)
      if a1 and ""~= a1 and s1 and ""~=s1 and "00"==a1:sub(1,2) then
        table.insert(sym,a1:sub(3).." "..s1)
      end
      if a2 and ""~= a2 and s2 and ""~=s2 and "00"==a2:sub(1,2) then
        table.insert(sym,a2:sub(3).." "..s2)
      end
    end)
  end
end
table.sort(sym)
for _,l in ipairs(sym) do
  fo:write(l,"\n")
end
fo:close()
fi:close()
EOF
)

# echo $LUA_MAP_TO_SYM
lua -e "$LUA_MAP_TO_SYM" /dev/null ${ofile/.prg/.map} ${ofile/.prg/.sym}
