
{expect} = require 'chai'

{ActionType} = require 'connectx/config'
{ConnectionStore} = require 'connectx/stores'
MemoryCache = require 'connectx/memoryCache'
_ = require 'lodash'

Dispatcher = require 'connectx/dispatcher'

user1 =
  id: 'user1'
  type: 'user'
  connections: [
    id: 'group1'
    type: 'group'
    pending: false
  ]

user2 = ->
  id: 'user2'
  type: 'user'
  connections: []

group1 = ->
  id: 'group1'
  type: 'group'
  connections: [
    id: 'user1'
    pending: false
    admin: true
    type: 'user'
  ]

_.extend user1,
  connections: [
    id: 'group1'
    type: 'group'
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

fetch = (entity) ->
  Dispatcher.handleServerAction
    type: ActionType.EntityFetch
    entity: entity

connect = (from, to) ->
  Dispatcher.handleServerAction
    type: ActionType.ConnectionCreated
    from: from
    to: to

doEntityFetch = -> fetch group1()
doUser2Fetch = -> fetch user2()

doServerConnectionCreate = -> connect user2(), group1()

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
          expect(ConnectionStore.get 'group1').to.have.length 1
        it 'should add the fetched entities connections', ->
          expect(ConnectionStore.get 'user1').to.have.length 1
        it 'should make the connections refer to each other', ->
          expect _.filter ConnectionStore.get('group1'), (cn) -> cn.id is 'user1'
            .to.have.length 1
          expect _.filter ConnectionStore.get('user1'), (cn) -> cn.id is 'group1'
            .to.have.length 1

      describe '| server-side connection creation', ->
        before doServerConnectionCreate
        after clearEverything
        it 'should add the connection to the cache', ->
          expect(ConnectionStore.get 'user2', pending: true).to.have.length 1
        it 'should contain reference to the correct entity', ->
          expect ConnectionStore.get('user2', pending: true).filter (cn) -> cn.id is 'group1'
            .to.have.length 1
        it 'should mark existing connections as no longer pending', ->
          connect(group1(), user2())
          expect ConnectionStore.get('user2', pending: true).filter (cn) -> cn.id is 'group1'
            .to.have.length 0
          expect ConnectionStore.get('user2', pending: false).filter (cn) -> cn.id is 'group1'
            .to.have.length 1
          expect ConnectionStore.get('group1', pending: false).filter (cn) -> cn.id is 'user2'
            .to.have.length 1


    describe '| query functions', ->
      before clearEverything

      describe 'hasEdge', ->
        before doServerConnectionCreate
        after clearEverything
        it 'should return true for outgoing pending connections', ->
          expect(ConnectionStore.hasEdge({id: 'user2'}, id: 'group1')).to.be.true
        it 'should return false for incoming pending connections', ->
          expect(ConnectionStore.hasEdge({id: 'group1'}, id: 'user2')).to.be.false

      describe 'get', ->
        before doServerConnectionCreate
        after clearEverything
        it 'should not include pending connections by default', ->
          expect(ConnectionStore.get 'user2').to.have.length 0
        it 'should include pending connections when asked for', ->
          expect(ConnectionStore.get 'user2', pending: true).to.have.length 1

      describe 'incoming', ->
        before ->
          doUser2Fetch()
          doServerConnectionCreate()
        after clearEverything
        it 'should include entity requests', ->
          expect(ConnectionStore.incoming 'group1', 'user').to.have.length 1
        it 'should not include other entity types', ->
          expect(ConnectionStore.incoming 'group1', 'group').to.have.length 0

      describe 'isAdmin', ->
        before doEntityFetch
        it 'should report that user1 is an admin of group1', ->
          expect(ConnectionStore.isAdmin(user1, group1())).to.be.true
        it 'should report that group1 is not an admin of user1', ->
          expect(ConnectionStore.isAdmin(group1(), user1)).to.be.false
