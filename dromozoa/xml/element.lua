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

local ipairs = require "dromozoa.commons.ipairs"
local sequence = require "dromozoa.commons.sequence"
local sequence_writer = require "dromozoa.commons.sequence_writer"
local write = require "dromozoa.xml.write"

local class = {}

function class.new(name, attrs, content)
  return { name, attrs, content }
end

function class:name()
  return self[1]
end

function class:attr(name)
  return self[2][name]
end

function class:each()
  return self[3]:each()
end

function class:write_text(out)
  for i, node in ipairs(self[3]) do
    if type(node) ~= "table" then
      out:write(node)
    end
  end
  return out
end

function class:text()
  return self:write_text(sequence_writer()):concat()
end

function class:query(s)
  if type(s) == "string" then
    s = class.super.selector(s)
  end
  return s:query(sequence():push(self)), s
end

function class:query_all(s, result)
  if type(s) == "string" then
    s = class.super.selector(s)
  end
  if result == nil then
    result = class.super.node_list()
  end
  return s:query_all(sequence():push(self), result), s
end

local metatable = {
  __index = class;
}

function metatable:__tostring()
  return write(sequence_writer(), self):concat()
end

return setmetatable(class, {
  __call = function (_, name, attribute_list, content)
    return setmetatable(class.new(name, attribute_list, content), metatable)
  end;
})
