working_directory '/var/lib/redmine'

pid "/var/lib/redmine/tmp/pids/unicorn.pid"
stderr_path "/var/lib/redmine/log/unicorn.log"
stdout_path "/var/lib/redmine/log/unicorn.log"
 
listen "/var/lib/redmine/tmp/sockets/unicorn.sock"
worker_processes 1
timeout 30
