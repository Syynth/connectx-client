var gulp = require('./build')([
  'browserify',
  'watchify',
  'watch',
  'open',
  'images',
  'express',
  'clean',
  'reload',
  'sass',
  'csslibs',
  'style',
  'compile-tests',
  'run-tests'
]);

var run = require('run-sequence');

gulp.task('build', function(cb) {
  run('clean', 'assets', 'browserify', cb);
});

gulp.task('test', function(cb) {
  run('compile-tests', 'run-tests', cb);
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
