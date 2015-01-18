var gulp = require('gulp')
var config = require('../config')
var plumber = require('gulp-plumber')
var concat = require('gulp-concat')

module.exports = function() {
  return gulp.src(config.csslibs.in)
    .pipe(plumber())
    .pipe(concat())
    .pipe(confing.csslibs.out)
    .pipe(gulp.dest(config.csslibs.dir))
}
