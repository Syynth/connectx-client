# @cjsx React.DOM

React = require 'react'
router = require './router'


router.run (Handler, state) ->
  React.render <Handler />, document.body
