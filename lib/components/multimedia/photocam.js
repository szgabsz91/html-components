function PhotocamProxy(videoSelector, canvasSelector, imageSelector) {
  var videoElement = document.querySelector(videoSelector);
  var canvasElement = document.querySelector(canvasSelector);
  var imageElement = document.querySelector(imageSelector);
  var context = canvasElement.getContext('2d');
  var stream = null;
  
  function hasGetUserMedia() {
    return !!(navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia);
  }
  
  var fail = function(error) {
    console.log('Error', error);
    alert('An error occured!');
  }
  
  function resizeCanvas() {
    setTimeout(function() {
      canvasElement.width = videoElement.videoWidth;
      canvasElement.height = videoElement.videoHeight;
      imageElement.height = videoElement.videoHeight;
      imageElement.width = videoElement.videoWidth;
    }, 100);
  }
  
  this.start = function(audio) {
    if (hasGetUserMedia()) {
      navigator.webkitGetUserMedia({video: true, audio: audio}, function(mediaStream) {
        stream = mediaStream;
        videoElement.src = window.URL.createObjectURL(mediaStream);
        resizeCanvas();
      }, fail);
  	}
    else {
      alert('Launching the webcam is not supported in your browser');
    }
  }
  
  this.stop = function() {
    videoElement.pause();
    stream.stop();
  }
  
  this.snapshot = function() {
    if (stream) {
  	  context.drawImage(videoElement, 0, 0);
  	  imageElement.src = canvasElement.toDataURL('image/webp');
  	}
  }
}