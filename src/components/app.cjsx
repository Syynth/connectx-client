# @cjsx React.DOM

React = require 'react'
{Link, RouteHandler} = require 'react-router'

App = React.createClass
  render: ->
    <div id='wrapper'>
      {### Add notification component here (and backing store) ###}
      <RouteHandler />
      {### Add a modal component here (and backing store) ###}
    </div>

module.exports = App
