
local myname, ns = ...


local NUMROWS, SCROLLSTEP = 14, 5


local function Hide(frame)
	frame:Hide()
	frame.Show = frame.Hide
end


local function ToggleButtons()
	for i=1,MERCHANT_ITEMS_PER_PAGE do
		if (MerchantFrame.selectedTab == 1) then
			_G["MerchantItem"..i]:Hide()
		elseif (MerchantFrame.selectedTab == 2) then
			_G["MerchantItem"..i]:Show()
		end
	end
end


function ns.OnLoad()
	local GVS = ns.NewMainFrame()
	GVS:SetWidth(315)
	GVS:SetHeight(294)
	GVS:SetPoint("TOPLEFT", MerchantFrame, 8, -67)

	-- Reanchor the buyback button, it acts weird when switching tabs otherwise...
	MerchantBuyBackItem:ClearAllPoints()
	MerchantBuyBackItem:SetPoint("BOTTOMRIGHT", -7, 33)

	-- The little class select dropdown show trigget a refresh
	--[[hooksecurefunc("SetMerchantFilter", function()
		if GVS.Merchant ~= UnitGUID("npc") then
			GVS:GetScript("OnShow")(GVS)
		else
			GVS:GetScript("OnEvent")(GVS)
		end
	end)]]
	
	-- Force show when we're loaded on demand and the tab is already selected
	if MerchantFrame:IsVisible() and MerchantFrame.selectedTab == 1 then
		GVS:Show()
	end

	-- Reparent the first 10 MerchantItem frames, so they only appear for buyback
	for i=1,10 do _G["MerchantItem"..i]:Hide() end

	-- Hide frames we don't need now
	Hide(MerchantNextPageButton)
	Hide(MerchantPrevPageButton)
	Hide(MerchantPageText)

	-- Clean up our frame factories
	for i,v in pairs(ns) do if i:match("^New") then ns[i] = nil end end

	MerchantFrameTab1:HookScript("OnClick", ToggleButtons)
	MerchantFrameTab2:HookScript("OnClick", ToggleButtons)
	GVS:HookScript("OnShow", ToggleButtons)
end
