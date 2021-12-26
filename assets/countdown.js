const timer = document.getElementById('stopwatch');

var hr = 0;
var min = 0;
var sec = 0;
var ms = 0;
var lapVal;
var startTime = false;

function startTimer() {
  if (startTime == false) {
    startTime = true;
    timerCountdown();
  }
  LapMessage.postMessage('Start');
}
function stopTimer() {
  if (startTime == true) {
    timer.innerHTML = '0:0:0:0'
    startTime = false;
  }
  LapMessage.postMessage('Stop');
}

function createLap(){
  lapVal = hr + ':' + min + ':' + sec + ':' + ms
  LapMessage.postMessage(lapVal);
}

function timerCountdown() {
  if (startTime == true) {
    ms = parseInt(ms);
    sec = parseInt(sec);
    min = parseInt(min);
    hr = parseInt(hr);

    ms++
    if(ms == 100){
      ms = 0;
      sec++
    }

    if (sec == 60) {
      min = min + 1;
      sec = 0;
    }
    if (min == 60) {
      hr = hr + 1;
      min = 0;
      sec = 0;
    }

    if (ms < 10 || ms == 0 && sec < 10 || sec == 0 && min < 10 || min == 0 && hr < 10 || hr == 0) {
      ms = ms;
      sec = sec;
      min = min;
      hr = hr;
    } else{
      ms = '0' + ms;
      sec = '0' + sec;
      min = '0' + min;
      hr = '0' + hr;
    }

    lapVal = hr + ':' + min + ':' + sec + ':' + ms;
    timer.innerHTML = lapVal;

    setTimeout(function(){timerCountdown()}, 10);
  }
}