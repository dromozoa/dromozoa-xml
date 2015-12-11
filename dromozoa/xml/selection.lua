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
local element = require "dromozoa.xml.element"

local class = {}

function class:write(out)
  for node in sequence.each(self) do
    element.write_text(node, out)
  end
  return out
end

function class:encode()
  return class.write(self, sequence_writer()):concat()
end

function class:write_text(out)
  for node in sequence.each(self) do
    element.write_text(node, out)
  end
  return out
end

function class:text()
  return class.write_text(self, sequence_writer()):concat()
end

function class:query(s)
  local result
  for node in sequence.each(self) do
    result, s = element.query(node, s)
    if result then
      return result, s
    end
  end
end

function class:query_all(s)
  local result
  for node in sequence.each(self) do
    result, s = element.query_all(node, s, result)
  end
  return result, s
end

local metatable = {
  __index = class;
  __tostring = class.encode;
}

return setmetatable(class, {
  __index = sequence;
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
