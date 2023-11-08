
local myname, ns = ...


local function IsKnown(link)
	if not ns.scantip:IsOwned(WorldFrame) then
		ns.scantip:SetOwner(WorldFrame)
	end
	ns.scantip:SetHyperlink(link)
	local tipName = ns.scantip:GetName()
	for i=1,ns.scantip:NumLines() do
		local fs = _G[tipName.."TextLeft"..i]
		if fs then
			if fs:GetText() == _G.ITEM_SPELL_KNOWN then
				ns.scantip:Hide()
				return true
			end
		end
	end
	ns.scantip:Hide()
end


ns.knowns = setmetatable({}, {
	__index = function(t, i)
		local id = ns.ids[i]
		if not id then return end

		if IsKnown(i) then
			t[i] = true
			return true
		end
	end
})


-- "Requires Previous Rank"
local PREV_RANK = TOOLTIP_SUPERCEDING_SPELL_NOT_KNOWN
local function NeedsRank(link)
	if not ns.scantip:IsOwned(WorldFrame) then
		ns.scantip:SetOwner(WorldFrame)
	end
	ns.scantip:SetHyperlink(link)
	local tipName = ns.scantip:GetName()
	for i=1,ns.scantip:NumLines() do
		local fs = _G[tipName.."TextLeft"..i]
		if fs:GetText() == PREV_RANK then
			ns.scantip:Hide()
			return true
		end
	end
	ns.scantip:Hide()
end


ns.unmet_requirements = setmetatable({}, {
	__index = function(t, i)
		local id = ns.ids[i]
		if not id then return end

		if NeedsRank(i) then
			t[i] = true
			return true
		end
	end
})
