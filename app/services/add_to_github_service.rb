class AddToGithubService
  def initialize(file, student)
    @file = file
    @student = student
  end

  def execute
    client = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])

    # create a private repo with student id
    client.create_repository(@student.id, organization: 'nseadlc-2020', private: 'true')
    # Add node workflow
    client.create_contents("nseadlc-2020/#{@student.id}", '.github/workflows/node.js.yml', 'skip ci', workflow_node)
    # Add submission
    client.create_contents("nseadlc-2020/#{@student.id}", 'submission.zip', 'Adding student submission', file: @file.path)
  end

  private

  def workflow_node
    <<-DOC
name: Node.js Test Runner

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    if: "!contains(github.event.head_commit.message, 'skip ci')"
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [14.x]

    steps:
    - uses: actions/checkout@v2
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v1
      with:
        node-version: ${{ matrix.node-version }}
    - run: unzip -j submission.zip
    - run: chmod +x todo.sh
    - run: npm i
    - run: npm test
    DOC
  end
end