-- https://monome.org/docs/crow/reference/
-- https://github.com/justmat/crow-tools/blob/master/adder.lua

-- a cv vca!

-- input 1 - cv to attenuate
-- input 2 - vca level
-- output 1 -- attenuated cv
-- output 2 -- max cv minus attenuated cv, keeping cv's sign (is this useful? ehh)

local level = 1.0
local maxVolts = 10.0

input[1].stream = function(volts)
  local attenuated = input[1].volts * level
  output[1].volts = attenuated
  output[2].volts = (maxVolts - math.abs(attenuated)) * (input[1].volts / math.abs(input[1].volts))
end

input[2].stream = function(volts)
  local absVolts = math.abs(volts)
  level = math.min(maxVolts, absVolts) / maxVolts
end

function init()
  input[1].mode("stream", 0.01) -- 100Hz fastest stable
  input[2].mode("stream", 0.01) -- 100Hz fastest stable
  output[1].slew  = 0.01
  output[1].shape = "linear" -- 1.0.3 firmware only
  output[2].slew  = 0.01
  output[2].shape = "linear" -- 1.0.3 firmware only
end