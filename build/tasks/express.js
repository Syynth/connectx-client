var reload = require('connect-livereload');
var gutil = require('gulp-util');
var path = require('path');

module.exports = function(cb) {
  var ex = require('express');
  require('express-alias');
  var app = ex();
  app.use(reload({
    port: 8001
  }));
  app.use(ex.static(path.resolve(__dirname, '../../bin')));
  //app.alias('/', '/bin/');
  app.listen(8000);
  cb();
}
