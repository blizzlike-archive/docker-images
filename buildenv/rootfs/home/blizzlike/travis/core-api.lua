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
        './docs/v1.raml > ../docs.blizzlike.org/core-api/index.html'
      workdir = W .. '/development'
    }
  }
}

function octoflow.build(self)
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

function octoflow.publish(self)
  if not s3:sync(octoflow.s3.bucket .. '/' .. travis.env.build.number, W .. '/packages') then
    os.exit(1)
  end

  if travis.env.type ~= 'pull_request' and
      travis.env.branch == 'master' then
    if not travis.env.tag or travis.env.tag == '' then
      print('Tag the latest commit')
      local status, latest = github:get_release({ name = 'latest' })
      if status == 200 then github:delete_release(latest.id) end
      github:create_release(
        (latest or { tag_name = 'latest' }).tag_name,
        (latest or { target_commitish = 'master' }).target_commitish,
        (latest or { name = 'latest' }).name,
        nil, false, true)
    end

    print('Publish packages of latest commit')
    local status, tag = github:get_release({ name = 'latest' })
    if status == 200 then
      if not github:publish_files(tag.id, W .. '/packages') then
        print('Cannot publish files')
      end
    else
      print('Cannot get release info')
    end
  end

  s3:clear(octoflow.s3.bucket .. '/' .. travis.env.build.number)
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

  if not s3:init(octoflow.s3.id, octoflow.s3.key, octoflow.s3.endpoint) then
    print('cannot init s3 bucket sync')
    os.exit(1)
  end

  -- build stage
  if travis.env.build.stage == 'build' then octoflow:build() end

  -- publish stage
  if travis.env.build.stage == 'publish' then octoflow:publish() end
end

octoflow:run()
