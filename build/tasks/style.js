var gulp = require('gulp')
var plumber = require('gulp-plumber')
var concat = require('gulp-concat')
var config = require('../config')

gulp.task('style', ['sass', 'csslibs'], function() {
  return gulp.src(config.style.in)
    .pipe(plumber())
    .pipe(concat())
    .pipe(gulp.dest(config.style.dir))
})
