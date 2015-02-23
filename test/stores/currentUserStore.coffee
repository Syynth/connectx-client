
{expect} = require 'chai'

{ActionType} = require 'connectx/config'
{CurrentUserStore} = require 'connectx/stores'
MemoryCache = require 'connectx/memoryCache'
Cache = require 'connectx/cache'
_ = require 'lodash'

Dispatcher = require 'connectx/dispatcher'

clearEverything = ->
  localStorage.clear()
  CurrentUserStore.clearAll()
  # This uses knowledge of the internals
  CurrentUserStore.cache = new Cache
  CurrentUserStore.queue = new MemoryCache

module.exports = ->
