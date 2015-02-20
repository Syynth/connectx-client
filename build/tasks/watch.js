var gulp = require('gulp');
var reload = require('./reload');

module.exports = function() {
  gulp.watch('res/style/**/*', ['style']);
  gulp.watch('res/img/**/*', ['images']);
  gulp.watch('bin/**/*', reload.notify);
  gulp.watch('test/**/*.coffe', ['test'])
  gulp.watch('node_modules/connectx/**/*', ['test']);
}
