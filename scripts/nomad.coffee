#
# Rickbot-to-Nomad translator
#
#

scripts = process.env.HUBOT_NOMAD_HOME or "/Users/tauasa/scripts/nomad-"
spawn = require('child_process').spawn

module.exports = (robot) ->

	execute = (cmd, res) ->
		path = scripts + cmd + ".sh"
		child = spawn(path)

		child.stdout.on 'data', ( data ) -> 
      		res.send "#{ data }"

      	child.stderr.on 'data', ( data ) -> 
      		res.send "Barf: #{ data }"

    #
    # proess commands
    #

	robot.hear /(?:nomad1)/i, (res) ->
		execute('test', res)

	robot.hear /(?:nomad2)/i, (res) ->
		execute('time', res)


