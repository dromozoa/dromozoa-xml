-- Copyright (C) 2020 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local xml = require "dromozoa.xml"
local json = require "dromozoa.commons.json"

local handle = assert(io.open "test/test.svg")
local content = handle:read "*a"
handle:close()

local svg = xml.decode(content)
local node = svg:query "#g2281 > path"
assert(node:attr "d":find "^m 72,55%.207 h 6")

