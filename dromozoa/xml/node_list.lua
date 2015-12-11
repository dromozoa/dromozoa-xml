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
local selectors = require "dromozoa.xml.selectors"
local write = require "dromozoa.xml.write"

local class = {}

function class:text()
  local out = sequence_writer()
  for node in self:each() do
    out:write(node:text())
  end
  return out:concat()
end

function class:query(selector)
  if type(selector) == "string" then
    selector = selectors.compile(selector)
  end
  for node in self:each() do
    if type(node) == "table" then
      local result = node:query(selector)
      if result then
        return result, selector
      end
    end
  end
end

function class:query_all(selector)
  if type(selector) == "string" then
    selector = selectors.compile(selector)
  end
  local result = class()
  for node in self:each() do
    if type(node) == "table" then
      result = node:query_all(selector, result)
    end
  end
  return result
end

local metatable = {
  __index = class;
}

function metatable:__tostring()
  local out = sequence_writer()
  for node in self:each() do
    write(out, node)
  end
  return out:concat()
end

return setmetatable(class, {
  __index = sequence;
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
