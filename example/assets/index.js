require('../assets/images/more-from-4.png');
require('../assets/images/more-from-3.png');

const {
  Elm
} = require('../src/elm/Main.elm');

const app = Elm.Main.init({
  node: document.getElementById('application')
});
