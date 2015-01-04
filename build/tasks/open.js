var gulp = require('gulp');
var open = require('gulp-open');
var plumber = require('gulp-plumber');
var config = require('../config.json');

module.exports = function() {
  return gulp.src(config.server.root)
    .pipe(plumber())
    .pipe(open("<% file.path %>", {
      url: config.server.url
    }));
}
