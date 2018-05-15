#!/usr/bin/env lua

local github = require('github')
local travis = require('travis')
local s3 = require('s3')

local W = os.getenv('CORE_DIR')
local DISTRO = os.getenv('DISTRONAME')

octoflow = {
  --
  github = { token = os.getenv('GITHUB_TOKEN')},
  s3 = {
    id = os.getenv('S3_ID'),
    key = os.getenv('S3_KEY'),
    endpoint = os.getenv('S3_ENDPOINT'),
    bucket = 's3://travis/core'
  },

  --
  commands = {
    cmake = {
      cmd = 'cmake ../development ' ..
        '-DUSE_ANTICHEAT=0 ' ..
        '-DUSE_EXTRACTORS=1 ' ..
        '-DUSE_LIBCURL=1 ' ..
        '-DDEBUG=0 ' ..
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

function octoflow.build(self)
  print('Starting build #' .. travis.env.build.number)
  if DISTRO == 'trusty' then
    octoflow.commands.cmake.cmd = octoflow.commands.cmake.cmd ..
      ' -DCMAKE_CXX_COMPILER=g++-6' ..
      ' -DCMAKE_C_COMPILER=gcc-6'
  end

  travis:execute(octoflow.commands.cmake)
  travis:execute(octoflow.commands.make)
  travis:execute(octoflow.commands.make_install)
  travis:execute(octoflow.commands.tarxz)

  if not s3:sync(W .. '/packages', octoflow.s3.bucket .. '/' .. travis.env.build.number) then
    os.exit(1)
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
