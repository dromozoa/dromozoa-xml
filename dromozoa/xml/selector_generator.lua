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

local split = require "dromozoa.commons.split"
local element = require "dromozoa.xml.element"

local name = element.name
local attr = element.attr

local class = {
  [","] = function (_, a, b)
    return function (...)
      return a(...) or b(...)
    end
  end;

  [" "] = function (_, a, b)
    return function (top, stack, n)
      if n > 1 and b(top, stack, n) then
        for i = n - 1, 1, -1 do
          if a(stack[i], stack, i) then
            return true
          end
        end
      end
    end
  end;

  [">"] = function (_, a, b)
    return function (top, stack, n)
      if n > 1 and b(top, stack, n) then
        local i = n - 1
        if a(stack[i], stack, i) then
          return true
        end
      end
    end
  end;

  [""] = function (_, a, b)
    return function (...)
      return a(...) and b(...)
    end
  end;

  ["name"] = function (_, a)
    return function (top)
      return name(top) == a
    end
  end;

  ["*"] = function ()
    return function ()
      return true
    end
  end;

  ["attr"] = function (_, a)
    return function (top)
      return attr(top, a) ~= nil
    end
  end;

  ["="] = function (_, a, b)
    return function (top)
      return attr(top, a) == b
    end
  end;

  ["~="] = function (_, a, b)
    if b:match("^[ \t\r\n\f]*$") then
      return function () end
    else
      return function (top)
        local u = attr(top, a)
        if u ~= nil then
          for v in split(u, "[ \t\r\n\f]+"):each() do
            if v == b then
              return true
            end
          end
        end
      end
    end
  end;

  ["|="] = function (_, a, b)
    local c = "^" .. b:gsub("[^%a]", "%%%1") .. "%-?"
    return function (top)
      local u = attr(top, a)
      return u ~= nil and u:find(c)
    end
  end;

  ["^="] = function (_, a, b)
    if b == "" then
      return function () end
    else
      local c = "^" .. b:gsub("[^%a]", "%%%1")
      return function (top)
        local u = attr(top, a)
        return u ~= nil and u:find(c)
      end
    end
  end;

  ["$="] = function (_, a, b)
    if b == "" then
      return function () end
    else
      local c = b:gsub("[^%a]", "%%%1") .. "$"
      return function (top)
        local u = attr(top, a)
        return u ~= nil and u:find(c)
      end
    end
  end;

  ["*="] = function (_, a, b)
    if b == "" then
      return function () end
    else
      return function (top)
        local u = attr(top, a)
        return u ~= nil and u:find(b, 1, true)
      end
    end
  end;

  ["not"] = function (_, a)
    return function (...)
      return not a(...)
    end
  end;
}

function class.new()
  return {}
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
