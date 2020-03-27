import { Elm } from './src/Main.elm';
import copy from 'copy-to-clipboard';

const app = Elm.Main.init({
  node: document.querySelector('main')
});

app.ports.alertBad.subscribe(function(message) {
  alert(message);
});

app.ports.copyToClipboard.subscribe(function(html) {
  copy(html);

  alert('Copied! Now go finish your homework.');
});
