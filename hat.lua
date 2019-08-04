if f99 == nil then f99 = {} end
f99.hatscript = {hook = {}, hat = {}, nhat = {}}

f99.hatscript.hats = {
	--[[
	[1] = {name = "Hat 1", imagepath = "gfx/weiwen/farmour.png"};
	[2] = {name = "Hat 2", imagepath = "gfx/vegas/cap.png"};
	[3] = {name = "Hat 3", imagepath = "gfx/weiwen/farmour.png"};
	]]
}

f99.hatscript.hats[#f99.hatscript.hats + 1] = {name = "Remove hat", imagepath = "", terminate = true}

function f99.hatscript.selectmenu(id, page)
	local page = page or 1
	local pages = math.ceil(#f99.hatscript.hats / 6)
	if page < 1 then page = pages end
	if page > pages then page = 1 end
	local m = 'Select a hat P'.. page
	for i = 6 * page - 5, 6 * page do
		if f99.hatscript.hats[i] then m = m ..', '.. f99.hatscript.hats[i].name else m = m ..',' end
	end
	if page == pages then m = m ..',,<<- First page' else m = m ..',,Next page -->' end
	if page == 1 then m = m ..',Last page ->>' else m = m ..',<-- Previvius page' end
	menu(id, m)
end

addhook('serveraction', 'f99.hatscript.hook.serveraction')
function f99.hatscript.hook.serveraction(id, action)
	if action == 1 then
		f99.hatscript.selectmenu(id, 1)
	end
end

addhook('menu', 'f99.hatscript.hook.menu')
function f99.hatscript.hook.menu(id, title, button)
	if title:sub(1, 14) == 'Select a hat P' then
		local page = tonumber(title:sub(15))
		if button == 8 then f99.hatscript.selectmenu(id, page + 1) end
		if button == 9 then f99.hatscript.selectmenu(id, page - 1) end
		if button <= 6 then
			if f99.hatscript.hats[(page - 1) * 6 + button].terminate then
				if f99.hatscript.hat[id] then
					freeimage(f99.hatscript.hat[id])
					f99.hatscript.nhat[id] = false
					f99.hatscript.hat[id] = false
				end
			else
				if f99.hatscript.hat[id] then
					freeimage(f99.hatscript.hat[id])
				end
				f99.hatscript.hat[id] = image(f99.hatscript.hats[(page - 1) * 6 + button].imagepath, 1, 0, 200 + id)
				f99.hatscript.nhat[id] = f99.hatscript.hats[(page - 1) * 6 + button].imagepath
			end
		end
	end
end

addhook('join', 'f99.hatscript.hook.join')
function f99.hatscript.hook.join(id)
	f99.hatscript.hat[id] = false
	f99.hatscript.nhat[id] = false
end

addhook('startround', 'f99.hatscript.hook.startround')
function f99.hatscript.hook.startround(mode)
	for n, id in pairs(player(0, 'tableliving')) do
		if f99.hatscript.nhat[id] then
			f99.hatscript.hat[id] = image(f99.hatscript.nhat[id], 1, 0, 200 + id)
		end
	end
end