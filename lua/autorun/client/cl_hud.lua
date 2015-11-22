
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
// MADE BY HABO - core-community.de //
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

-- CVAR
CreateConVar( 'Core_ShowAvatar', 1 )


-- FONTS
surface.CreateFont("HUDFont8", {
	font 	= "Arial",
	size	= 24,
	weight	= 300	
})
surface.CreateFont( "ammof", {
    font = "Trebuchet MS", 
    size = 30, 
    weight = 900
})

local name

local blur = Material( "pp/blurscreen" )
local function drawBlur( x, y, w, h, layers, density, alpha )
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, layers do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		render.SetScissorRect( x, y, x + w, y + h, true )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		render.SetScissorRect( 0, 0, 0, 0, false )
	end
end


local function CoreHud()
	local localplayer = LocalPlayer()
	local rank = (localplayer:GetUserGroup())
	local HP = localplayer:Health()
	if HP <= 0 then HP = 0 end
	local w2 = ScrW()/2 
	local leftwide = w2 - 300 
	local leftwidehalf = leftwide / 2
	
	local armormul = math.Clamp(localplayer:Armor(),0,100) / 100 
	local armorwide = armormul * (leftwidehalf - 30)

	drawBlur( 0, ScrH() - 32, ScrW(), 32, 3, 6, 255 )
	draw.RoundedBox(0, 0, ScrH() - 33.5, ScrW(), 1, Color(0, 0, 0,160), TEXT_ALIGN_LEFT)
	
	local hpcl = math.Clamp(HP,0,100) / 100
	local hpwide = hpcl * (leftwidehalf - 30)
	
	draw.RoundedBox(4, 18, ScrH() - 25.5,leftwidehalf - 29,20, Color(110, 110, 110,100))
	draw.RoundedBox(4, 18, ScrH() - 25.5,hpwide+1,20, Color( 200, 10, 10, 200 ))
	
	draw.SimpleText(localplayer:Health(), "HUDFont8", 17.5 + ((leftwidehalf - 30) / 2), ScrH() - 26, Color(255,255,255,255), TEXT_ALIGN_CENTER)
	draw.SimpleTextOutlined("rank: "..rank ,"HUDFont8", ScrW() * 0.75, ScrH() - 27, Color(255,255,255,255), TEXT_ALIGN_CENTER,0,1,Color( 0,0,0,60 ))
	draw.SimpleTextOutlined("Kills: "..localplayer:Frags(),"HUDFont8", ScrW() * 0.42, ScrH() - 27, Color(255,255,255,255), TEXT_ALIGN_CENTER,0,1,Color( 0,0,0,60 ))
	draw.SimpleTextOutlined("Deaths: "..localplayer:Deaths(),"HUDFont8", ScrW() * 0.57, ScrH() - 27, Color(255,255,255,255), TEXT_ALIGN_CENTER,0,1,Color( 0,0,0,60 ))
	//Armor Bar
	local armormul = math.Clamp(localplayer:Armor(),0,100) / 100 
	if localplayer:Armor() != 0 then
		draw.RoundedBox(4, leftwidehalf + 11, ScrH() - 25.5, leftwidehalf - 28, 20, Color(110, 110, 110,100))
		draw.RoundedBox(4,leftwidehalf + 11, ScrH() - 25.5, armorwide, 20, Color(0, 80, 255, 200 )) 
		draw.SimpleText(localplayer:Armor(), "HUDFont8", leftwidehalf + 10 + ((leftwidehalf - 30) / 2), ScrH() - 1 - 25, Color(255,255,255,255), TEXT_ALIGN_CENTER)
	end

	--
	local client = LocalPlayer()
	if !client:Alive() then return end
	if(client:GetActiveWeapon() == NULL or client:GetActiveWeapon() == "Camera") then return end

	local magleft = client:GetActiveWeapon():Clip1()
	local magextra = client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType())
	local secammo = client:GetAmmoCount(client:GetActiveWeapon():GetSecondaryAmmoType()) 


	if magleft > -1 then

		draw.SimpleTextOutlined( magleft,"ammof",ScrW() - 86,ScrH() - 31, Color( 230,230,230,255),TEXT_ALIGN_CENTER,0,1,Color( 0,0,0,60 ))-- THE TEXT WITHIN THE BOX
	end    
	if magextra > 0 then
		draw.SimpleTextOutlined( "/","ammof",ScrW() - 69.5,ScrH() - 31, Color( 230,230,230,220 ),0,0,0, Color( 0,0,0,60 ))-- THE TEXT WITHIN THE BOX
		draw.SimpleTextOutlined( magextra,"ammof",ScrW() - 38,ScrH() - 31, Color( 110,110,110,255 ),TEXT_ALIGN_CENTER,0,1,Color( 0,0,0,60 ))-- THE TEXT WITHIN THE BOX
	end

	
	
end
hook.Add("HUDPaint", "CoreHudPaint", CoreHud)


hook.Add("InitPostEntity", "DrawPlayerModel", function()
	local avatarsize = 175
	iconmodel = vgui.Create("DModelPanel")
	iconmodel:SetModel( LocalPlayer():GetModel())
	function iconmodel:LayoutEntity( Entity ) return end
	iconmodel:SetPos((ScrW()/2)-100, ScrH()-170)
	iconmodel:SetAnimated(false)
	iconmodel:SetSize(avatarsize,avatarsize)
	iconmodel:SetCamPos( Vector( 20, 0, 65))
	iconmodel:SetLookAt( Vector( 0, 0, 66.5 ) )
	
	timer.Create("RefreshAvatar", 0.1, 0, function()
		if GetConVarNumber( 'Core_ShowAvatar' ) == 1 and IsValid(iconmodel) then
			if LocalPlayer():GetModel() ~= iconmodel.Entity:GetModel() then
				iconmodel:Remove()		
				iconmodel = vgui.Create("DModelPanel")
				iconmodel:SetPos((ScrW()/2)-100, ScrH()-170)
				iconmodel:SetModel( LocalPlayer():GetModel())
				function iconmodel:LayoutEntity( Entity ) return end
				iconmodel:SetAnimated(false)
				iconmodel:SetSize(avatarsize,avatarsize)
				iconmodel:SetCamPos( Vector( 20, 0, 65))
				iconmodel:SetLookAt( Vector( 0, 0, 66.5 ) )
			end
		else
			if iconmodel then iconmodel:Remove() end
		end
	end)
		
		
end)

function disableCHUD(name)
	if name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" or name == "CHudSecondaryAmmo"  then 
		return false 
	end
end
hook.Add("HUDShouldDraw", "disablethisshit", disableCHUD)
