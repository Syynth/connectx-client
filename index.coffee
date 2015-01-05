# @cjsx React.DOM

React = require 'react'
{Router} = require 'connectx'

Router.run (Handler, state) ->
  React.render <Handler />, document.body
