var gulp = require('gulp');
var browserify = require('browserify');
var reactify = require('cjsxify');
var source = require('vinyl-source-stream');
var config = require('../config.json');

module.exports = function() {
  return browserify({insertGlobals: false, extensions: ['.coffee', '.cjsx']})
  .add(config.js.in)
  .transform(reactify)
  .bundle()
  .pipe(source(config.js.out))
  .pipe(gulp.dest(config.js.dir));
};
