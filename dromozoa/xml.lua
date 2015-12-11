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

local sequence_writer = require "dromozoa.commons.sequence_writer"
local xml = require "dromozoa.commons.xml"
local element = require "dromozoa.xml.element"
local microxml_parser = require "dromozoa.xml.microxml_parser"
local node_list = require "dromozoa.xml.node_list"
local selector = require "dromozoa.xml.selector"

local function parse(this)
  return microxml_parser(this):apply()
end

local class = {
  element = element;
  node_list = node_list;
  parse = parse;
  selector = selector;
}

function class.encode(v)
  return element.write(v, sequence_writer()):concat()
end

function class.decode(s)
  local v, matcher = parse(s)
  if not matcher:eof() then
    error("cannot reach eof at position " .. matcher.position)
  end
  return v
end

element.super = class

return setmetatable(class, {
  __index = xml;
})
