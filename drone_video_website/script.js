/**********************************
 * Code to resize window elements *
 **********************************/

function resizeWindowElements() {
  if ($(window).height() <= 365) {
    $("#header-text").find("h1").each(function(index) {
      this.style.fontSize = "2em";
    });

    $("#header-text").find("p").each(function(index) {
      this.style.fontSize = "1em";
    });

    // Center the header text.
    var windowHeight = $(window).height();
    var headerTextHeight = $("#header-text").height();
    var headerTextMargin = ((windowHeight-(1.5*headerTextHeight))/2);
    $("#header-text").css({
      "margin-top": headerTextMargin + "px"
    });

    // Position the chevron down span glyph to navigate to the next page on the
    // bottom of the current visible window.
    $("#next-page-glyph").css({
      "margin-top": (0.4 * headerTextMargin) + "px"
    });
  } else {
    $("#header-text").find("h1").each(function(index) {
      this.style.fontSize = "5em";
    });

    $("#header-text").find("p").each(function(index) {
      this.style.fontSize = "2em";
    });

    // Center the header text.
    var windowHeight = $(window).height();
    var headerTextHeight = $("#header-text").height();
    var headerTextMargin = ((windowHeight-(1.5*headerTextHeight))/2);
    $("#header-text").css({
      "margin-top": headerTextMargin + "px"
    });

    // Position the chevron down span glyph to navigate to the next page on the
    // bottom of the current visible window.
    $("#next-page-glyph").css({
      "margin-top": headerTextMargin + "px"
    });
  }

  // Position the footer just out of sight of the current visible window.
  $("#footer").css({
    "margin-top": 0.55 * $("#next-page-glyph").height() + "px"
  });
}

// Initially call this as soon as the JS is loaded to properly size the window elements
resizeWindowElements();

// Then call this function on window resizing so that content still looks good
// even when the size of the page is changed.
window.onresize = resizeWindowElements;

/**************************************************************
 * Code to handle click event for the chevron down span glyph *
 **************************************************************/

// Code to animate scrolling to the bottom of the page.
function scrollToBottom() {
  var body = $("html, body");
  body.animate({scrollTop: $(window).height()}, '750', 'swing');
}

// Code to give chevron-down glyph button proper functionality. It
// should just scroll the user to the bottom of the page to let them sign up.
var goToBottomButton = document.getElementById("next-page-glyph");
goToBottomButton.addEventListener("click", function() {
  scrollToBottom();
});


/**********************************
 * Code for video playback/muting *
 **********************************/
var vid = document.getElementById("bgvid");

function vidFade() {
  vid.classList.add("stopfade");
}

vid.addEventListener('ended', function() {
  // only functional if "loop" is removed
  vid.pause();
  // to capture IE10
  vidFade();
});

// Code to give the video pause button proper functionality
var pauseButton = document.getElementById("vid-pause-play-button");
var pauseButtonGlyph = document.getElementById("vid-pause-play-button-glyph");
pauseButton.addEventListener("click", function() {
  vid.classList.toggle("stopfade");
  if (vid.paused) {
    vid.play();
    pauseButtonGlyph.className = "glyphicon glyphicon-pause";
  } else {
    vid.pause();
    pauseButtonGlyph.className = "glyphicon glyphicon-play";
  }
});

// Code to give the video mute button proper functionality
var muteButton = document.getElementById("vid-mute-button");
var muteButtonGlyph = document.getElementById("vid-mute-button-glyph");
muteButton.addEventListener("click", function() {
  vid.muted = !vid.muted;
  if (muteButtonGlyph.className.indexOf("volume-off") != -1) {
    muteButtonGlyph.className = "glyphicon glyphicon-volume-up";
  } else {
    muteButtonGlyph.className = "glyphicon glyphicon-volume-off";
  }
});

/**********************************************************
 * Code to handle submission of form for interested users *
 **********************************************************/

function validateEmail(email) {
  var re = new RegExp("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
  return re.test(email);
}

// Code to give submit button proper functionality. It should add
// the given email to a mailing list.
var submitButton = document.getElementById("sign-up-button");
var emailInput = document.getElementById("emailInput");
var submitAlertSuccessDiv = document.getElementById("sign-up-alert-success");
var submitAlertFailDiv = document.getElementById("sign-up-alert-fail");
submitButton.addEventListener("click", function() {
  event.preventDefault();
  submitAlertSuccessDiv.style.display = "none";
  submitAlertFailDiv.style.display = "none";

  if (validateEmail(emailInput.value)) {
    console.log(emailInput.value);
    setTimeout(function() {
      submitAlertSuccessDiv.style.display = "block";
      scrollToBottom();
    }, 300);
  } else {
    console.log("This is not a valid email");
    setTimeout(function() {
      submitAlertFailDiv.style.display = "block";
      scrollToBottom();
    }, 300);
  }
});