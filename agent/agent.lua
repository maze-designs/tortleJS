ver = "TortleJS dev0.1"
IP = "http://10.1.0.69:6969".."/api/v1/agent"
IP = "http://127.0.0.1:6969".."/api/v1/agent"

ID = tonumber(os.getComputerID())
registered = false
commandFailed = false


local function tern(bool, func1, func2)
      return (bool and func1 or func2)
    end

local  function split(str, sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  str:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

local function buildRequestString(action)
    local req = "ID="..ID
    req = req.."&ACTION="..action

    return req
end

local function register()
  print("Attempting to register on "..IP)
  local res = http.post(IP, buildRequestString("register"))
  if(res ~= nil) then
    registered = true
    term.clear()
    print(res.getResponseCode() .. ": " .. res.readAll())
   else
     print("Failed to register")
     os.sleep(1)
   end
end

local function handleRequest(action, body, verbose)
  verbose = verbose or true
  body = body or ""

req = buildRequestString(action)
req = req .. body
res = http.post(IP, req)

  if(res) then
    resText=res.readAll()
    print(res.getResponseCode()..": "..resText)
    return resText
  end
end

local function sendStatus()
  str = "&fuelLevel="..turtle.getFuelLevel()
  str = str.."&fuelLimit="..turtle.getFuelLimit()
  a, b = turtle.inspect()
  str = str.."&blockInFront="..tostring(tern(a,b.name,""))
  a, b = turtle.inspectUp()
  str = str.."&blockAbove="..tostring(tern(a,b.name,""))
  a, b = turtle.inspectDown()
  str = str.."&blockBelow="..tostring(tern(a,b.name,""))

  handleRequest("status", str)
end

  local function readStack()
    res = handleRequest("stack", "&commandFailed="..tostring(commandFailed))
    print("executing: "..res)

  fuck = {
    ["wait"] = function ()
    os.sleep(tonumber(split(res, " ")[2]))
  end,
    ["move"] = function ()
      commandFailed = not turtle[split(res, " ")[2]]()
    end
}
 fuck[split(res, " ")[1]]()
 sendStatus()
end

print("Turtle #"..ID.." on "..ver)
while (not registered) do
 register()
 end

while(true) do
readStack()
end
