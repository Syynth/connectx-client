# @cjsx React.DOM

React = require 'react'
{Link} = require 'react-router'

Home = module.exports = React.createClass
  render: ->
    <header>
      <h2>Welcome To Golf Connectx!</h2>
      <nav>
        <Link to="clubhouse">Go to clubhouse</Link>
      </nav>
    </header>
