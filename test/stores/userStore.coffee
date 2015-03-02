{expect} = require 'chai'

{ActionType} = require 'connectx/config'
{UserStore} = require 'connectx/stores'
MemoryCache = require 'connectx/memoryCache'
_ = require 'lodash'

Dispatcher = require 'connectx/dispatcher'

user1 =
  UserStore.ensureFields
    id: 'user1'
    type: 'user'
    connections: []

user2 =
  id: 'user2'
  type: 'user'
  connections: []

clearEverything = ->
  localStorage.clear()
  UserStore.clearAll()
  UserStore.cache.data = {}
  UserStore.cache.mem = {}
  UserStore.queue = new MemoryCache

doUserLogin = (user) ->
  Dispatcher.handleServerAction
    type: ActionType.UserLogin
    user: user
    entity: user

module.exports = ->

  describe 'User Store tests', ->
    before clearEverything

    describe '| initial conditions', ->
      it 'should exist', ->
        expect(UserStore).to.exist
      it 'should have reference to the dispatcher', ->
        expect(UserStore.dispatcher).to.equal(Dispatcher)
      it 'should have no users in the cache', ->
        expect(UserStore.cache.data).to.be.empty
        expect(UserStore.cache.mem).to.be.empty
        expect(UserStore.queue.data).to.be.empty

    describe '| action handlers', ->
      afterEach clearEverything

      describe '| user login', ->
        before -> doUserLogin user1
        it 'should add the user to the store', ->
          expect(UserStore.get 'user1').to.exist
          expect(UserStore.get 'user1').to.include user1
