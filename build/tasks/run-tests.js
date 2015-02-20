var gulp = require('gulp');
var gutil = require('gulp-util');
var mochaPhantom = require('gulp-mocha-phantomjs');
var plumber = require('gulp-plumber');

module.exports = function() {
  return gulp.src('test/bin/index.html')
    .pipe(mochaPhantom())
    .on('error', function(err) {
      this.emit('end');
    });
};
