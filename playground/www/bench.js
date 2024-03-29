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
];

var resultsOpt = 'size';
var resultsMode = 'size';

var resultsOptHTML = {
  'size': '<a class="bo">Optimized for: size</a>',
  'speed': '<a class="bo">Optimized for: speed</a>',
};

var resultsModeHTML = {
  'size': '<a class="bo">size,</a> <a class="it">bytes</a>',
  'speed': '<a class="bo">time,</a> <a class="it">cpu cycles</a>',
};

var resultsModeRelHTML = {
  'size': '<a class="bo">size,</a>',
  'speed': '<a class="bo">time,</a>',
};

var resultsRelative = false;
var resultsRelativeBase = 0;
var dataNumbers = [];

function updateResults(mode) {
  resultsMode = mode;
  resultsRelative = false;

  var data;
  var opt;
  if(resultsOpt === "size") {
      data = bench_size;
      opt = opt_size;
  }
  if(resultsOpt === "speed") {
    data = bench_speed;
    opt = opt_speed;
  }

  document.getElementById('th_10').innerHTML = resultsModeHTML[resultsMode];

  dataNumbers = [];
  for(var i=0;i<benches.length;i++) {
    var idx = '00'+i;
    idx = 'tr_'+idx.substr(idx.length-2)
    var tr = document.getElementById(idx);
    var dat = data[benches[i]][resultsMode];
    tr.cells[0].innerText = benches[i];

    for(var j=1; j<tr.cells.length; j++) {
      var num = dat[j-1];
      var cell = tr.cells[j];
      dataNumbers.push(num);
      if('type-sizes' === benches[i]) {
        cell.innerHTML = num;
        cell.style['font-size'] = '14px';
        cell.style['line-height'] = '14px';
      } else {
        cell.innerText = num;
        if(!(Number(num)===num)) cell.style['color'] = 'darkred';
        else cell.style['color'] = '';
      }
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

    document.getElementById('th_10').innerHTML = resultsModeRelHTML[resultsMode]
      +'&nbsp;<a class="it""> (vs. '+compilers[comp]+')</a>';

    for(var i=0;i<benches.length;i++) {
      var idx = '00'+i;
      idx = 'tr_'+idx.substr(idx.length-2)
      var tr = document.getElementById(idx);

      var ref = dataNumbers[i*compilers.length+comp];
      for(var j=1; j<tr.cells.length; j++) {
        var cell = tr.cells[j];
        if('type-sizes' !== benches[i]) {
          var num = dataNumbers[i*compilers.length+j-1]/ref;
          cell.innerText = num.toFixed(comp===j-1? 0:2);
          if(!((Number(num)===num)&&(Number(ref)===ref))) cell.style['color'] = '#ebebeb';
          else cell.style['color'] = (num<1)?'darkgreen':(num==1)? '':'darkred';
        }
      }
    }
  }
}

function updateOpt(mode) {
  resultsOpt = mode;
  var date = "size" === resultsOpt? date_size : date_speed;
  var title = document.getElementById('title');
  title.innerHTML = title.innerHTML.replaceAll(/@/g,date)
  document.getElementById('th_00').innerHTML = resultsOptHTML[resultsOpt];

  var opt = "size" === resultsOpt? opt_size : opt_speed;
  for(var i=0;i<compilers.length;i++)
    document.getElementById('op_'+i).innerText = opt[compilers[i]];

  updateResults(resultsMode);
}

function toggleOpt() {
  updateOpt((resultsOpt === "size")?'speed':'size');
}

function setupPage() {
  var date = "size" === resultsOpt? date_size : date_speed;
  var arc = document.getElementById('archive').innerHTML;
  document.getElementById('archive').innerHTML = arc.replaceAll(/@/g,date);
  updateOpt('size');
}
