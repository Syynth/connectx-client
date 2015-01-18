module.exports = function(cb) { cb(); }

var gulp = require('gulp')
var sass = require('gulp-compass')
var config = require('../config')
var plumber = require('gulp-plumber')
var concat = require('gulp-concat')

module.exports = function() {
  gulp.src(config.style.main)
    .pipe(plumber())
    .pipe(sass({project: __dirname, sass: config.style.in, css: config.style.dir}))
    .pipe(concat(config.style.out))
    .pipe(gulp.dest(config.style.dir))
}
