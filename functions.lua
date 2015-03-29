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