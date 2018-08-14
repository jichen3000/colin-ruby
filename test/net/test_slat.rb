
host 'qa-host' do
  user 'root'
  password 'fortinet'

  task :hello do
    cd '/home'
    log "Now in directory", cwd
    exec! 'ls -la /', echo: true
  end
end