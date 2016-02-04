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

local xml = require "dromozoa.xml"

local doc = xml.decode([=[
<root>
  <a><![CDATA[abc]]></a>
  <b>abc<![CDATA[def]]></b>
  <c><![CDATA[abc]]>def</c>
  <d><![CDATA[abc]]]]>&gt;def</d>
  <e><![CDATA[abc]]]]><![CDATA[>def]]></e>
  <f></f>
  <g><![CDATA[]]></g>
</root>
]=])

assert(doc:query("a"):text() == "abc")
assert(doc:query("b"):text() == "abcdef")
assert(doc:query("d"):text() == "abc]]>def")
assert(doc:query("e"):text() == "abc]]>def")
assert(doc:query("f"):count() == 0)
assert(doc:query("g"):count() == 0)
