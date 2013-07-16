EventMachine APN Manager
==============

EventMachine APN Connection Manager, The purpose is to support multiple cert and multiple application with one process.

Steps to use this gem.
1. Add `gem 'em_apn_manager', git: 'git@github.com:hlxwell/em_apn_manager.git'`
2. Run `bundle exec rails g event_machine:apn_manager:install` to generate 'config/em_apn_manager.yml' file.
2. Run `bundle exec em_apn_manager -e development`
3. Put this in your code ```ruby
EM::ApnManager.push_notification({
  cert: File.read(ENV["APNS_CERT"]),
  key: File.read(ENV["APNS_KEY"]),
  token: DEVICE_TOKEN,
  message: "Hello User##{rand * 10000}."
})
```

TO DOs
==================
1. Implement running `bundle exec em_apn_manager -e development` in background, support `-daemon` and `-pid_file`