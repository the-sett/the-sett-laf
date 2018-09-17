// Styles
require('./styles/main.scss');
const TextToSVG = require('text-to-svg');
const SimpleCache = require('./simple-cache').Storage;
const LocalStorage = require('./local-storage').ElmLocalStoragePorts;

const Elm = require('../elm/Main');

const appElement = document.getElementById("diagram");
const app = Elm.Main.embed(appElement);

//const topElement = document.getElementById("diagram");

// Subscribe to local storage.
const localStorage = new LocalStorage();
localStorage.subscribe(app);

// Disable the default CTRL+mouse wheel zooming.
$(window).keydown(function(event) {
  if ((event.keyCode == 107 && event.ctrlKey == true) || (event.keyCode == 109 && event.ctrlKey == true)) {
    event.preventDefault();
  }

  $(window).bind('mousewheel DOMMouseScroll', function(event) {
    if (event.ctrlKey == true) {
      event.preventDefault();
    }
  });
});

// Not currently used, but this is one way of watching elements for potential
// changes in size.
const sizeObserver = new MutationObserver(mutations => {
  mutations.forEach(mutation => {
    $('.watch-resize').each(function() {
      var result = {
        id: this.id,
        height: this.clientHeight,
        width: this.clientWidth
      };

      app.ports.Ports.resize.send(result);
    });
  });
});

// sizeObserver.observe(topElement, {
//   childList: true,
//   subtree: true
// })

//-- Ports for converting text to SVG.

const fontCache = new SimpleCache();

app.ports.textToSVG.subscribe(request => {
  fontCache.async(request.font, {
    set: function(setValue) {
      TextToSVG.load(require('./fonts/' + request.font + '.ttf'), function(err, textToSVG) {
        setValue(textToSVG);
      });
    },
    get: function(value) {
      convertTextToSVG(request, value);
    }
  });
});

function convertTextToSVG(request, textToSVG) {
  const metrics = textToSVG.getMetrics(request.text, {
    fontSize: request.fontSize,
    kerning: request.kerning,
    letterSpacing: request.letterSpacing
  })

  //console.log(metrics);

  const pathData = textToSVG.getD(request.text, {
    fontSize: request.fontSize,
    kerning: request.kerning,
    letterSpacing: request.letterSpacing
  })

  const result = {
    id: request.id,
    x: metrics.x,
    y: metrics.y,
    baseline: metrics.baseline,
    width: metrics.width,
    height: metrics.height,
    ascender: metrics.ascender,
    descender: metrics.descender,
    pathData: pathData,
    request: request
  }

  //console.log(result);

  app.ports.textToSVGResponse.send(result);
};
