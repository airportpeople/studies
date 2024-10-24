-- study 3
-- code exercise
-- tangle and detangle

engine.name = 'PolyPerc'

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

function happy()
  engine.hz(midi_to_hz(60))
  engine.hz(midi_to_hz(64))
  engine.hz(midi_to_hz(67))
end

function sad()
  engine.hz(midi_to_hz(60))
  engine.hz(midi_to_hz(63))
  engine.hz(midi_to_hz(67))
end

function key(n,z)
  if z == 1 then
    go = happy
  else
    go = sad
  end
  go()
end