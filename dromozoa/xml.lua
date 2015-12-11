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
local element = require "dromozoa.xml.element"
local escape = require "dromozoa.xml.escape"
local node_list = require "dromozoa.xml.node_list"
local parser = require "dromozoa.xml.parser"
local selectors = require "dromozoa.xml.selectors"
local write = require "dromozoa.xml.write"

local function parse(this)
  return parser(this):apply()
end

local class = {
  escape = escape;
  write = write;
  parse = parse;
  selectors = selectors;
  element = element;
  node_list = node_list;
}

function class.encode(v)
  return write(sequence_writer(), v):concat()
end

function class.decode(s)
  local v, matcher = parse(s)
  if not matcher:eof() then
    error("cannot reach eof at position " .. matcher.position)
  end
  return v
end

function class.selector(s)
  return selectors.compile(s)
end

element.super = class
node_list.super = class

return class
