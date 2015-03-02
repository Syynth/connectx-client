
{expect} = require 'chai'

{ActionType} = require 'connectx/config'
{ConnectionStore} = require 'connectx/stores'
MemoryCache = require 'connectx/memoryCache'
_ = require 'lodash'

Dispatcher = require 'connectx/dispatcher'

user1 = {}

group1 = ->
  id: 'group1'
  type: 'group'
  connections: [
    id: 'connection2'
    pending: false
    admin: true
    user: user1
  ]

_.extend user1,
  id: 'user1'
  type: 'user'
  connections: [
    id: 'connection1'
    pending: false
    group: group1()
  ]


clearEverything = ->
  localStorage.clear()
  ConnectionStore.clearAll()
  ConnectionStore.cache.data = {}
  ConnectionStore.cache.mem = {}
  ConnectionStore.queue = new MemoryCache

doUserLogin = ->
  Dispatcher.handleServerAction
    type: ActionType.UserLogin
    user: user1
    entity: user1

doEntityFetch = ->
  Dispatcher.handleServerAction
    type: ActionType.EntityFetch
    entity: group1()

module.exports = ->

  describe 'Connection Store tests', ->
    before clearEverything

    describe '| initial conditions', ->
      after clearEverything
      it 'should exist', ->
        expect(ConnectionStore).to.exist
      it 'should have reference to the dispatcher', ->
        expect(ConnectionStore.dispatcher).to.equal(Dispatcher)
      it 'should have no posts in the cache', ->
        expect(ConnectionStore.cache.data).to.be.empty
        expect(ConnectionStore.queue.data).to.be.empty

    describe '| action handlers', ->

      describe '| user login', ->
        after clearEverything
        it 'should record the user logging in', ->
          expect(ConnectionStore.cache.data).to.be.empty
          doUserLogin()
          expect(ConnectionStore.get 'user1').to.exist

      describe '| entity fetch', ->
        beforeEach doEntityFetch
        afterEach clearEverything
        it 'should add the fetched entity to the store', ->
          expect(ConnectionStore.get 'group1').to.exist
        it 'should add the fetched entities connections', ->
          expect(ConnectionStore.get 'user1').to.exist
        it 'should make the connections refer to each other', ->
          expect(ConnectionStore.get('group1').user1.user).to.include({id: 'user1'})
          expect(ConnectionStore.get('user1').group1.group).to.include({id: 'group1'})

    describe '| query functions', ->
      before clearEverything

      describe 'isAdmin', ->
        before doEntityFetch
        it 'should report that user is a group of admin', ->
          expect(ConnectionStore.isAdmin(user1, group1())).to.be.true
        it 'should report that group is not an admin of user', ->
          expect(ConnectionStore.isAdmin(group1(), user1)).to.be.false
