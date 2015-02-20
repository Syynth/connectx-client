var gulp = require('gulp');
var browserify = require('browserify');
var reactify = require('cjsxify');
var source = require('vinyl-source-stream');
var config = require('../config.json');
var proxy = require('proxyquireify');

var path = require('path');

module.exports = function() {
  return browserify({insertGlobals: false, extensions: ['.coffee', '.cjsx']})
  .plugin(proxy.plugin)
  .require(require.resolve(path.join('../../', config.test.in)), {entry: true})
  .add(config.test.in)
  .transform(reactify)
  .bundle()
  .pipe(source(config.test.out))
  .pipe(gulp.dest(config.test.dir));
};
