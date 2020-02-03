-- https://monome.org/docs/crow/reference/

local notes = { 4.8, 4.0, 4.1, 4.4, 4.8, 5.0, 5.1, 5.4, 5.8, 6.0, 6.1, 6.4, 6.8, 7.0, 7.1, 7.4, 7.8, 7.4, 7.1, 7.0, 6.8, 6.4, 6.1, 6.0, 5.8, 5.4, 5.1, 5.0, 4.8, 4.4, 4.1, 4.0, 4.5, 4.7, 4.8, 4.1, 4.5, 4.7, 4.8, 5.1, 5.5, 5.7, 5.8, 6.1, 6.5, 6.7, 6.8, 7.1, 7.5, 7.1 }

-- note: can't currently load whole 256-note table for some reason...

local noteIndex = 1

function init()
  print("woo")
  input[1].mode("change", 1, 0.1, "rising")
end

input[1].change = function(state)
  noteIndex = noteIndex + 1

  if (noteIndex >= #notes) then
    noteIndex = 1
  end

  output[1].volts = notes[noteIndex] - 2.0
end