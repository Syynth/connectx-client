var reload = require('gulp-livereload');
var gutil = require('gulp-util');

module.exports = function(cb) {
  reload.listen(8001);
  cb();
}

module.exports.notify = function(event) {
  reload.changed(event.path, 8001);
}
