-- study 1: many tomorrows
-- 
-- K1 (hold) - turn off
-- K2 - increase freq by 50Hz
-- K3 - increase freq by 100Hz
-- E2 - adjust amplitude

engine.name = "TestSine"

function init()
  amp_ = 0.5
  
  engine.hz(100)
  engine.amp(amp_)
  print('hello. these are words')
end


function key(n, z)
  print("key " .. n .. " == " .. z)
  
  -- turn it off; K1 is weird, you need to hold it!
  if n == 1 then
    engine.amp(0)
  end
  
  -- adjust frequency
  if n == 2 then
    engine.hz(100 + 50 * z)
  end
  
  if n == 3 then
    engine.hz(100 + 100 * z)
  end
  
end


function enc(n, d)
  
  -- adjust amplitude without clipping
  if n == 2 then
    amp_ = util.clamp(amp_ + d/10, 0, 1)
    engine.amp(amp_)
    print("amp == " .. amp_)
  end
end
