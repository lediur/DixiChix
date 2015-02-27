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
    $("#scroll-glyph").css({
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
    $("#scroll-glyph").css({
      "margin-top": headerTextMargin + "px"
    });
  }

  // Position the footer just out of sight of the current visible window.
  $("#footer").css({
    "margin-top": 0.55 * $("#scroll-glyph").height() + "px"
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

// Code to animate scrolling to the top of the page.
function scrollToTop() {
  var body = $("html, body");
  body.animate({scrollTop: 0}, '500', 'swing');
}

// Code to give chevron-down glyph button proper functionality. It
// should just scroll the user to the bottom of the page to let them sign up.
var goToBottomButton = document.getElementById("scroll-glyph");
goToBottomButton.addEventListener("click", function() {
  scrollToBottom();
});

// To get the document height and make it work on all browsers.
// Stolen from http://james.padolsey.com/javascript/get-document-height-cross-browser/
function getDocHeight() {
  var D = document;
  return Math.max(
      D.body.scrollHeight, D.documentElement.scrollHeight,
      D.body.offsetHeight, D.documentElement.offsetHeight,
      D.body.clientHeight, D.documentElement.clientHeight
  );
}

// Enum to keep track of the state of where the user is currently in the page
// S/he can either be near the bottom, or anywhere else (considered "top").
// current_orientation will initially be set to OrientationEnum.UNSET
var ORIENTATION_ENUM = {
  NEAR_BOTTOM: 0,
  TOP: 1,
  UNSET: 2
};
var orientation = ORIENTATION_ENUM.UNSET;

// When the page is first loaded, determine whether to show the chevron-down
// glyph button to let the user scroll down, or the chevron-up button to
// let the user scroll up.
function showProperScrollingButton() {
  var scrollButton = $("#scroll-glyph");
  var userNearBottom = $(window).scrollTop() + $(window).height() >= getDocHeight() - 25;

  // If the user was previously NEAR BOTTOM, and is still NEAR BOTTOM, no need to change anything.
  // Likewise for if the user was previously TOP, and is still TOP.
  var current_orientation = (userNearBottom) ? ORIENTATION_ENUM.NEAR_BOTTOM : ORIENTATION_ENUM.TOP;
  if (current_orientation != orientation) {

    // If the orientation has not already been set (this is the first time the
    // user has loaded the page) and the user is not NEAR BOTTOM, then leave
    // the button the way it is by default -- the chevron down button
    if (!(orientation == ORIENTATION_ENUM.UNSET && !userNearBottom)) {
      scrollButton.animate({
        opacity: 0.0
      }, 200, "swing", function() {
        if (userNearBottom) {
          scrollButton.removeClass("glyphicon-chevron-down");
          scrollButton.addClass("glyphicon-chevron-up");
          scrollButton.removeClass("padding-for-down-glyph");
          scrollButton.addClass("padding-for-up-glyph");
          scrollButton.unbind("click");
          scrollButton.click(function() {
            scrollToTop();
          });
        } else {
          scrollButton.removeClass("glyphicon-chevron-up");
          scrollButton.addClass("glyphicon-chevron-down");
          scrollButton.removeClass("padding-for-up-glyph");
          scrollButton.addClass("padding-for-down-glyph");
          scrollButton.unbind("click");
          scrollButton.click(function() {
            scrollToBottom();
          });
        }

        scrollButton.animate({
          opacity: 1.0
        }, 200);

        scrollButton.mouseenter(function() {
          scrollButton.css("opacity", "0.7");
        }).mouseleave(function() {
          scrollButton.css("opacity", "1.0");
        });
      });
    }

    orientation = current_orientation; // Save for next time.
  }
}

// Go ahead and set the proper scrolling button as soon as the page loads.
showProperScrollingButton();
// Then, make sure to reset it when necessary.
$(window).scroll(function() {
  showProperScrollingButton();
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