
{expect} = require 'chai'

{ActionType} = require 'connectx/config'
{CurrentUserStore} = require 'connectx/stores'
MemoryCache = require 'connectx/memoryCache'
Cache = require 'connectx/cache'
_ = require 'lodash'

Dispatcher = require 'connectx/dispatcher'

user =
  id: 'user1'
  type: 'user'
  connections: []

clearEverything = ->
  localStorage.clear()
  CurrentUserStore.clearAll()
  # This uses knowledge of the internals
  CurrentUserStore.cache = new Cache
  CurrentUserStore.queue = new MemoryCache

doUserLogin = ->
  Dispatcher.handleServerAction
    type: ActionType.UserLogin
    user: user
    entity: user

module.exports = ->

  describe 'Current User Store tests', ->
    beforeEach clearEverything

    describe '| initial conditions', ->
      it 'should exist', ->
        expect(CurrentUserStore).to.exist
      it 'should have reference to the dispatcher', ->
        expect(CurrentUserStore.dispatcher).to.equal(Dispatcher)
      it 'should not be logged in', ->
        expect(CurrentUserStore.isLoggedIn()).to.be.false
      it 'should not have a current user', ->
        expect(CurrentUserStore.getCurrentUser()).to.not.be.ok
      it 'should not have a current actor', ->
        expect(CurrentUserStore.getCurrentActor()).to.not.be.ok

    describe '| action creators', ->
      #afterEach clearEverything
      describe '| user login', ->
        it 'should indicate user is logged in', ->
          expect(CurrentUserStore.isLoggedIn()).to.be.false
          doUserLogin()
          expect(CurrentUserStore.isLoggedIn()).to.be.true
        it 'should set the current user to be the current actor', ->
          expect(CurrentUserStore.getCurrentUser()).to.equal(CurrentUserStore.getCurrentActor())
