--[[
	Filesystem
	explorer
	by Creator
]]--
local args = {...}

local filesystem = {}

local function readFile(path)
	local file = fs.open(path,"r")
	local variable = file.readAll()
	file.close()
	return variable
end

local function explore(dir)
	local buffer = {}
	local sBuffer = fs.list(dir)
	for i,v in pairs(sBuffer) do
		sleep(0.05)
		if fs.isDir(dir.."/"..v) then
			if v ~= ".git" then
				buffer[v] = explore(dir.."/"..v)
			end
		else
			buffer[v] = readFile(dir.."/"..v)
		end
	end
	return buffer
end

append = [[
local function writeFile(path,content)
	local file = fs.open(path,"w")
	file.write(content)
	file.close()
end
function writeDown(input,dir)
		for i,v in pairs(input) do
		if type(v) == "table" then
			writeDown(v,dir.."/"..i)
		elseif type(v) == "string" then
			writeFile(dir.."/"..i,v)
		end
	end
end

args = {...}
if #args == 0 then
	print("Please input a destination folder.")
else
	writeDown(inputTable,args[1])
end

]]

local filesystem = explore(args[1])
local file = fs.open(args[2],"w")
file.write("inputTable = "..textutils.serialize(filesystem).."\n\n\n\n\n\n\n\n\n"..append)
file.close()

