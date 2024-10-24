-- physical
-- norns study 4
--
-- grid controls arpeggio
-- midi (cc) controls root note
-- ENC2 = bpm
-- ENC3 = scale
-- 
-- leon additions:
-- K* = stop/play sequencer

engine.name = 'PolyPerc'

music = require 'musicutil'

steps = {}
position = 1
transpose = 0

mode = math.random(#music.SCALES)
scale = music.generate_scale_of_length(60,music.SCALES[mode].name,8)

function init()
  for i=1,16 do
    table.insert(steps,math.random(8))
  end
  grid_redraw()
  counter = clock.run(count)
  counting = true
end

function enc(n,d)
  if n == 1 then
    params:delta("clock_source",d)
  elseif n == 2 then
    params:delta("clock_tempo",d)
  elseif n == 3 then
    mode = util.wrap(mode + d, 1, #music.SCALES)
    scale = music.generate_scale_of_length(60,music.SCALES[mode].name,8)
  end
  redraw()
end

function key(n, z)
  if z == 1 then
    if counting then
      clock.cancel(counter)
      counting = false
    else
      counter = clock.run(count)
      counting = true
    end
  end
end


function redraw()
  screen.clear()
  screen.level(10)
  -- screen.font_face(3)
  -- screen.font_size(12)
  screen.move(0,23)
  screen.text("clock source: "..params:string("clock_source"))
  screen.move(0,33)
  screen.text("bpm: "..params:get("clock_tempo"))
  screen.move(0,43)
  screen.text(music.SCALES[mode].name)
  screen.update()
end

g = grid.connect()

g.key = function(x,y,z)
  if z == 1 then
    steps[x] = 9-y
    grid_redraw()
  end
end

function grid_redraw()
  g:all(0)
  for i=1,16 do
    g:led(i,9-steps[i],i==position and 15 or 4)
  end
  g:refresh()
end

function count()
  while true do
    clock.sync(1/4)
    position = (position % 16) + 1
    engine.hz(music.note_num_to_freq(scale[steps[position]] + transpose))
    grid_redraw()
    redraw() -- for bpm changes on LINK, MIDI, or crow
  end
end

m = midi.connect()
m.event = function(data)
  local d = midi.to_msg(data)
  if d.type == "cc" then
    tab.print(d)
    transpose = util.wrap(d.val, 0, 12)
  end
end
