local user = { "user1", "user2", "user3" }
 
local red = component.proxy(component.list("redstone")())
local scr = {}
local gpu = {}
 
for a in component.list("screen") do table.insert(scr, a) end
for a in component.list("gpu") do table.insert(gpu, component.proxy(a)) end
for i = 1, #gpu do gpu[i].bind(scr[i]) end
 
function showState(s)
  for i, g in ipairs(gpu) do
    g.setResolution(40, 20)
    g.fill(1, 1, 40, 20, " ")
    if s then
      g.setForeground(0x00FF00)
      g.set(16, 10, "Access denied")
    else
      g.setForeground(0xFF0000)
      g.set(16, 10, "Access granted")
    end
  end
end
 
function sleep(x)
  local tgt = computer.uptime() + x
  while computer.uptime() < tgt do
    computer.pullSignal(tgt - computer.uptime())
  end
end
 
while true do
  showState(false)
  local type, _, x, y, btn, nick = computer.pullSignal(5)
  if type == "touch" then
    nick = nick:lower()
    for i, v in ipairs(user) do
      if v == nick then
        showState(true)
        red.setOutput(1, 255)
        sleep(2)
        red.setOutput(1, 0)
      end
    end
  end
end
