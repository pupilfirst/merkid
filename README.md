# Running

```
bundle
rake db:setup db:migrate db:seed

cd /tmp && redis-server
bundle exec sidekiq --environment development -C config/sidekiq.yml
bundle exec rails server
```
 
# Production Workflow

## Extract code for review and do auto-elimination 

We render the submitted code in the review interface to avoid having to manually download the zip and extract. But this
is done through a rake task:

    heroku rake extract_program_and_autograde:unzip_and_save LIMIT=300 EXECUTE_LIVE=yes

It will also auto-grade empty/invalid submissions.

## Send email reminders for completing code submission

Email students who have not yet submitted any code, and remind them of last date of submission.

    while true; do heroku rake email_students:completion_reminder LIMIT=2000; sleep 120; done

Sends the mail in batches of 2000, sleeps for 2 minutes, and continues. Have to manually cancel once the list is exhausted.


