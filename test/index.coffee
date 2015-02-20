
{expect} = require 'chai'

{PostStore} = require 'connectx/stores'

describe 'test setup', ->

  it 'should work', ->
    expect(true).to.be.true

describe 'PostStore functionality', ->

  it 'should exist', ->
    expect(PostStore).to.exist
