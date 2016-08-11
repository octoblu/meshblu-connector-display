{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-display:index')
nircmd          = require 'nircmd'

class Connector extends EventEmitter
  constructor: ->

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    callback()

  displayOn: () =>
    nircmd 'monitor on'
    .then () ->
      nircmd 'sendmouse move -1 1'
      @_emitStatus "on"

  displayOff: () =>
    nircmd 'monitor off'
    .then () ->
      @_emitStatus "off"

  onConfig: (device={}) =>
    { @options } = device
    debug 'on config', @options
    return @displayOn() unless !@options.on
    @displayOff()

  start: (device, callback) =>
    debug 'started'
    @onConfig device
    callback()

  _emitStatus: (msg) =>
    @emit 'message', {
      topic: 'message'
      devices: ["*"]
      data:
        status: msg
    }

module.exports = Connector
