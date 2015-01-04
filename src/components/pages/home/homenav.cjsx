# @cjsx React.DOM

React = require 'react'
{Link} = require 'react-router'

HomeNav = module.exports = React.createClass
  render: ->
    <section className="partition nav">
      <ul className="buttonRow navbar">
        <li className="social corners_right">
          <a href="http://www.youtube.com/" target="_blank">
            <div className="navBtn">
              <i className="fa fa-youtube-square" />
            </div>
          </a>
        </li>
        <li className="social">
          <a href="http://www.twitter.com/" target="_blank">
            <div className="navBtn">
              <i className="fa fa-twitter-square" />
            </div>
          </a>
        </li>
        <li className="social">
          <a href="http://www.facebook.com/" target="_blank">
            <div className="navBtn">
              <i className="fa fa-facebook-square" />
            </div>
          </a>
        </li>
        <li>
          <Link to="home">
            <div className="navBtn">FAQ</div>
          </Link>
        </li>
        <li>
          <Link to="home">
            <div className="navBtn">Community</div>
          </Link>
        </li>
        <li>
          <Link to="home">
            <div className="navBtn">Advertise</div>
          </Link>
        </li>
        <li>
          <Link to="home">
            <div className="navBtn">Contact</div>
          </Link>
        </li>
        <li className="clubhouse corners_left img">
          <Link to="clubhouse" className="img">
            <div className="navBtn">
              <figure>
                <img src="img/icons/golf_nav.png" />
              </figure>
            </div>
          </Link>
        </li>
      </ul>
    </section>
