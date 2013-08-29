# Please configure the path and RAILS_ENV for your server.

/bin/bash -l -c 'cd /Users/hideaway/Works/Summer_Work/Summer2013_VTS/Colloki_Project/colloki-master && RAILS_ENV=development'

# script to fetch and post blogs/news for the day. 
/bin/bash -l -c 'bundle exec rake fetch --silent >> log/cron.log 2>&1'
# script to fetch facebook posts for the day.
/bin/bash -l -c 'bundle exec rake fbfetch --silent >> log/cron.log 2>&1'
# script to fetch tweets for the day.
/bin/bash -l -c 'bundle exec rake twfetch --silent >> log/cron.log 2>&1'
