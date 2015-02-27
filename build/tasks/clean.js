var del = require('del');

module.exports = function(cb) {
  return del([
    'bin/**/*',
    '!bin/fonts',
    '!bin/index.html'
  ], cb);
}
