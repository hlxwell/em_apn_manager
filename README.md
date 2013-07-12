EventMachine APN Manager - em_apn_manager
==============

EventMachine APN Connection Manager, The purpose is to support multiple cert and multiple application with one process.

Steps to use this gem.
1. Add `gem 'em_apn_manager'`
2. Run `Bundle exec em_apn_manager --redis-host=xx.xx.xx.xx --redis-port=xxxx`
3. Put this in your code `EM::ApnManager`

--redis-host bind address (defaults to 127.0.0.1)
    address of your redis server

--redis-port port
  the port of your redis server (defaults to)

--help
  usage message

--daemon or -d
  Runs process as daemon, not available on Windows
