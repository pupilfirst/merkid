class UpdateGithubWorkflowService
  def initialize(students)
    @students = students
  end

  def execute
    client = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])
    @failed = []
    @students.each do |student|
      begin
        file = client.contents("nseadlc-2020/#{student.id}", :path => '.github/workflows/node.js.yml')
        client.update_contents("nseadlc-2020/#{student.id}", '.github/workflows/node.js.yml', 'Update student submission', file.sha, workflow_node)
      rescue
        @failed << student
        puts "Error #{student.id}"
      end
    end
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
    - run: ln -sf todo.sh todo
    - run: chmod +x todo.sh
    - run: npm i
    - run: make test
    DOC
  end
end