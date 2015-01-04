var gulp = require('./build')([
  'browserify',
  'watchify',
  'watch',
  'open',
  'images',
  'express',
  'clean',
  'reload'
]);

var run = require('run-sequence');


gulp.task('build', function(cb) {
  run('clean', 'browserify', cb);
});

gulp.task('serve', function(cb) {
  run(['express', 'reload'], 'open', cb);
});

gulp.task('develop', function(cb) {
  run('watchify', 'serve', 'watch', cb);
});

gulp.task('default', ['develop']);
