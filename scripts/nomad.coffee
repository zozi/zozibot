#
# Rickbot-to-Nomad translator
#
#

spawn = require('child_process').spawn

module.exports = (robot) ->

	execute = (cmd, msg) ->
		path = "/Users/tauasa/scripts/nomad-" + cmd + ".sh"
		child = spawn(path)

		child.stdout.on 'data', ( data ) -> 
      		msg.send "#{ data }"

      	child.stderr.on 'data', ( data ) -> 
      		msg.send "Barf: #{ data }"

    #
    # proess commands
    #

	robot.hear /(?:nomad1)/i, (msg) ->
		execute('test', msg)

	robot.hear /(?:nomad2)/i, (msg) ->
		execute('time', msg)


