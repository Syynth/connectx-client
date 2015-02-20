var gulp = require('gulp');
var browserify = require('browserify');
var reactify = require('cjsxify');
var source = require('vinyl-source-stream');
var config = require('../config.json');
var proxify = require('proxyquireify');

module.exports = function() {
  return browserify({insertGlobals: false, extensions: ['.coffee', '.cjsx']})
  .add(config.test.in)
  .transform(reactify)
  .bundle()
  .pipe(source(config.test.out))
  .pipe(gulp.dest(config.test.dir));
};
