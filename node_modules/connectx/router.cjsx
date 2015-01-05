# @cjsx React.DOM

###
This essentially creates a default router instance that can
be shared between any and all action creators
###

Router = require 'react-router'
routes = require './routes'
location = Router.HashLocation

module.exports = router = Router.create {routes, location}
