-- Copyright (C) 2015 Tomoyuki Fujimori <moyu@dromozoa.com>
--
-- This file is part of dromozoa-xml.
--
-- dromozoa-xml is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- dromozoa-xml is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with dromozoa-xml.  If not, see <http://www.gnu.org/licenses/>.

local sequence = require "dromozoa.commons.sequence"
local sequence_writer = require "dromozoa.commons.sequence_writer"
local split = require "dromozoa.commons.split"
local string_matcher = require "dromozoa.commons.string_matcher"
local utf8 = require "dromozoa.commons.utf8"
local selector_generator = require "dromozoa.xml.selector_generator"
local selector_parser = require "dromozoa.xml.selector_parser"

local function query(fn, stack)
  local top = stack:top()
  if fn(top, stack, #stack) then
    return top
  end
  for node in top:each() do
    if type(node) == "table" then
      stack:push(node)
      local result = query(fn, stack)
      stack:pop()
      if result ~= nil then
        return result
      end
    end
  end
end

local function query_all(fn, stack, result)
  local top = stack:top()
  if fn(top, stack, #stack) then
    result:push(top)
  end
  for node in top:each() do
    if type(node) == "table" then
      stack:push(node)
      query_all(fn, stack, result)
      stack:pop()
    end
  end
  return result
end

local class = {}

function class.new(s)
  local fn, matcher = selector_parser(s, selector_generator()):apply()
  if not matcher:eof() then
    error("cannot reach eof at position " .. matcher.position)
  end
  return {
    fn = fn;
  }
end

function class:test(stack)
  local n = #stack
  return self.fn(stack[n], stack, n)
end

function class:query(stack)
  return query(self.fn, stack)
end

function class:query_all(stack, result)
  return query_all(self.fn, stack, result)
end

local metatable = {
  __index = class;
}

function metatable:__call(...)
  return self.fn(...)
end

return setmetatable(class, {
  __call = function (_, s)
    return setmetatable(class.new(s), metatable)
  end;
})
