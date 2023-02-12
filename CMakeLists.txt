#)              _
#)  ___ ___ _ _|_|___ ___
#) |  _| .'|_'_| |_ -|_ -|
#) |_| |__,|_,_|_|___|___|
#)     iss@raxiss (c) 2022

cmake_minimum_required(VERSION 3.17)

project(MOS6502-compiler-benchmark)

find_program(MAKE_EXE NAMES make gmake nmake)

set (TOP ${CMAKE_HOME_DIRECTORY})

# emulator
message("++ Adding: mos6502vm")
add_subdirectory(mos6502vm)

set(CMAKE_SKIP_INSTALL_ALL_DEPENDENCY true)
