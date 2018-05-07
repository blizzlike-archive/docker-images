#!/usr/bin/env lua

package.path = package.path .. ';/home/blizzlike/travis/modules/?.lua'

local github = require('github')
local travis = require('travis')
local s3 = require('s3')

local W = os.getenv('CORE_DIR')
local DISTRO = os.getenv('DISTRONAME')

core = {
  --
  github = { token = os.getenv('GITHUB_TOKEN')},
  s3 = {
    id = os.getenv('S3_ID'),
    key = os.getenv('S3_KEY'),
    endpoint = os.getenv('S3_ENDPOINT'),
    bucket = 's3://travis'
  },

  --
  commands = {
    cmake = {
      cmd = 'cmake ../development ' ..
        '-DUSE_ANTICHEAT=0 ' ..
        '-DUSE_EXTRACTORS=1 ' ..
        '-DUSE_LIBCURL=1 ' ..
        '-DDEBUG=1 ' ..
        '-DCMAKE_INSTALL_PREFIX=' .. os.getenv('CORE_DIR') .. '/core',
      workdir = W .. '/build'
    },
    make = {
      cmd = 'make -j4', workdir = W .. '/build'
    },
    make_install = {
      cmd = 'make install', workdir = W .. '/build'
    },
    tarxz = {
      cmd = 'tar cJf ' ..
        W .. '/packages/core-' .. DISTRO .. '.tar.xz ./core',
      workdir = W
    }
  }
}

function core.build(self)
  print('Starting build #' .. travis.env.build.number)
  core:execute(core.commands.cmake)
  core:execute(core.commands.make)
  core:execute(core.commands.make_install)
  core:execute(core.commands.tarxz)

  if travis.env.type ~= 'pull_request' and
      travis.env.branch == 'master' and not travis.env.tag then
    s3:sync(W .. '/packages', core.s3.bucket .. '/' .. travis.env.build.number)
    local latest = github:get_release({ name = 'latest' })

    if latest then github:delete_release(latest.id) end
    github:create_release(
      (latest or { tag_name = 'latest' }).tag_name,
      (latest or { target_commitish = 'master' }).target_commitish,
      (latest or { name = 'latest'}).name,
      nil, true, false)
  end
end

function core.execute(self, task)
  print(task.cmd)
  local c = os.execute(
    'cd ' .. task.workdir .. ' && ' .. task.cmd)
  if c ~= 0 then os.exit(1) end
  return c
end

function core.publish(self)
  if travis.env.type ~= 'pull_request' and
      travis.env.branch == 'master' and travis.env.tag then
    print('Publish packages of ' .. travis.env.tag)
    s3:sync(core.s3.bucket .. '/' .. travis.env.build.number, W .. '/packages')
    local tag = github:get_release({ name = travis.env.tag })
    if tag then github:publish(tag.id, W .. '/packages') end
  end
  s3:clear(core.s3.bucket .. '/' .. travis.env.build.number)
end

function core.run(self)
  if not travis:init() then
    print('no travis run - nothing to do.')
    os.exit(1)
  end

  if not github:init(travis.env.slug, core.github.token) then
    print('cannot init github client')
    os.exit(1)
  end

  if not s3:init(core.s3.id, core.s3.key, core.s3.endpoint) then
    print('cannot init s3 bucket sync')
    os.exit(1)
  end

  -- build stage
  if travis.env.build.stage == 'build' then core:build() end

  -- publish stage
  if travis.env.build.stage == 'publish' then core:publish() end
end

function core.stage_publish(self, env)
end

core:run()
