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

local json = require "dromozoa.commons.json"
local xml = require "dromozoa.xml"

local doc = xml.element("foo", {}, {
  "1";
  xml.element("bar", {}, { "2" });
  "3";
  "4";
  xml.element("bar", {}, { "5" });
  xml.element("bar", {}, { "6" });
  "7";
  "8";
  "9";
})
assert(xml.encode(doc) == [[<foo>1<bar>2</bar>3 4<bar>5</bar><bar>6</bar>7 8 9</foo>]])
assert(doc:text() == "13 47 8 9")

local doc = xml.decode(xml.encode(doc))
assert(xml.encode(doc) == [[<foo>1<bar>2</bar>3 4<bar>5</bar><bar>6</bar>7 8 9</foo>]])
assert(doc:text() == "13 47 8 9")
