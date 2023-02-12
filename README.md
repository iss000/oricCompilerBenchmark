# oricCompilerBenchmark
### Obsolette! for archive purposes only. 

Simple C compiler benchmark targeting
Oric-1/Atmos/Telestrat/Pravetz-8D 8-bit retro computers.

Compilers: (in alphabetical order)
* [**cc65**](https://github.com/cc65/cc65)
* [**lcc65**](https://github.com/Oric4ever/lcc65) (used in the [OSDK](https://osdn.net/projects/oricsdk/))
* [**vbcc**](http://www.compilers.de/vbcc.html)
* to be added more ...


#### Tests

##### I. [Dummy](tap-dummy) ```tap-dummy/```
Just an empty main() function

| Compiler | cc65 -Oirs | lcc65 -O3 | vbcc -O3 |
| ---: | :---: | :---: | :---: |
| Binary size without header | 250 bytes | 452 bytes | 243 bytes |



##### II. [AES256](https://github.com/chettrick/aes256)

A [byte-oriented AES-256](http://literatecode.com/aes256) implementation
by Ilya Levin.

This example encrypts and decrypts plain text message. No external library functions are used.

* AES256 [not using tables](tap-aes256) ```tap-aes256/```

| Compiler | cc65 -Oirs | lcc65 -O3 | vbcc -O3 |
| ---: | :---: | :---: | :---: |
| Binary size without header | 7330 bytes | 13519 bytes | 14571 bytes |
| Execution-time | 26.35 s  | fail to decrypt | 18.36 |


| Compiler | cc65 -Oirs | lcc65 -O2 | vbcc -O3 |
| ---: | :---: | :---: | :---: |
| Binary size without header | 7330 bytes | 15491 bytes | 14571 bytes |
| Execution time | 26.35 s  | 59.93 s | 18.36 s |

* AES256 [using tables](tap-aes256-tap) ```tap-aes256-tab/```

| Compiler | cc65 | lcc65 | vbcc |
| ---: | :---: | :---: | :---: |
| Binary size without header | 7513 | 14064 | 12113 |
| Execution time | 3.88 s  | 5.43 s | 3.59 s |

