import { Elm } from './src/Main.elm';

console.log(Elm);

const app = Elm.Main.init({
  node: document.querySelector('main')
});

app.ports.alertBad.subscribe(function(message) {
  alert(message);
});

app.ports.copyToClipboard.subscribe(console.log);
