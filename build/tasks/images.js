var gulp = require('gulp');
var imagemin = require('gulp-imagemin');
var pngcrush = require('imagemin-pngcrush');
var plumber = require('gulp-plumber');
var config = require('../config.json');

module.exports = function() {
  return gulp.src(config.img.in)
    .pipe(plumber())
    .pipe(imagemin())
    .pipe(gulp.dest(config.img.out));
}
