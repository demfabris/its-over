// Blink/HTerm theme: Ayu Dark
// Source palette adapted from common Ayu Dark schemes.
// Uses Blink’s documented t.prefs_.set(...) interface.

// ANSI 0-7 (normal)
const black = '#0A0E14';
const red = '#F07178';
const green = '#C2D94C';
const yellow = '#FFB454';
const blue = '#59C2FF';
const magenta = '#D2A6FF';
const cyan = '#95E6CB';
const white = '#CCCAC2';

// ANSI 8-15 (bright)
const lightBlack = '#01060E';
const lightRed = '#F07178';
const lightGreen = '#C2D94C';
const lightYellow = '#FFB454';
const lightBlue = '#59C2FF';
const lightMagenta = '#D2A6FF';
const lightCyan = '#95E6CB';
const lightWhite = '#FFFDFB';

// Apply palette and colors
t.prefs_.set('color-palette-overrides', [
  black, red, green, yellow, blue, magenta, cyan, white,
  lightBlack, lightRed, lightGreen, lightYellow, lightBlue, lightMagenta, lightCyan, lightWhite,
]);

t.prefs_.set('foreground-color', white);
t.prefs_.set('background-color', black);
t.prefs_.set('cursor-color', 'rgba(255, 255, 255, 0.5)');
t.prefs_.set('cursor-blink', false);
