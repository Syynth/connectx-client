# @cjsx React.DOM

###

###

React = require 'react'

{
  Route,
  RouteHandler,
  DefaultRoute
} = require 'react-router'

Home = require './components/pages/home'
Clubhouse = require './components/pages/clubhouse'

App = require './components/app'

module.exports =
  <Route handler={App}>
    <DefaultRoute handler={Home} />
    <Route name="home" handler={Home} />
    <Route name="clubhouse" handler={Clubhouse} />
  </Route>
