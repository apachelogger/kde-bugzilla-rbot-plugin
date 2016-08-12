[![Build Status](https://travis-ci.org/apachelogger/kde-bugzilla-rbot-plugin.svg?branch=master)](https://travis-ci.org/apachelogger/kde-bugzilla-rbot-plugin)

# Installation

- Clone anywhere
- Install dependencies
  - When using Bundler: `bundle install --without=development`
  - Manually: `gem install finer_struct && gem install faraday`
- Add clone path to `~/.rbot/conf.yaml`
```
plugins.path:
  - /home/me/src/git/rbot-bugzilla
```
- Restart bot
