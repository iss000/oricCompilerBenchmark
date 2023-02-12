var compilers = [
  'cc65',
  'gcc-6502',
  'kickc',
  'llvm-mos',
  'osdk-lcc65',
  'sdcc',
  'vbcc',
];

var benches = [
  'dummy',
  'hello_world',
  'type_sizes',
  'memcopy',
  'sieve',
  'aes256',
  'mandelbrot',
  'bytecpy',
  'frogmove',
  'pi',
  'bubble_sort',
  'selection_sort',
  'insertion_sort',
  'merge_sort',
  'quick_sort',
  'counting_sort',
  'radix_sort',
  'shell_sort',
  'heap_sort',
];

var resultsMode = 'size';
var resultsRelative = false;
var resultsRelativeBase = 0;
var dataNumbers = [];

function updateResults(mode) {
  resultsMode = mode;
  resultsRelative = false;

  var data;
  var date;
  if(mode === "size") {
      data = bench_size;
      date = date_size;
  }
  if(mode === "speed") {
    data = bench_speed;
    date = date_speed;
  }

  document.getElementById('title').innerText = 'MOS6502 compiler benchmark ('+date+')';
  document.getElementById('th_00').innerText = resultsMode;
  dataNumbers = [];
  for(var i=0;i<benches.length;i++) {
    var idx = '00'+i;
    idx = 'tr_'+idx.substr(idx.length-2)
    var tr = document.getElementById(idx);
    var dat = data[benches[i]];
    tr.cells[0].innerText = benches[i].replaceAll(/_/g,'-');

    for(var j=1; j<tr.cells.length; j++) {
      var num = dat[j-1];
      var cell = tr.cells[j];
      cell.innerText = num;
      dataNumbers.push(num);
      if(!(Number(num)===num)) cell.style['color'] = 'darkred';
      else cell.style['color'] = '';
    }
  }
}

function toggleResults() {
  updateResults((resultsMode === "size")?'speed':'size');
}

function updateResultsRel(comp) {
  if(resultsRelative && resultsRelativeBase === comp) updateResults(resultsMode);
  else {
    resultsRelative = true;
    resultsRelativeBase = comp;

    document.getElementById('th_00').innerText = resultsMode+" ("+compilers[comp]+")";

    for(var i=0;i<benches.length;i++) {
      var idx = '00'+i;
      idx = 'tr_'+idx.substr(idx.length-2)
      var tr = document.getElementById(idx);

      var ref = dataNumbers[i*compilers.length+comp];
      // console.log(i,ref);
      for(var j=1; j<tr.cells.length; j++) {
        var num = dataNumbers[i*compilers.length+j-1]/ref;
        var cell = tr.cells[j];
        cell.innerText = num.toFixed(2);
        if(!((Number(num)===num)&&(Number(ref)===ref))) cell.style['color'] = '#ebebeb';
        else cell.style['color'] = (num<1)?'darkgreen':(num==1)? '':'darkred';
      }
    }
  }
}
