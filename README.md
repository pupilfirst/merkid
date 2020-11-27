# Student Status

email_unverified
email_verified
application_form_submitted
task_revealed
task_submitted
task_reviewed:
    task_rejected/task_accepted
    interview_rejected/interview_accepted

# Student Flow

1. Gather data from TypeForm
  - TypeForm webhook -> receive
  - We poll TypeForm thru their API
  - We poll the Google Docs sheet

2. When a new student is added:
  - User.create(status: "unverified")
  - Send email to student with login link

3. When student logins, come to /:
  - If "unverified"
    - User.update("verified")
    - Tell "When you are ready to start, click BEGIN"
  - If "submitted"
    - Tell "Pending review!"
  - If "accepted"/"rejected", tell accordingly

4. When student BEGINs /begin
  - Only if "verified". Else /
    - User.update("begun", begun_at: datetime)
    - Show "Here's the problem. These are the instructions"
    - Show "Click here to SUBMIT"

5. GET /submit 
  - If not "begun", redirect to /
  - Ask "Upload your ZIP file"
  - On upload, update("submitted"). redirect to /

# Admin Flow

* List of all submissions
  - Download multiple pending submissions together

* For each submission,
  - EMAIL STUDENT option
  - ADD PRIVATE NOTE option

  - mark for subjective questions, its notes
  - mark for code review, its notes
  - mark for interview, its notes

  - set status:
    - code-accepted/code-rejected
    - interview-accepted/interview-rejected
