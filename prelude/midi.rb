require "rubygems"
require "midilib"
require "midilib/io/seqreader"

def midi_to_cv(midi)
  cv = midi.to_i * (1.0/12.0)
  return cv.truncate(1).to_s
end

seq = MIDI::Sequence.new()

lua_string = "local notes = {"

File.open("prelude.mid", "rb") do | file |

    seq.read(file) do | track, num_tracks, i |
      if i != 2
        next
      end

      track.events.each.with_index do |event, index|
        if event.is_a? MIDI::NoteOn then
          lua_string += midi_to_cv(event.note) + ", "
        end
      end

    end
end

lua_string.delete_suffix!(", ")
lua_string += "}"

outfile = File.open("prelude_table_for_lua.lua", "w")
outfile.puts lua_string
outfile.close

puts "Done!"