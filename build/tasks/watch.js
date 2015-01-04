var gulp = require('gulp');
var reload = require('./reload');

module.exports = function() {
  gulp.watch('res/**/*', ['assets']);
  gulp.watch('bin/**/*', reload.notify);
}
