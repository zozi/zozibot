# Rickbot

This is a version of GitHub's Campfire bot, rickbot. He's pretty cool.

This version is designed to be deployed on Rackspace using Chef

## Playing with Rickbot

You'll need to install the necessary dependencies for rickbot. All of
those dependencies are provided by [npm][npmjs].

[npmjs]: http://npmjs.org

## HTTP Listener

Rickbot has a HTTP listener which listens on the port specified by the `PORT`
environment variable.

You can specify routes to listen on in your scripts by using the `router`
property on `robot`.

```coffeescript
module.exports = (robot) ->
  robot.router.get "/hubot/version", (req, res) ->
    res.end robot.version
```

There are functions for GET, POST, PUT and DELETE, which all take a route and
callback function that accepts a request and a response.

### Redis

Install redis

    brew install redis

Start redis locally:

    redis-server /usr/local/etc/redis.conf

If you don't require any persistence feel free to remove the
`redis-brain.coffee` from `hubot-scripts.json` and you don't need to worry
about redis at all.

### Testing Rickbot Locally

You can test your rickbot by running the following.

    % bin/rickbot

You'll see some start up output about where your scripts come from and a
prompt.

    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading adapter shell
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/scripts
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/src/scripts
    Hubot>

Then you can interact with hubot by typing `hubot help`.

    Hubot> hubot help

    Hubot> animate me <query> - The same thing as `image me`, except adds a few
    convert me <expression> to <units> - Convert expression to given units.
    help - Displays all of the help commands that Hubot knows about.
    ...

Take a look at the scripts in the `./scripts` folder for examples.
Delete any scripts you think are silly.  Add whatever functionality you
want hubot to have.

## Adapters

Adapters are the interface to the service you want your rickbot to run on. This
can be something like Campfire or IRC. There are a number of third party
adapters that the community have contributed. Check the
[hubot wiki][hubot-wiki] for the available ones.

If you would like to run a non-Campfire or shell adapter you will need to add
the adapter package as a dependency to the `package.json` file in the
`dependencies` section.

Once you've added the dependency and run `npm install` to install it you can
then run rickbot with the adapter.

    % bin/rickbot -a <adapter>

Where `<adapter>` is the name of your adapter without the `rickbot-` prefix.

[hubot-wiki]: https://github.com/github/hubot/wiki

## hubot-scripts

There will inevitably be functionality that everyone will want. Instead
of adding it to rickbot itself, you can submit pull requests to
[hubot-scripts][hubot-scripts].

To enable scripts from the hubot-scripts package, add the script name with
extension as a double quoted string to the hubot-scripts.json file in this
repo.

[hubot-scripts]: https://github.com/github/hubot-scripts

## Deployment

Rickbot is deployed using the Mina deployer

    % mina deploy

More info on deploying rickbot in a windows environement can be found at
 [deploying hubot onto UNIX][deploy-unix] wiki page.

[heroku-node-docs]: http://devcenter.heroku.com/articles/node-js
[deploy-unix]: https://github.com/github/hubot/wiki/Deploying-Hubot-onto-UNIX

