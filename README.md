EventMachine APN Manager
==============

EventMachine APN Connection Manager, The purpose is to support multiple cert and multiple application with one process.

Steps for running with *Rails*:

1. Add `gem 'em_apn_manager', git: 'git@github.com:hlxwell/em_apn_manager.git'` to *Gemfile*.

2. Run `bundle exec rails g event_machine:apn_manager:install` to generate `config/em_apn_manager.yml` file.

3. Run `bundle exec em_apn_manager server -e development`.


Steps for running `Standalone`:

1. Run `gem install em_apn_manager`

2. Run `em_apn_manager server --redis-host 127.0.0.1 --redis-port 6379` or `em_apn_manager server --config CONFIG_FILE_PATH`

Put below line to your code for sending push notification:

`EM::ApnManager.push_notification({
  env: CERT_ENVIRONMENT,
  cert: PEM_CERT_TEXT_CONTENT,
  token: DEVICE_TOKEN,
  message: YOUR_MESSAGE
})`

Running server in background:

`em_apn_manager server --daemon`

Generate pem from p12
==================

This is how you get `p12` file:
http://docs.urbanairship.com/build/ios.html#set-up-your-application-with-apple

You have to convert p12 format to pem format by below command line.
`openssl pkcs12 -in cert.p12 -out cert.pem -nodes -clcerts`

