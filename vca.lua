-- https://monome.org/docs/crow/reference/
-- https://github.com/justmat/crow-tools/blob/master/adder.lua

-- input 1 - cv to attenuate
-- input 2 - vca level

local level = 1.0
local maxVolts = 5.0

input[1].stream = function(volts)
  output[1].volts = input[1].volts * level
end

input[2].stream = function(volts)
  local absVolts = math.abs(volts)
  level = math.min(maxVolts, abs_volts) / maxVolts
end

function init()
  input[1].mode('stream', 0.01) -- 100Hz fastest stable
  input[2].mode('stream', 0.01) -- 100Hz fastest stable
  output[1].slew  = 0.01
  output[1].shape = 'expo' -- 1.0.3 firmware only
end