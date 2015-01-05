# @cjsx React.DOM

React = require 'react'
{Router} = require './node_modules/connectx'

Router.run (Handler, state) ->
  React.render <Handler />, document.body
