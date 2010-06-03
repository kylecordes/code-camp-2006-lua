
map = { Channel0 = "Left" , Channel1 = "Right" }

function slider_moved(slider, pos)
	-- 0 .. 234
	-- 0 .. -72
	
	send_packet(map[slider] .. ': ' .. math.floor(pos * (- 72 / 234)))
end



set_label('Label0', map['Channel0'])




