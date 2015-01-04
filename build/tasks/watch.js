var gulp = require('gulp');
var reload = require('./reload');

module.exports = function() {
  gulp.watch('res/**/*', ['images', 'style']);
  gulp.watch('bin/**/*', reload.notify);
}
