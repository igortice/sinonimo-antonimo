---------------------------------------------------------------------------------
--
-- String to Array
--
---------------------------------------------------------------------------------
function to_array( str )
  local t = {}
  for i = 1, #str do
      t[i] = str:sub(i, i)
  end

  return t
end

function split(str, pat)
  local t = {}
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
   table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t,cap)
   end
   return t
end

---------------------------------------------------------------------------------
--
-- All Index Of Table
--
---------------------------------------------------------------------------------
function allIndexOf( t, item )
  local r = {}
  for i=1,#t do
    if (t[i] == item) then
      r[#r+1] = i
    end
  end

  return r
end

---------------------------------------------------------------------------------
--
-- Shuffle Table
--
---------------------------------------------------------------------------------
math.randomseed( os.time() )

function shuffleTable( t )
    local rand = math.random
    local iterations = #t
    local j

    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end

    return t
end