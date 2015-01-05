var gulp = require('gulp');
var gutil = require('gulp-util');
var source = require('vinyl-source-stream');
var watchify = require('watchify');
var browserify = require('browserify');
var reactify = require('coffee-reactify');
var config = require('../config.json');
var plumber = require('gulp-plumber');

var bundler = watchify(browserify(config.js.in, {insertGlobals: false, extensions: ['.coffee', '.cjsx']}));
bundler.transform(reactify);

var bundle = function() {
  gutil.log('Running ', gutil.colors.cyan('watchify'), 'after change')
  return bundler.bundle()
    .on('error', gutil.log.bind(gutil, 'Browserify Error'))
    .pipe(source(config.js.out))
    .pipe(gulp.dest(config.js.dir));
}

bundler.on('update', bundle); // on any dep update, runs the bundler

module.exports = bundle;
