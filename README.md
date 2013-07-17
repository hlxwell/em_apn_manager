EventMachine APN Manager
==============

EventMachine APN Connection Manager, The purpose is to support multiple cert and multiple application with one process.

Steps for running with *Rails*:

1. Add below line to *Gemfile*:
```
gem 'em_apn_manager', git: 'git@github.com:hlxwell/em_apn_manager.git'
```

2. Generate `config/em_apn_manager.yml` file:
```
bundle exec rails g event_machine:apn_manager:install
```

3. Run the server
```
bundle exec em_apn_manager server -e development
```


Steps for running `Standalone`:

1. Install `em_apn_manager` gem
```
gem install em_apn_manager
```

2. Run
```
em_apn_manager server -r redis://localhost:6379/em_apn_manager // read redis from url
or
em_apn_manager server -c CONFIG_FILE_PATH -e development // read redis config from config
```

Put below line to your code for sending push notification:

```ruby
EM::ApnManager.push_notification({
  env: CERT_ENVIRONMENT,
  cert: PEM_CERT_TEXT_CONTENT,
  token: DEVICE_TOKEN,
  message: YOUR_MESSAGE
})
```

If you want to run server in background:

`em_apn_manager server --daemon --pid_file /PATH/TO/PID` or `em_apn_manager server -d -p /PATH/TO/PID`

Generate pem from p12
==================

This is how you get `p12` file:
[Tutorial](http://docs.urbanairship.com/build/ios.html#set-up-your-application-with-apple)

You have to convert p12 format to pem format by below command line.
```
openssl pkcs12 -in cert.p12 -out cert.pem -nodes -clcerts
```

