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
function allIndexOf( table, item )
  result = {}
  for i=1,#table do
    if (table[i] == item) then
      result[#result+1] = i
    end
  end

  return result
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