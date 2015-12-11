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
local ipairs = require "dromozoa.commons.ipairs"
local pairs = require "dromozoa.commons.pairs"
local escape = require "dromozoa.xml.escape"

local function write(out, v)
  local t = type(v)
  if t == "number" then
    out:write(escape(string.format("%.17g", v)))
  elseif t == "string" then
    out:write(escape(v))
  elseif t == "boolean" then
    if v then
      out:write("true")
    else
      out:write("false")
    end
  elseif t == "table" then
    local name = v[1]
    local attrs = v[2]
    local content = v[3]
    out:write("<", name)
    for name, value in pairs(attrs) do
      out:write(" ", name, "=\"", escape(value), "\"")
    end
    if empty(content) then
      out:write("/>")
    else
      out:write(">")
      for _, node in ipairs(content) do
        write(out, node)
      end
      out:write("</", name, ">")
    end
  end
  return out
end

return write
