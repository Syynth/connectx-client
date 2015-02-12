/*var sass = require('compass')

module.exports = function(cb) {
  sass.compile(cb)
}
*/

var exec = require('child_process').exec;

module.exports = function(cb) {
  exec('compass compile', function() {cb();});
}
