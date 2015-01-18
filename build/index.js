var gulp = require('gulp');

module.exports = function(tasks) {
  tasks.forEach(function(name) {
    var task = require('./tasks/' + name);
    if (task !== null)
      gulp.task(name, task)
  });
  return gulp;
};
