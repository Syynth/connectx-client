var gulp = require('gulp');
var browserify = require('browserify');
var react = require('coffee-reactify');
var source = require('vinyl-source-stream');
var config = require('../config.json');

module.exports = function() {
  return browserify({insertGlobals: false, extensions: ['.coffee', '.cjsx']})
  .add(config.js.in)
  .transform(coffeeReact)
  .bundle()
  .pipe(source(config.js.out))
  .pipe(gulp.dest(config.js.dir));
};
