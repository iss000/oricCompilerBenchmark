#)              _
#)  ___ ___ _ _|_|___ ___
#) |  _| .'|_'_| |_ -|_ -|
#) |_| |__,|_,_|_|___|___|
#)     iss@raxiss (c) 2022

cmake_minimum_required(VERSION 3.17)

project(mos6502vm)

add_executable(mos6502vm
  src/fake6502.c
  src/mos6502vm.c
  src/mos6502-trace.c
)

target_compile_options(mos6502vm BEFORE
  PRIVATE -g -O3
)

target_link_options(mos6502vm BEFORE
  PRIVATE -static -static-libgcc -static-libstdc++
)

install(TARGETS mos6502vm
        RUNTIME DESTINATION ${TOP}/bin OPTIONAL)
