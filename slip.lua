local bpm = 1.0
local previousIntervals = {bpm, bpm, bpm}

function intervalAverage()
  local sum = 0

  for i = 1, #previousIntervals do
      sum = sum + previousIntervals[i]
  end

  return sum / #previousIntervals
end

local lastClock = time()

input[1].change = function(volts)
    local interval = time() - lastClock
    lastClock = time()
    table.remove(previousIntervals, 1)
    table.insert(previousIntervals, interval)

    metro[1].time = intervalAverage() / 1000.0
    metro[2].time = metro[1].time * 1.1
end

local slipBeatCount = 0
local slipBeatTarget = 16
local slipNeedsResync = false

function straightBeat()
  output[1](pulse(0.01, 8)) -- note this syntax
  if (slipNeedsResync == true) then
    slipNeedsResync = false
    metro[2]:start()
  end
end

function slipBeat()
  if (slipNeedsResync == false) then
    output[2](pulse(0.01, 8))
    slipBeatCount = slipBeatCount + 1
    if (math.fmod(slipBeatCount, slipBeatTarget) == 0) then
      slipBeatCount = 0
      slipNeedsResync = true
      metro[2]:stop()
    end
  end
end

function init()
  input[1].mode("change", 1, 0.1, "rising")

  -- output[1].slew  = 0.01
  -- output[1].shape = "linear" -- 1.0.3 firmware only
  -- output[2].slew  = 0.01
  -- output[2].shape = "linear" -- 1.0.3 firmware only

  metro[1].event = straightBeat
  metro[1].time  = intervalAverage(previousIntervals)
  metro[1]:start()

  metro[2].event = slipBeat
  metro[2].time  = intervalAverage(previousIntervals) * 1.1
  metro[2]:start()
end