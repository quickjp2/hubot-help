Helper = require('hubot-test-helper')
chai = require 'chai'
nock = require 'nock'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

helper = new Helper('../src/help.coffee')

describe 'help', ->
  beforeEach ->
    @room = helper.createRoom()
    @robot =
      respond: sinon.spy()
  afterEach ->
    @room.destroy()

  context "replies with help message", ->
    it 'replies back to channel', ->
      @room.user.say('alice', '@hubot help').then =>
        expect(@room.messages).to.eql [
          ['alice', '@hubot help']
          ['hubot', "@alice hubot help - Displays all of the help commands that Hubot knows about.\nhubot help <query> - Displays all help commands that match <query>."]
        ]
    it 'replies privately when needed', ->
      @room.destroy()
      process.env.HUBOT_HELP_REPLY_IN_PRIVATE = true
      @room = helper.createRoom()
      @room.user.say('alice', '@hubot help').then =>
        expect(@room.messages).to.eql [
          ['alice', '@hubot help']
          ['hubot', "hubot help - Displays all of the help commands that Hubot knows about.\nhubot help <query> - Displays all help commands that match <query>."]
          ['hubot','@alice replied to you in private!']
        ]
