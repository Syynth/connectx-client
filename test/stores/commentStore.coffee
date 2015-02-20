# proxy = require('proxyquireify')(require)

{expect} = require 'chai'

{CommentStore} = require 'connectx/stores'

module.exports = ->

  describe 'Comment Store tests', ->
    it 'should exist', ->
      expect(CommentStore).to.exist
