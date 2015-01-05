# @cjsx React.DOM

React = require 'react'
{Router} = require 'connectx'

router.run (Handler, state) ->
  React.render <Handler />, document.body
