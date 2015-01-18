var gulp = require('gulp');

module.exports = function(tasks) {
  tasks.forEach(function(name) {
    task = require('./tasks/' + name)
    if (task)
      gulp.task(name, task))
  });
  return gulp;
};
