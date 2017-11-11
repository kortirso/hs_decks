server '46.101.217.59', user: 'kortirso', roles: %w[app db web], primary: true

role :app, %w[kortirso@46.101.217.59]
role :web, %w[kortirso@46.101.217.59]
role :db,  %w[kortirso@46.101.217.59]

set :rails_env, :production
set :stage, :production

set :ssh_options,
    keys: %w[/home/kortirso/.ssh/id_rsa /users/kortirso/.ssh/id_rsa],
    forward_agent: true,
    auth_methods: %w[publickey password],
    port: 2999
