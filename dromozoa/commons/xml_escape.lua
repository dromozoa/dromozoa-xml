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

local set = require "dromozoa.commons.set"

local function get_named_char_refs()
  return {
    [string.char(0x26)] = "&amp;";
    [string.char(0x3c)] = "&lt;";
    [string.char(0x3e)] = "&gt;";
    [string.char(0x22)] = "&quot;";
    [string.char(0x27)] = "&apos;";
  }
end

local function get_numeric_char_refs(i, j)
  local refs = {}
  for i = i, j do
    refs[string.char(i)] = string.format("&#x%x;", i)
  end
  return refs
end

local char_refs = set.set_union(get_named_char_refs(), get_numeric_char_refs(0, 127))

return function (value, pattern)
  if pattern == nil then
    pattern = "[%z\1-\8\11\12\14-\31\127%&%<%>%\"%']"
  end
  return (tostring(value):gsub(pattern, char_refs))
end
