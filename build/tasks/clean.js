var del = require('del');

module.exports = function(cb) {
  return del([
    'bin/**/*',
    '!bin/index.html',
    '!bin/final.css'
  ], cb);
}
