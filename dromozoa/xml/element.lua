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

local empty = require "dromozoa.commons.empty"
local pairs = require "dromozoa.commons.pairs"
local sequence = require "dromozoa.commons.sequence"
local sequence_writer = require "dromozoa.commons.sequence_writer"
local xml = require "dromozoa.commons.xml"

local class = {}

function class.new(name, attrs, content)
  return { name, attrs, content }
end

function class:name()
  return self[1]
end

function class:attr(name)
  local value = self[2][name]
  if value ~= nil then
    if type(value) == "table" then
      return table.concat(value, " ")
    else
      return tostring(value)
    end
  end
end

function class:count(name)
  if name == nil then
    return #self[3]
  else
    local count = 0
    for node in class.each(self, name) do
      count = count + 1
    end
    return count
  end
end

function class:each(name)
  if name == nil then
    return coroutine.wrap(function ()
      for node in sequence.each(self[3]) do
        coroutine.yield(node)
      end
    end)
  else
    return coroutine.wrap(function ()
      for node in sequence.each(self[3]) do
        if type(node) == "table" and class.name(node) == name then
          coroutine.yield(node)
        end
      end
    end)
  end
end

function class:write(out)
  local name = class.name(self)
  out:write("<", name)
  for name in pairs(self[2]) do
    out:write(" ", name, "=\"", xml.escape(class.attr(self, name)), "\"")
  end
  local content = self[3]
  if empty(content) then
    out:write("/>")
  else
    out:write(">")
    for node in class.each(self) do
      if type(node) == "table" then
        class.write(node, out)
      else
        out:write(xml.escape(tostring(node)))
      end
    end
    out:write("</", name, ">")
  end
  return out
end

function class:encode()
  return class.write(self, sequence_writer()):concat()
end

function class:write_text(out)
  for node in class.each(self) do
    if type(node) ~= "table" then
      out:write(tostring(node))
    end
  end
  return out
end

function class:text()
  return class.write_text(self, sequence_writer()):concat()
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
    result = class.super.selection()
  end
  return s:query_all(sequence():push(self), result), s
end

local metatable = {
  __index = class;
  __tostring = class.encode;
}

return setmetatable(class, {
  __call = function (_, name, attrs, content)
    return setmetatable(class.new(name, attrs, content), metatable)
  end;
})
