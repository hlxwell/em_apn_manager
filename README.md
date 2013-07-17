EventMachine APN Manager
==============

EventMachine APN Connection Manager, The purpose is to support multiple cert and multiple application with one process.
It use redis pubsub to get message from application, then send message to apple, also kept the connection to APNS server, so it won't be blocked by apple.

### Steps for running with `Rails`:

1. Add below line to `Gemfile`:
```ruby
gem 'em_apn_manager', git: 'git@github.com:hlxwell/em_apn_manager.git'
```

2. Generate `config/em_apn_manager.yml` file:
```shell
bundle exec rails g event_machine:apn_manager:install
```

3. Run the server
```shell
bundle exec em_apn_manager server -e development
```


### Steps for running `Standalone`:

1. Install `em_apn_manager` gem
```shell
gem install em_apn_manager
```

2. Run
```shell
// read redis from url
em_apn_manager server -r redis://localhost:6379/em_apn_manager
```
or
```shell
// read redis config from config
em_apn_manager server -c CONFIG_FILE_PATH -e development
```

### Put below line to your code for sending push notification:

```ruby
EM::ApnManager.push_notification({
  env: CERT_ENVIRONMENT,
  cert: PEM_CERT_TEXT_CONTENT,
  token: DEVICE_TOKEN,
  message: YOUR_MESSAGE
})
```
or if you don't need to install em_apn_manager in your project, you can do this:
```ruby
your_redis_instance.publish "push-notification", {
  env: "development",
  cert: cert,
  token: options[:token],
  message: options[:message]
}.to_json
```

If you want to run server in background:

```shell
em_apn_manager server --daemon --pid_file /PATH/TO/PID
```
or
```shell
em_apn_manager server -d -p /PATH/TO/PID
```
Generate pem from p12
==================

This is the [Tutorial](http://docs.urbanairship.com/build/ios.html#set-up-your-application-with-apple) for how to get `p12` file.

You have to convert p12 format to pem format by below command line.
```
openssl pkcs12 -in cert.p12 -out cert.pem -nodes -clcerts
```

