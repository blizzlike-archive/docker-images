#!/usr/bin/env lua

local github = require('github')
local travis = require('travis')
local s3 = require('s3')

local W = os.getenv('CORE_DIR')
local DISTRO = os.getenv('DISTRONAME')

octoflow = {
  --
  github = { token = os.getenv('GITHUB_TOKEN')},

  --
  commands = {
    make_documentation = {
      cmd = 'raml2html --theme raml2html-kaa-theme ' ..
        './docs/v1.raml > ../docs.blizzlike.org/core-api/index.html',
      workdir = W .. '/development'
    }
  }
}

function octoflow.generate(self)
  print('Generating API docs #' .. travis.env.build.number)
  if travis.env.type ~= 'pull_request' and
      travis.env.branch == 'master' then
    if not travis.env.tag or travis.env.tag == '' then
      docs = github:clone('blizzlike-org/docs.blizzlike.org', 'master')
      travis:execute(octoflow.commands.make_documentation)
      docs:commit('update documentation')
      docs:push('master')
    end
  end
end

function octoflow.run(self)
  if not travis:init() then
    print('no travis run - nothing to do.')
    os.exit(1)
  end

  if not github:init(travis.env.slug, octoflow.github.token) then
    print('cannot init github client')
    os.exit(1)
  end

  -- build stage
  if travis.env.build.stage == 'generate' then octoflow:generate() end
end

octoflow:run()
