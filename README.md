# Running

```
bundle
rake db:setup db:migrate

cd /tmp && redis-server
bundle exec sidekiq --environment development -C config/sidekiq.yml
bundle exec rails server
```
 
# Deployment

In 
