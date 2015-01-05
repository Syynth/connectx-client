var gulp = require('./build')([
  'browserify',
  'watchify',
  'watch',
  'open',
  'images',
  'express',
  'clean',
  'reload',
  'style'
]);

var run = require('run-sequence');


gulp.task('build', function(cb) {
  run('clean', 'assets', 'browserify', cb);
});

gulp.task('serve', function(cb) {
  run(['express', 'reload'], 'open', cb);
});

gulp.task('assets', function(cb) {
  run(['images', 'style'], cb);
})

gulp.task('develop', function(cb) {
  run(['watchify', 'assets'], 'serve', 'watch', cb);
});

gulp.task('default', ['develop']);
