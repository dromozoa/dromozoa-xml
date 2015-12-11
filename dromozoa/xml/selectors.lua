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

local function query(selector, stack)
  local top = stack:top()
  if selector(top, stack, #stack) then
    return top
  end
  for node in top:each() do
    if type(node) == "table" then
      stack:push(node)
      local result = query(selector, stack)
      stack:pop()
      if result ~= nil then
        return result
      end
    end
  end
end

local function query_all(selector, stack, result)
  local top = stack:top()
  if selector(top, stack, #stack) then
    result:push(top)
  end
  for node in top:each() do
    if type(node) == "table" then
      stack:push(node)
      query_all(selector, stack, result)
      stack:pop()
    end
  end
  return result
end

local class = {
  query = query;
  query_all = query_all;
}

function class.compile(s)
  local selector, matcher = class(s):apply()
  if not matcher:eof() then
    error("cannot reach eof at position " .. matcher.position)
  end
  return selector
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, this)
    return setmetatable(class.new(this), metatable)
  end;
})
