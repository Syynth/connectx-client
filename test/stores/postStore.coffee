
{expect} = require 'chai'

{ActionType} = require 'connectx/config'
{PostStore} = require 'connectx/stores'
MemoryCache = require 'connectx/memoryCache'
_ = require 'lodash'

Dispatcher = require 'connectx/dispatcher'

clearEverything = ->
  localStorage.clear()
  PostStore.clearAll()
  PostStore.cache.data = {}
  PostStore.cache.mem = {}
  PostStore.queue = new MemoryCache

createTestPost = ->
  Dispatcher.handleClientAction
    type: ActionType.CreatePost
    clientId: '1'
    posts: [testPost]

syncTestPost = ->
  Dispatcher.handleServerAction
    type: ActionType.PostSaved
    clientId: '1'
    serverId: 's3'
    post: testPost

failTestPost = ->
  Dispatcher.handleServerAction
    type: ActionType.PostCreationFailed
    clientId: '1'
    post: testPost

retryTestPost = ->
  Dispatcher.handleClientAction
    type: ActionType.PostResent
    clientId: '1'
    post: testPost

createServerPosts = ->
  Dispatcher.handleServerAction
    type: ActionType.PostCollectionSync
    entity: {id: 'usr2', type: 'user'}
    posts: [(_.extend({}, {id: 's1'}, testPost)), serverPost]

testPost =
  text: 'test post'
  author: {id: 'usr1', type: 'user'}
  owner: {id: 'usr1', type: 'user'}
  createdAt: new Date().toISOString()

makePost = (num) ->
  id: 's' + num
  text: 'test post ' + num
  author: {id: 'usr2', type: 'user'}
  owner: {id: 'usr2', type: 'user'}
  createdAt: new Date().toISOString()

serverPost = makePost 2
sPost3 = makePost 3
sPost4 = makePost 4


module.exports = ->

  describe 'Post Store tests', ->
    before 'clear everything', clearEverything

    describe '| initial conditions', ->
      it 'should exist', ->
        expect(PostStore).to.exist
      it 'should have reference to the dispatcher', ->
        expect(PostStore.dispatcher).to.equal(Dispatcher)
      it 'should have no posts in the cache', ->
        expect(PostStore.cache.data).to.be.empty

    describe '| action handlers', ->

      describe '| creating posts', ->
        before 'simulating user created post...', createTestPost
        after 'resetting post store', clearEverything
        it 'should add single posts to the cache when a user posts', ->
          expect(PostStore.get '1').to.include testPost
        it 'should add multiple posts when a collection is fetched', ->
          createServerPosts()
          expect(PostStore.get 's1').to.include testPost
          expect(PostStore.get 's2').to.include serverPost
        it 'should add a getId property to all posts', ->
          for postId, post of PostStore.cache.data
            expect(post.getId()).to.equal postId
        it 'should contain the correct number of posts', ->
          # 2 for create server posts
          expect(_.keys(PostStore.cache.data)).to.have.length 2
          # 1 for createTestPost
          expect(_.keys(PostStore.queue.data)).to.have.length 1


      describe '| syncing posts to the server', ->
        before 'simulating user created post...', ->
          createTestPost()
          createServerPosts()
        after 'resetting post store', clearEverything
        it 'should mark posts as pending before sync completes', ->
          expect(PostStore.get('1').pending).to.be.true
        it 'should mark posts from the server as not pending', ->
          expect(PostStore.get('s1').pending).to.not.exist
        it 'should change a posts id when sync succeeds', ->
          expect(PostStore.get '1').to.exist
          expect(PostStore.get('1').pending).to.be.true
          syncTestPost()
          expect(PostStore.get '1').to.not.exist
          expect(PostStore.get 's3').to.exist
          expect(PostStore.get('s3').pending).to.be.false

      describe '| handling sync failures', ->
        before 'simulating user created post...', createTestPost
        after 'resetting post store', clearEverything
        it 'should mark a post as failed when sync fails', ->
          expect(PostStore.get('1').failed).to.not.exist
          expect(PostStore.get('1').pending).to.be.true
          failTestPost()
          expect(PostStore.get('1').failed).to.be.true
          expect(PostStore.get('1').pending).to.be.false

      describe '| handling failed post retries', ->
        before 'simulating user created post...', ->
          createTestPost()
          failTestPost()
        after 'resetting post store', clearEverything
        it 'should mark a post as pending when it is retried', ->
          expect(PostStore.get('1').failed).to.be.true
          expect(PostStore.get('1').pending).to.be.false
          retryTestPost()
          expect(PostStore.get('1').failed).to.be.false
          expect(PostStore.get('1').pending).to.be.true
        it 'should migrate a failed post after a successful retry', ->
          clearEverything()
          createTestPost()
          failTestPost()
          expect(PostStore.get('1').failed).to.be.true
          expect(PostStore.get('1').pending).to.be.false
          retryTestPost()
          expect(PostStore.get('1').failed).to.be.false
          expect(PostStore.get('1').pending).to.be.true
          expect(PostStore.get 's3').to.not.exist
          syncTestPost()
          expect(PostStore.get '1').to.not.exist
          expect(PostStore.get 's3').to.exist
          expect(PostStore.get('s3').failed).to.not.be.okay
          expect(PostStore.get('s3').pending).to.be.false
