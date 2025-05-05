
local myname, ns = ...

local GetItemInfo = function(...)
	if _G.GetItemInfo then
		return _G.GetItemInfo(...)
	elseif C_Item and C_Item.GetItemInfo then
		return C_Item.GetItemInfo(...)
	end
end

local GetItemQualityColor = function(...)
	if _G.GetItemQualityColor then
		return _G.GetItemQualityColor(...)
	elseif C_Item and C_Item.GetItemQualityColor then
		return C_Item.GetItemQualityColor(...)
	end
end

local function Knowable(link)
	local id = ns.ids[link]
	if not id then return false end

	local itemclass, itemsubclass = select(12,GetItemInfo(link))
	if itemclass == LE_ITEM_CLASS_MISCELLANEOUS 
		and (itemsubclass == LE_ITEM_MISCELLANEOUS_COMPANION_PET or itemsubclass == LE_ITEM_MISCELLANEOUS_MOUNT)
		then
			return true
	end
	if itemclass == LE_ITEM_CLASS_RECIPE then return true end
end


local function RecipeNeedsRank(link)
	local itemclass = (select(12,GetItemInfo(link)))
	if itemclass ~= LE_ITEM_CLASS_RECIPE then return end
	return ns.unmet_requirements[link]
end


local DEFAULT_GRAD = {0,1,0,0.75, 0,1,0,0} -- green
local GRADS = {
	red = {1,0,0,0.75, 1,0,0,0},
	[1] = {1,1,1,0.75, 1,1,1,0}, -- white
	[2] = DEFAULT_GRAD, -- green
	[3] = {0.5,0.5,1,1, 0,0,1,0}, -- blue
	[4] = {1,0,1,0.75, 1,0,1,0}, -- purple
}
GRADS = setmetatable(GRADS, {
	__index = function(t,i)
		t[i] = DEFAULT_GRAD
		return DEFAULT_GRAD
	end
})


function ns.GetRowGradient(index)
	local gradient = DEFAULT_GRAD
	local shown = false
	-- name, texture, price, stackCount, numAvailable, isPurchasable, isUsable, extendedCost, currencyID
	local _, _, _, _, _, _, isUsable = GetMerchantItemInfo(index)
	if not isUsable then
		gradient = GRADS.red
		shown = true
	end

	local link = GetMerchantItemLink(index)
	if not (link and Knowable(link)) then return gradient, shown end

	if ns.knowns[link] then
		return gradient, false
	elseif RecipeNeedsRank(link) then
		return GRADS.red, true
	else
		local _, _, quality = GetItemInfo(link)
		return GRADS[quality], true
	end
end


local QUALITY_COLORS = setmetatable({}, {
	__index = function(t,i)
		-- GetItemQualityColor only takes numbers, so fall back to white
		local _, _, _, hex = GetItemQualityColor(tonumber(i) or 1)
		t[i] = "|c".. hex
		return "|c".. hex
	end
})


function ns.GetRowTextColor(index)
	local link = GetMerchantItemLink(index)
	if not link then return QUALITY_COLORS.default end

	-- Grey out if already known
	if Knowable(link) and ns.knowns[link] then return QUALITY_COLORS[0] end

	local _, _, quality = GetItemInfo(link)
	return QUALITY_COLORS[quality or 1]
end


function ns.GetRowVertexColor(index)
	local _, _, _, _, _, _, isUsable = GetMerchantItemInfo(index)
	if isUsable then return 1.0, 1.0, 1.0
	else             return 0.9, 0.0, 0.0
	end
end
