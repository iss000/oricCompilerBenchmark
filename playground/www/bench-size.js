var opt_size = {
	"cc65": "-O",
	"gcc-6502": "-O2",
	"kickc": "",
	"llvm-mos": "-O2",
	"osdk-lcc65": "-O2",
	"sdcc": "--opt-code-size",
	"vbcc": "-O=991",
};

var opt_speed = {
	"cc65": "-Oirs",
	"gcc-6502": "-O3",
	"kickc": "",
	"llvm-mos": "-O3",
	"osdk-lcc65": "-O2",
	"sdcc": "--opt-code-speed",
	"vbcc": "-O=1023",
};

var bench_size = {
	"type-sizes": { size: [ "char:1<br>short:2<br>int:2<br>long:4","char:1<br>short:2<br>int:2<br>long:4","char:1<br>short:2<br>int:2<br>long:4","char:0<br>short:0<br>int:0<br>long:1","char:1<br>short:1<br>int:2<br>long:2","char:1<br>short:2<br>int:2<br>long:4","char:1<br>short:2<br>int:2<br>long:4", ], speed: [ "char:1<br>short:2<br>int:2<br>long:4","char:1<br>short:2<br>int:2<br>long:4","char:1<br>short:2<br>int:2<br>long:4","char:0<br>short:0<br>int:0<br>long:1","char:1<br>short:1<br>int:2<br>long:2","char:1<br>short:2<br>int:2<br>long:4","char:1<br>short:2<br>int:2<br>long:4", ] },
	"dummy": { size: [ 15,77,1,"C",192,18,15, ], speed: [ 29,85,12,"C",37,32,29, ] },
	"hello-world": { size: [ 202,165,60,"C",407,77,99, ], speed: [ 3966,858,873,"C",8495,880,943, ] },
	"bytecpy": { size: [ 21,83,7,"C",202,24,21, ], speed: [ 37,93,20,"C",51,40,37, ] },
	"memcopy": { size: [ 94,135,62,"C",340,107,93, ], speed: [ 721210,344627,557220,"C",1507551,770273,647376, ] },
	"0xcafe": { size: [ 394,209,119,"C","C","C",321, ], speed: [ 4117,932,878,"C","C","C",1263, ] },
	"sieve": { size: [ 1110,1025,"C","C",9745,9747,918, ], speed: [ 10992453,10374089,"C","C",16502355,19108109,10134340, ] },
	"aes256": { size: [ 6303,7606,"C","C",14340,"C",5083, ], speed: [ 34768201,14014726,"C","C",84684177,"C",15517821, ] },
	"mandelbrot": { size: [ 954,1775,"C","C",863,1208,1087, ], speed: [ 22340480,10111503,"C","C",180732758,44706483,17771163, ] },
	"frogmove": { size: [ 2086,2280,1615,"C",2807,"R",1783, ], speed: [ 19508255,4383526,5085372,"C",14701662,"R",7517472, ] },
	"pi": { size: [ 1531,2244,"C","C","R",5081,1410, ], speed: [ 122047814,129853690,"C","C","R",274557082,106479957, ] },
	"shuffle": { size: [ 1893,2195,"C","C",2263,"R",1550, ], speed: [ 3310575,2939404,"C","C",3023907,"R",2913575, ] },
	"bubble-sort": { size: [ 1587,1520,"C","C",2061,"R",1458, ], speed: [ 29143902,4718343,"C","C",15239177,"R",9372070, ] },
	"selection-sort": { size: [ 1584,1689,"C","C",2123,"R",1445, ], speed: [ 16039648,5530968,"C","C",10134811,"R",5428080, ] },
	"insertion-sort": { size: [ 1543,1572,"C","C",2027,"R",1428, ], speed: [ 9769795,3005682,"C","C",6437330,"R",4060301, ] },
	"merge-sort": { size: [ 2156,2503,"C","C",4270,"R",2219, ], speed: [ 3981830,2331044,"C","C",4028621,"R",2410181, ] },
	"quick-sort": { size: [ 1697,1868,"C","C",2517,"T",1767, ], speed: [ 3112806,1899078,"C","C",3358937,"T",1786240, ] },
	"counting-sort": { size: [ 1972,2311,"C","C",3737,"R",1818, ], speed: [ 1885437,1724489,"C","C",2137721,"R",1435174, ] },
	"radix-sort": { size: [ 2305,2945,"C","C",4659,"R",2516, ], speed: [ 6394756,6592472,"C","C",7924337,"R",6561858, ] },
	"shell-sort": { size: [ 1618,1797,"C","C",2172,"R",1606, ], speed: [ 4513897,2337837,"C","C",3704984,"R",2458457, ] },
	"heap-sort": { size: [ 1793,2211,"C","C",2744,"R",1890, ], speed: [ 4957712,2478797,"C","C",5339768,"R",2336973, ] },
	"eight-queens": { size: [ 1084,1067,593,"C",2649,1173,917, ], speed: [ 28729340,4725549,5565918,"C",72651727,14030163,9766336, ] },
};
