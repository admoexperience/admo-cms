Getting started
---------------
install [rbenv](https://github.com/sstephenson/rbenv) and [ruby-build](https://github.com/sstephenson/ruby-build)


Seed the Database 
  
  rake db:seed #NB ONLY run this in dev mode

defaults:
  
  * Username: demo@admoexpereince.com
  * Password: demo

To run server in dev mode

    foreman start -f Procfile.dev

This runs

    rails s -p 3002

As well as live-reload

    guard

Or you can run both commands separately.
