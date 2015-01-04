# @cjsx React.DOM

React = require 'react'
{Link} = require 'react-router'
HomeNav = require './home/homenav'

Home = module.exports = React.createClass
  render: ->
    <div className="home_wrapper shadow">
      <header className="home" role="banner">
        <section className="partition logo">
          <figure><img src="img/logo.png" /></figure>
        </section>
        <HomeNav />
      </header>
    </div>
