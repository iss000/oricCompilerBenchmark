#!/bin/bash
ofile=${1}; shift
test -z "${START}" && { echo "START undefined."; exit 1; }

START="${START}"
STACK="${STACK:-0x8000}"

CFLAGS="-mm6502"
# CFLAGS="${CFLAGS} --no-std-crt0" ignored :(
# CFLAGS="${CFLAGS} --nostdlib"
CFLAGS="${CFLAGS} --use-stdout"

# --xram-loc   <nnnn> External Ram start location
# --xram-size  <nnnn> External Ram size
# --iram-size  <nnnn> Internal Ram size
# --xstack-loc <nnnn> External Stack start location
# --code-loc   <nnnn> Code Segment Location
# --code-size  <nnnn> Code Segment size
# --stack-loc  <nnnn> Stack pointer initial value
# --data-loc   <nnnn> Direct data start location
# --idata-loc  <nnnn>
CFLAGS="${CFLAGS} --code-loc   ${START}"
CFLAGS="${CFLAGS} --stack-loc  ${STACK}"
# CFLAGS="${CFLAGS} --data-loc   0x4000"
# CFLAGS="${CFLAGS} --xstack-loc 0x8000"
# CFLAGS="${CFLAGS} --xram-size  0x8000"
# CFLAGS="${CFLAGS} --iram-size  0x8000"
# CFLAGS="${CFLAGS} --code-size  0x8000"

CFLAGS="${CFLAGS} --out-fmt-ihx"
# CFLAGS="${CFLAGS} --out-fmt-s19"

# ##################################################################
#
# OBJS="$(echo $* |sed -e 's/\.o/.rel/g')"
# LIBS="$(echo ${LIBS} |sed -e 's/\.a/.lib/g')"
#
# # ${BASE}/bin/sdcc ${CFLAGS} -o ${ofile} ${OBJS} ${LDFLAGS} -lm6502
#
# LIBS="$(echo ${LIBS} |sed -e 's/\ *-l/ /g')"
# LDFLAGS="$(echo ${LDFLAGS} |sed -e 's/\ *\-L/ /g')"
#
# LDPARAMS="-nmuwxiYM "
# LDPARAMS="${LDPARAMS} -b HOME=${START}"
# LDPARAMS="${LDPARAMS} -b XSEG=0x8000"
# # -b HOME = ${START}
# # -b DSEG = 0x0020
# # -b XSEG = 0x8000
#
# for i in ${LDFLAGS}; do LDPARAMS="${LDPARAMS} -k $i" ; done
# for i in ${LIBS}; do LDPARAMS="${LDPARAMS} -l $i" ; done
# LDPARAMS="${LDPARAMS} ${ofile}"
# LDPARAMS="${LDPARAMS} ${OBJS}"
# LDPARAMS="${LDPARAMS} -e"
#
# ${BASE}/bin/sdld ${LDPARAMS} \
# && cp -f ${ofile/.prg/.ihx} ${ofile}

# ##################################################################

${BASE}/../cc65/bin/ld65 -C share/sdcc/none.cfg \
-vm -m ${ofile/.prg/.map} -o ${ofile} $* ${LDFLAGS} ${LIBS}

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
