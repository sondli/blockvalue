SLASH_BV1 = "/bv"

local scanTooltip = CreateFrame("GameTooltip", "bvToolTip", nil, "GameTooltipTemplate")
scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

local function clear_tooltip()
	for i = 1, 20 do
		if _G["bvToolTipTextLeft" .. i] then
			_G["bvToolTipTextLeft" .. i]:SetText("")
		end
		if _G["bvToolTipTextRight" .. i] then
			_G["bvToolTipTextRight" .. i]:SetText("")
		end
	end
end

local function startsWith(str, start)
	return string.sub(str, 1, string.len(start)) == start
end

local function get_base_blockvalue(tooltip)
	clear_tooltip()

	if tooltip:SetInventoryItem("player", 17) == nil then
		return 0
	end

	for i = 1, tooltip:NumLines() do
		if _G["bvToolTipTextRight" .. i]:GetText() == "Shield" then
			local bvLine = _G["bvToolTipTextLeft" .. i + 2]:GetText()
			local bvString = string.sub(bvLine, 1, -6)
			local bvBase = tonumber(bvString)
			if bvBase == nil then
				DEFAULT_CHAT_FRAME:AddMessage("NIL")
				return 0
			end
			return bvBase
		end
	end

	return 0
end

local function get_gear_blockvalue(tooltip)
	local bvGear = 0
	for i = 1, 18 do
		clear_tooltip()
		if tooltip:SetInventoryItem("player", i) then
			for j = 1, tooltip:NumLines() do
				local line = _G["bvToolTipTextLeft" .. j]:GetText()
				if line ~= nil and startsWith(line, "Equip: Increases the block value of your shield by ") then
					local bv = string.sub(line, 52, string.len(line) - 1)
					bvGear = bvGear + bv
				end
			end
		end
	end
	return bvGear
end

SlashCmdList["BV"] = function()
	local bvTotal = 0
	local bvBase = get_base_blockvalue(scanTooltip)
	local bvGear = get_gear_blockvalue(scanTooltip)
	bvTotal = bvTotal + bvBase + bvGear

	DEFAULT_CHAT_FRAME:AddMessage("Total Block Value: " .. bvTotal)
	DEFAULT_CHAT_FRAME:AddMessage("Base shield block value: " .. bvBase)
	DEFAULT_CHAT_FRAME:AddMessage("Gear shield block value: " .. bvGear)
end

