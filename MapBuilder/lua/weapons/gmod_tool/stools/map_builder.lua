TOOL.Category = "Marums tools"
TOOL.Name = "Map Builder"
TOOL.Command = nil
TOOL.ConfigName = "" --Setting this means that you do not have to create external configuration files to define the layout of the tool config-hud 

TOOL.ClientConVar[ "model" ] = "1"
TOOL.ClientConVar[ "material" ] = "blocks/hunter/blocks/cube4x4x1.mdl"
TOOL.ClientConVar[ "color_r" ] = "255"
TOOL.ClientConVar[ "color_g" ] = "255"
TOOL.ClientConVar[ "color_b" ] = "255"
TOOL.ClientConVar[ "color_a" ] = "255"
TOOL.ClientConVar[ "overlap" ] = "false"
TOOL.ClientConVar[ "dynamic_normal" ] = "false"
TOOL.ClientConVar[ "action" ] = "1"
TOOL.ClientConVar[ "auto_use" ] = "false"
TOOL.ClientConVar[ "auto_nudge" ] = "true"
--TOOL.ClientConVar[ "weld" ] = "true"
TOOL.ClientConVar[ "replace" ] = "false"
TOOL.ClientConVar[ "symmetry" ] = "0"

TOOL.ClientConVar[ "hud_size" ] = "1"
local originProp = nil
local ghostProp = nil
local originPos = Vector(0,0,0)
local originAng = Angle(0,0,0)
local selectionNormal = Vector(0,0,1)
local nextSelection = Vector(0,0,1)
--local snap = Vector(189.75,189.75,47.45)
--local baseSnap = Vector(189.75,189.75,189.75)
local snap = Vector(189.75,189.75,189.75)

local selectionPos = Vector(0,0,0)
local selectionEnd = Vector(0,0,0)

local mousex = 0
local mousey = 0

local LMB_down = false
local LMB_hold = false
local E_down = false
local E_hold = false

local MOUSE_cooldown = CurTime()

local contextMenu = false
--local pl.popupMenu = nil
local csModels = {}
local lastselectedBlock = 0

local BlockClass = {}
BlockClass.name = "Unnamed Block"
BlockClass.canBeOrigin = false
BlockClass.models = {}
BlockClass.offset = Vector(0,0,0)
BlockClass.angle = Angle(0,0,0)
BlockClass.size = Vector(1,1,1)

local ModelClass = {}
ModelClass.model = "blocks/hunter/blocks/cube4x4x1.mdl"
ModelClass.offset = Vector(0,0,0)
ModelClass.angle = Angle(0,0,0)
ModelClass.dimensions = snap

function MM_Block()
	local newBlock = table.Copy( BlockClass )
	return newBlock
end

function MM_Model()
	local newModel = table.Copy( ModelClass )
	return newModel
end

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

local blockCount = 14
local blocks = {}
local u = 1
for i=1, blockCount do
	blocks[i] = MM_Block()
end

------------------------------------- BLOCK
blocks[u].name = "1/4 Block"
blocks[u].canBeOrigin = true

local models = {}
models[1] = MM_Model()
models[1].model = "models/hunter/blocks/cube4x4x1.mdl"
models[1].offset = Vector(0,0,-snap.z*3/8)
models[1].angle = Angle(0,0,0)

blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------- BLOCK
blocks[u].name = "1/2 Block"
blocks[u].canBeOrigin = true

local models = {}
models[1] = MM_Model()
models[1].model = "models/hunter/blocks/cube4x4x2.mdl"
models[1].offset = Vector(0,0,-snap.z/4)
models[1].angle = Angle(0,0,0)

blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------- BLOCK
blocks[u].name = "3/4 Block"

local models = {}
models[1] = MM_Model()
models[1].model = "models/hunter/blocks/cube4x4x2.mdl"
models[1].offset = Vector(0,0,-snap.z/4)
models[1].angle = Angle(0,0,0)
models[2] = MM_Model()
models[2].model = "models/hunter/blocks/cube4x4x1.mdl"
models[2].offset = Vector(0,0,snap.z/8)
models[2].angle = Angle(0,0,0)

blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------- BLOCK
blocks[u].name = "Full Block"
blocks[u].canBeOrigin = true

local models = {}
models[1] = MM_Model()
models[1].model = "models/hunter/blocks/cube4x4x4.mdl"
models[1].offset = Vector(0,0,0)
models[1].angle = Angle(0,0,0)

blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------- BLOCK
blocks[u].name = "Floor"
blocks[u].canBeOrigin = true

local models = {}
models[1] = MM_Model()
models[1].model = "models/hunter/plates/plate4x4.mdl"
models[1].offset = Vector(0,0,-snap.z/2)
models[1].angle = Angle(0,0,0)

blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------- BLOCK
blocks[u].name = "Glass Floor"
blocks[u].canBeOrigin = true

local models = {}
models[1] = MM_Model()
models[1].model = "models/props_phx/construct/windows/window4x4.mdl"
models[1].offset = Vector(snap.x*3/8,-snap.y*3/8,-snap.z/2)
models[1].angle = Angle(0,0,0)

blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------- BLOCK
blocks[u].name = "Wall"

local models = {}
models[1] = MM_Model()
models[1].model = "models/hunter/plates/plate4x4.mdl"
models[1].offset = Vector(0,0,snap.z/2)
models[1].angle = Angle(90,0,0)

blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------- BLOCK
blocks[u].name = "Door Way"

local models = {}
models[1] = MM_Model()
models[1].model = "models/hunter/plates/plate1x4.mdl"
models[1].offset = Vector(-snap.x*3/8,0,snap.z/2)
models[1].angle = Angle(0,90,90)
models[2] = MM_Model()
models[2].model = "models/hunter/plates/plate2x2.mdl"
models[2].offset = Vector(-snap.x/4,0,snap.z/2)
models[2].angle = Angle(90,0,0)
models[3] = MM_Model()
models[3].model = "models/hunter/plates/plate1x4.mdl"
models[3].offset = Vector(snap.x*3/8,0,snap.z/2)
models[3].angle = Angle(0,90,90)

blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------- BLOCK
blocks[u].name = "Cover"

local models = {}
models[1] = MM_Model()
models[1].model = "models/hunter/plates/plate1x4.mdl"
models[1].offset = Vector(snap.x*3/8,0,snap.z/2)
models[1].angle = Angle(90,0,0)

blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------- BLOCK
blocks[u].name = "Window A"

local models = {}
models[1] = MM_Model()
models[1].model = "models/hunter/plates/plate1x4.mdl"
models[1].offset = Vector(snap.x*3/8,0,snap.z/2)
models[1].angle = Angle(90,0,0)
models[2] = MM_Model()
models[2].model = "models/props_phx/construct/windows/window1x2.mdl"
models[2].offset = Vector(snap.x/8,-snap.y*3/8,snap.z/2-1.75)
models[2].angle = Angle(90,0,0)
models[3] = MM_Model()
models[3].model = "models/props_phx/construct/windows/window1x2.mdl"
models[3].offset = Vector(snap.x/8,snap.y*1/8,snap.z/2-1.75)
models[3].angle = Angle(90,0,0)
models[4] = MM_Model()
models[4].model = "models/hunter/plates/plate2x4.mdl"
models[4].offset = Vector(-snap.x/4,0,snap.z/2)
models[4].angle = Angle(90,0,0)

blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------- BLOCK
blocks[u].name = "Window b"

local models = {}
models[1] = MM_Model()
models[1].model = "models/hunter/plates/plate1x4.mdl"
models[1].offset = Vector(snap.x*3/8,0,snap.z/2)
models[1].angle = Angle(90,0,0)
models[2] = MM_Model()
models[2].model = "models/props_phx/construct/windows/window1x2.mdl"
models[2].offset = Vector(snap.x/8,-snap.y*3/8,snap.z/2-1.75)
models[2].angle = Angle(90,0,0)
models[3] = MM_Model()
models[3].model = "models/props_phx/construct/windows/window1x2.mdl"
models[3].offset = Vector(snap.x/8,snap.y*1/8,snap.z/2-1.75)
models[3].angle = Angle(90,0,0)
blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------- BLOCK
blocks[u].name = "Window c"

local models = {}
models[1] = MM_Model()
models[1].model = "models/props_phx/construct/windows/window4x4.mdl"
models[1].offset = Vector(snap.x*3/8,-snap.y*3/8,snap.z/2)
models[1].angle = Angle(90,0,0)

blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------- BLOCK
blocks[u].name = "1/4 Ramp"

local models = {}
models[1] = MM_Model()
models[1].model = "models/hunter/plates/plate4x4.mdl"
models[1].offset = Vector(-14.4,0,-snap.z*3/8+0.65)
models[1].angle = Angle(-14.036,0,0)
models[2] = MM_Model()
models[2].model = "models/hunter/plates/plate025x4.mdl"
models[2].offset = Vector(-109.4,0,-snap.z*3/8+0.651)
models[2].angle = Angle(-14.036,0,0)
blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------- BLOCK
blocks[u].name = "1/2 Ramp"

local models = {}
models[1] = MM_Model()
models[1].model = "models/hunter/plates/plate4x4.mdl"
models[1].offset = Vector(-10.09,0,-snap.z/4+3.532)
models[1].angle = Angle(-26.565,0,0)
models[2] = MM_Model()
models[2].model = "models/hunter/plates/plate05x4.mdl"
models[2].offset = Vector(-115.7,0,-snap.z/4+3.532)
models[2].angle = Angle(-26.565,0,0)
blocks[u].models = models
u = u+1
---------------------------------------------

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
function TOOL:Deploy()
	self:SetStage(0)
	local trace = self:GetOwner():GetEyeTrace()
	self:UpdateGhostEntity (cvars.String("map_builder_model"), trace.HitPos, Angle(0,0,0), Color(255,255,255,255))
end

function TOOL:Holster()
	if ( IsValid(self.GhostEntity)) then
		self.GhostEntity:Remove()
	end
end

function TOOL:LeftClick( trace )
	local ply = self:GetOwner()
	local normal = trace.HitNormal/2

	--local spawnPos = trace.HitPos+Vector(normal.x*snap.x, normal.y*snap.y, normal.z*snap.z)
	if (cvars.Number("map_builder_action") != 0) then
		selectionNormal = Vector(0,0,1)
		if (cvars.Bool("map_builder_dynamic_normal")) then
			selectionNormal = trace.HitNormal
		end
		ply:SetNWVector("selectionNormal", selectionNormal)
		if (IsValid(originProp)) then
		else
			if (IsValid(self.GhostEntity)) then
				self.GhostEntity:Remove()
			end
			--self:SpawnProp(Vector(1,1,1), spawnPos, spawnPos, cvars.String( "map_builder_model" ))
		end
	else
		if (!contextMenu) then
			local ent = trace.Entity
			ply:SetNWEntity("originProp", ent)
			ply:SetNWVector("originPos", ent:GetNWVector("center", ent:GetPos()))
			originProp = ent
			if (CLIENT) then
				GetConVar("map_builder_action"):SetInt(1)
			end
		end
	end
end

function TOOL:RightClick( trace )
	if (IsValid(trace.Entity)) then
	end
end

function TOOL:Reload( trace )
end

function TOOL:toolGunEffect( trace, self )
    local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos )
	effectdata:SetStart( self:GetOwner():GetShootPos() )
	util.Effect( "ToolTracer", effectdata )
end 

function TOOL:Think()
	if (CLIENT) then
		local ply = LocalPlayer()
		local selectedBlock = cvars.Number( "map_builder_model" )
		--snap = Vector(baseSnap.x*blocks[selectedBlock].size.x, baseSnap.y*blocks[selectedBlock].size.y, baseSnap.z*blocks[selectedBlock].size.z)
		E_down = input.IsKeyDown(KEY_E) and not E_hold
		ply:SetNWBool("E_down", E_down)
		E_hold = input.IsKeyDown(KEY_E)
		ply:SetNWBool("E_hold", E_hold)	
		LMB_up = not input.IsMouseDown(MOUSE_LEFT) and LMB_hold
		ply:SetNWBool("LMB_up", LMB_up)
		LMB_down = input.IsMouseDown(MOUSE_LEFT) and not LMB_hold
		if (LMB_down) then
			MOUSE_cooldown = CurTime()+0.1
		end
		ply:SetNWBool("LMB_down", LMB_down)
		LMB_hold = input.IsMouseDown(MOUSE_LEFT)
		ply:SetNWBool("LMB_hold", LMB_hold)
		ply.drawBuildOverlay = 1
		if (!contextMenu) then
			originProp = ply:GetNWEntity("originProp", nil)
			local trace = ply:GetEyeTrace()
			local selectionNormal = ply:GetNWVector("selectionNormal", Vector(0,0,1))
			if (LMB_down) then
				if (IsValid(originProp)) then
					local normalOffset = trace.HitNormal
					if (cvars.Bool( "map_builder_overlap" )) then normalOffset = -normalOffset end
					ply:SetNWVector("selectionPos", self:SnappedPos(trace.HitPos+normalOffset))
				else
					ply:SetNWVector("selectionPos", trace.HitPos+Vector(trace.HitNormal.x*snap.x/2,trace.HitNormal.y*snap.y/2,trace.HitNormal.z*snap.z/2))
				end
			end
			selectionPos = ply:GetNWVector("selectionPos", Vector(0,0,0))
			selectionEnd = ply:GetNWVector("selectionEnd", Vector(0,0,0))
			if (LMB_hold) then
				selectionEnd = self:SnappedPos(trace.HitPos+Vector(0,0,-1))
				local traceVector = trace.HitPos-trace.StartPos
				local projectedMaxDist = traceVector:Dot(selectionNormal)
				local projectedSelDist = (selectionPos-trace.StartPos):Dot(selectionNormal)
				local _vector = trace.StartPos+traceVector*(projectedSelDist/projectedMaxDist)
				ply:SetNWVector("selectionPos", selectionPos)
				ply:SetNWVector("selectionEnd", _vector)
			end
			if (E_down or (cvars.Bool("map_builder_auto_use") and ply:GetNWBool("LMB_up", false))) then
				if (selectionPos != Vector(0,0,0)) then
					if (cvars.Number("map_builder_action") == 1) then
						if (cvars.Bool("map_builder_replace")) then
							self:DeleteProp(snap, selectionPos, selectionEnd)
							timer.Simple(0.1, function()
								self:SpawnProp(snap, selectionPos, selectionEnd, blocks[selectedBlock].models, cvars.String("map_builder_material"), Vector(cvars.Number("map_builder_color_r"),cvars.Number("map_builder_color_g"),cvars.Number("map_builder_color_b")),cvars.Number("map_builder_color_a"))
							end)
						else
							self:SpawnProp(snap, selectionPos, selectionEnd, blocks[selectedBlock].models, cvars.String("map_builder_material"), Vector(cvars.Number("map_builder_color_r"),cvars.Number("map_builder_color_g"),cvars.Number("map_builder_color_b")),cvars.Number("map_builder_color_a"))
						end
					elseif (cvars.Number("map_builder_action") == 2) then
						self:DeleteProp(snap, selectionPos, selectionEnd)
					elseif (cvars.Number("map_builder_action") == 3) then
						self:StackProp(snap, selectionPos, selectionEnd)
					elseif (cvars.Number("map_builder_action") == 4) then
						self:PaintProp(snap, selectionPos, selectionEnd, cvars.String("map_builder_material"), Vector(cvars.Number("map_builder_color_r"),cvars.Number("map_builder_color_g"),cvars.Number("map_builder_color_b")),cvars.Number("map_builder_color_a"))
					end
				end
				if (IsValid(self.GhostEntity)) then
					self.GhostEntity:Remove()
				end
				if (cvars.Bool("map_builder_auto_nudge")) then
					local spaces = 1+math.abs((selectionPos.z-selectionEnd.z)/snap.z)
					selectionPos = selectionPos+spaces*nextSelection*blocks[selectedBlock].size.z*nextSelection:Dot(snap)
					ply:SetNWVector("selectionPos", selectionPos)
					selectionEnd = selectionEnd+spaces*nextSelection*blocks[selectedBlock].size.z*nextSelection:Dot(snap)
					ply:SetNWVector("selectionEnd", selectionEnd)
				end
				E_down = false
			end
		end

		if (lastselectedBlock != selectedBlock) then
			self:SetCSModels(blocks[selectedBlock].models)
			lastselectedBlock = selectedBlock
		end
		if (ply.popupMenu != nil) then
			self:RefreshCSModels(blocks[selectedBlock].models)
		else
			self:RemoveCSModels()
		end
	end
end

function TOOL:UpdateGhostEntity(entity, pl)
	if (SERVER) then
		if (IsValid(pl)) then
			if (!IsValid(originProp)) then
				local trace = pl:GetEyeTrace()
				local normal = trace.HitNormal/2
				local spawnPos = trace.HitPos+Vector(normal.x*snap.x, normal.y*snap.y, normal.z*snap.z)
				--if (IsValid(originProp)) then
					--spawnPos = self:SnappedPos(spawnPos)
				--end
				entity:SetPos(spawnPos)
			end
		end
	end
end

function TOOL:SpawnProp(snap, pos, endPos, models, material, color, alpha)
	if (CLIENT) then
		local ply = self:GetOwner()
		net.Start("MapBuilder_SpawnProp")
			net.WriteTable(models)
			net.WriteString(material)
			net.WriteVector(color)
			net.WriteVector(snap)
			net.WriteVector(pos)
			net.WriteVector(endPos)
		net.SendToServer()
	end
end

function TOOL:DeleteProp(snap, pos, endPos)
	if (CLIENT) then
		local ply = self:GetOwner()
		net.Start("MapBuilder_DeleteProp")
			net.WriteVector(snap)
			net.WriteVector(pos)
			net.WriteVector(endPos)
			net.WriteEntity(originProp)
		net.SendToServer()
	end
end

function TOOL:StackProp(snap, pos, endPos)
	if (CLIENT) then
		local ply = self:GetOwner()
		net.Start("MapBuilder_StackProp")
			net.WriteVector(snap)
			net.WriteVector(pos)
			net.WriteVector(endPos)
		net.SendToServer()
	end
end

function TOOL:PaintProp(snap, pos, endPos, material, color, alpha)
	if (CLIENT) then
		local ply = self:GetOwner()
		net.Start("MapBuilder_PaintProp")
			net.WriteVector(snap)
			net.WriteVector(pos)
			net.WriteVector(endPos)
			net.WriteString(material)
			net.WriteVector(color)
			net.WriteFloat(alpha)
		net.SendToServer()
	end
end

function TOOL:SnappedPos(pos)
	local originPos = self:GetOwner():GetNWVector("originPos", Vector(0,0,0))
	if (originPos != Vector(0,0,0)) then
		originPos = Vector(originPos.x%(snap.x), originPos.y%(snap.y), originPos.z%(snap.z))
		local newpos = Vector(math.Round((pos.x-originPos.x)/snap.x)*snap.x+originPos.x,math.Round((pos.y-originPos.y)/snap.y)*snap.y+originPos.y,math.Round((pos.z-originPos.z)/snap.z)*snap.z+originPos.z)
		return newpos
	else
		return pos
	end
end

function TOOL:OpenModelMenu(selectedBlock)
	if (selectedBlock == 0) then selectedBlock = 1 end
	self:SetCSModels(blocks[selectedBlock].models)
	local pl = self:GetOwner()
	local w = 250
	local h = ScrH()*0.6
	if (pl.popupMenu != nil) then pl.popupMenu:Remove() end
	pl.popupMenu = vgui.Create("DFrame")

	pl.popupMenu:SetSize(w,h)
	pl.popupMenu:SetPos((ScrW()-w)/2+200,(ScrH()-h)/2)
	pl.popupMenu:SetTitle("Block")
	pl.popupMenu:MakePopup()
	--frame:ShowCloseButton()
	local button = vgui.Create("DButton", pl.popupMenu)
	button:SetSize(90,18)
	button:SetPos(w-93,3)
	button:SetText("x")
	function button:DoClick()
		pl.popupMenu:Remove()
		pl.popupMenu = nil
	end

	local scroll = vgui.Create( "DScrollPanel", pl.popupMenu ) //Create the Scroll panel
	scroll:SetSize( 230, h-55 )
	scroll:SetPos( 10, 40 )

	local List	= vgui.Create( "DIconLayout", scroll )
	List:SetSize( 230, 700 )
	List:SetPos( 0, 0 )
	List:SetSpaceY( 5 ) //Sets the space in between the panels on the X Axis by 5
	List:SetSpaceX( 5 ) //Sets the space in between the panels on the Y Axis by 5
	
	local a = table.getn(blocks)
	local color = Color(255,255,255)
	for i = 1, a do //Make a loop to create a bunch of panels inside of the DIconLayout
		if (IsValid(originProp) or blocks[i].canBeOrigin) then
			local button = List:Add( "DButton" ) //Add DPanel to the DIconLayout
			button:SetSize( 200, 50 ) //Set the size of it
			button:SetText(blocks[i].name)
			button:SetFont("CloseCaption_Normal")
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(color.r-40,color.g-40,color.b-40) )
				draw.RoundedBox( 3, 5, 5, w-10, h-10, color )
			end
			function button:OnCursorEntered()
				GetConVar("map_builder_model"):SetInt(i)
			end
			function button:DoClick()
				GetConVar("map_builder_model"):SetInt(i)
				pl.popupMenu:Remove()
				pl.popupMenu = nil
			end
		end
	end
end

function TOOL:OpenMaterialMenu()
	local pl = LocalPlayer()
	local w = 450
	local h = ScrH()*0.6
	if (pl.popupMenu != nil) then pl.popupMenu:Remove() end
	pl.popupMenu = vgui.Create("DFrame")

	pl.popupMenu:SetSize(w,h)
	pl.popupMenu:SetPos((ScrW()-w)/2,(ScrH()-h)/2)
	pl.popupMenu:SetTitle("Material")
	pl.popupMenu:MakePopup()
	--frame:ShowCloseButton()
	local button = vgui.Create("DButton", pl.popupMenu)
	button:SetSize(90,18)
	button:SetPos(w-93,3)
	button:SetText("x")
	function button:DoClick()
		pl.popupMenu:Remove()
		pl.popupMenu = nil
	end

	local scroll = vgui.Create( "DScrollPanel", pl.popupMenu ) //Create the Scroll panel
	scroll:SetSize( 430, h-55 )
	scroll:SetPos( 10, 40 )

	local List	= vgui.Create( "DIconLayout", scroll )
	List:SetSize( 430, 700 )
	List:SetPos( 0, 0 )
	List:SetSpaceY( 5 ) //Sets the space in between the panels on the X Axis by 5
	List:SetSpaceX( 5 ) //Sets the space in between the panels on the Y Axis by 5
	
	local materialTable = list.Get( "OverrideMaterials" )
	local a = table.getn(materialTable)
	local color = Color(255,255,255)
	local button = List:Add( "DButton" ) //Add DPanel to the DIconLayout
		button:SetSize( 100, 100 ) //Set the size of it
		button:SetText("")
		function button:DoClick()
			GetConVar("map_builder_material"):SetString("nil")
			pl.popupMenu:Remove()
			pl.popupMenu = nil
		end
	for i = 1, a do //Make a loop to create a bunch of panels inside of the DIconLayout
		local button = List:Add( "DButton" ) //Add DPanel to the DIconLayout
		button:SetSize( 100, 100 ) //Set the size of it
		button:SetText("")
		function button:DoClick()
			GetConVar("map_builder_material"):SetString(materialTable[i])
			pl.popupMenu:Remove()
			pl.popupMenu = nil
		end
		button.Paint = function(s, w, h)
			surface.SetMaterial( Material( materialTable[i] ) )
			surface.SetDrawColor(Color(255,255,255))
			surface.DrawTexturedRectUV( 0, 0, w, h, 0, 0, 1, 1 )
		end
	end
end

function TOOL:OpenColorMenu()
	local pl = LocalPlayer()
	local w = 450
	local h = ScrH()*0.6
	if (pl.popupMenu != nil) then pl.popupMenu:Remove() end
	pl.popupMenu = vgui.Create("DFrame")

	pl.popupMenu:SetSize(w,h)
	pl.popupMenu:SetPos((ScrW()-w)/2,(ScrH()-h)/2)
	pl.popupMenu:SetTitle("Material")
	pl.popupMenu:MakePopup()

	local Mixer = vgui.Create( "DColorMixer", pl.popupMenu )
	Mixer:SetPos(10, 30)
	Mixer:SetSize(430, h-150)			--Make Mixer fill place of Frame
	Mixer:SetPalette( true ) 		--Show/hide the palette			DEF:true
	Mixer:SetAlphaBar( true ) 		--Show/hide the alpha bar		DEF:true
	Mixer:SetWangs( true )			--Show/hide the R G B A indicators 	DEF:true
	Mixer:SetColor( Color( cvars.Number("map_builder_color_r"), cvars.Number("map_builder_color_g"), cvars.Number("map_builder_color_b") ) )	--Set the default color

	local button = vgui.Create("DButton", pl.popupMenu)
	button:SetSize(90,18)
	button:SetPos(w-93,3)
	button:SetText("x")
	function button:DoClick()
		pl.popupMenu:Remove()
		pl.popupMenu = nil
	end

	local button = vgui.Create("DButton", pl.popupMenu)
	button:SetSize(200,80)
	button:SetPos(w/2-100,h-100)
	button:SetText("Pick")
	button:SetFont("CloseCaption_Normal")
	function button:DoClick()
		local color = Mixer:GetColor()
		GetConVar("map_builder_color_r"):SetFloat(color.r)
		GetConVar("map_builder_color_g"):SetFloat(color.g)
		GetConVar("map_builder_color_b"):SetFloat(color.b)
		GetConVar("map_builder_color_a"):SetFloat(color.a)
		pl.popupMenu:Remove()
		pl.popupMenu = nil
	end
end

function TOOL:SetCSModels(models)
	self:RemoveCSModels()	
	for k, v in pairs(models) do
		--CREAR UN CLIENTSIDE MODEL
		local csm = ClientsideModel( v.model )
		csm:SetPos(v.offset)
		csm:SetAngles(v.angle)
		csm:SetModelScale(0.1)
		table.insert(csModels, csm)
	end

	csm = ClientsideModel( "models/hunter/blocks/cube4x4x4.mdl" )
	csm:SetModelScale(-0.1)
	csm:SetMaterial("models/debug/debugwhite")
	csm:SetRenderMode( RENDERMODE_TRANSALPHA )
	csm:SetColor(Color(0,0,0,100))
	table.insert(csModels, csm)

	--[[
			if (SERVER) then
				net.Start("MapBuilder_SetCSModels")
				 	net.WriteTable(csModels)
				net.Send(self:GetOwner())
			else
				HaloCSModels = csModels
			end]]
end

function TOOL:RemoveCSModels()
	--print("REMOVE CS")
	for k, v in pairs(csModels) do
		v:Remove()
	end
	csModels = {}
end

function TOOL:RefreshCSModels(models)
	--print("refresh cs")
	local pl = self:GetOwner()
	local plpos = pl:EyePos()+pl:EyeAngles():Forward()*50-pl:EyeAngles():Right()*15
	local timeang = Angle(0,CurTime()*15,0)
	local keys = table.Count(models)
	for k, v in pairs(csModels) do
		--CREAR UN CLIENTSIDE MODEL
		if (k <= keys) then
			local newOffset = Vector(models[k].offset.x, models[k].offset.y, models[k].offset.z)*0.1
			newOffset:Rotate(models[k].angle+timeang)
			v:SetPos(newOffset+plpos)
			v:SetAngles(models[k].angle+timeang)
		else
			v:SetPos(plpos)
			v:SetAngles(timeang)
		end
	end
end

function TOOL:DrawHUD()
	mousex = gui.MouseX()
	mousey = gui.MouseY()
	local size = ScrW()/1920--*GetConVar("map_builder_hud_size"):GetFloat()
	local font = "DermaLarge"
	if (size < 0.65) then font = "Trebuchet24" end
	if (size < 0.45) then font = "Trebuchet18" end
	local x = ScrW()-size*1550
	local y = 0
	local w = 60*size
	local h = 60*size
	local dist = 5*size
	draw.DrawText( "Open the Context Menu (default C) to access the buttons", font, 370*size, ScrH()-70*size, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	
	local pressed = LMB_down or CurTime() < MOUSE_cooldown
	if (LMB_down) then MOUSE_cooldown = CurTime()+0.1 end
	if (contextMenu) then
		y = y+30
		if (_mapmaker_button(ScrW()-100*size, ScrH()-400*size, w, h, pressed, "help", false,"Help",50,size,font)) then
			self:OpenHelpMenu()
		end
		--[[if (_mapmaker_button(ScrW()-100-w-dist, ScrH()-200, w, h, pressed, "zoom_in", false,"Bigger HUD",80,size,font)) then
							if (size < 2) then
								GetConVar("map_builder_hud_size"):SetFloat(size+0.02)
							end
						end
						if (_mapmaker_button(ScrW()-100-w*2-10, ScrH()-200, w, h, pressed, "zoom_out", false,"Smaller HUD",80,size,font)) then
							if (size > 0.5) then
								GetConVar("map_builder_hud_size"):SetFloat(size-0.02)
							end
						end]]
		if (_mapmaker_button(ScrW()/2-w/2, ScrH()-400*size, w, h, pressed, "anchor", cvars.Number("map_builder_action") == 0,"Choose Origin Prop",130,size,font)) then
			GetConVar("map_builder_action"):SetInt(0)
		end
	end
	if (IsValid(LocalPlayer():GetNWEntity("originProp", nil))) then
		local pos = LocalPlayer():GetNWEntity("originProp", nil):GetPos():ToScreen()
		pos = Vector(pos.x, pos.y)
		surface.SetDrawColor(Color(255,255,255,255))
	  	surface.DrawRect( pos.x - 16, pos.y - 16, 32, 32 )
		surface.SetDrawColor(Color(150,150,150,255))
	  	surface.DrawRect( pos.x - 12, pos.y - 12, 24, 24 )
	  	surface.SetDrawColor(Color(255,255,255,255))
	  	surface.DrawRect( pos.x - 6, pos.y - 6, 12, 12 )
	end
	local by = y+70*size+dist
	------------------------------------------------------------BOTONES
	local color = Color(60,60,60)
	surface.SetDrawColor(color)
	surface.DrawRect( x, y, 4*(w+dist)-dist, 70*size )
	draw.DrawText( "Actions", font, x+dist, y+dist, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	if (_mapmaker_button(x, by, w, h, pressed, "brick_add", cvars.Number("map_builder_action") == 1,"Build",50,size,font)) then
		GetConVar("map_builder_action"):SetInt(1)
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "brick_delete", cvars.Number("map_builder_action") == 2,"Delete",60,size,font)) then
		GetConVar("map_builder_action"):SetInt(2)
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "page_white_get", cvars.Number("map_builder_action") == 3,"Stack Up",70,size,font)) then
		GetConVar("map_builder_action"):SetInt(3)
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "paintbrush", cvars.Number("map_builder_action") == 4,"Apply Material and Color",160,size,font)) then
		GetConVar("map_builder_action"):SetInt(4)
	end
	x = x+w*1.5+dist
	surface.SetDrawColor(color)
	surface.DrawRect( x, y, 3*(w+dist)-dist, 70*size )
	draw.DrawText( "Prop", font, x+dist, y+dist, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	if (_mapmaker_button(x, by, w, h, pressed, "bricks", false,"Block",50,size,font)) then
		self:OpenModelMenu(cvars.Number("map_builder_model"))
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "color_wheel", false,"Color",50,size,font)) then
		self:RemoveCSModels()	
		self:OpenColorMenu()
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "shading", false,"Material",70,size,font)) then
		self:RemoveCSModels()	
		self:OpenMaterialMenu()
	end
	x = x+w*1.5+dist
	surface.SetDrawColor(color)
	surface.DrawRect( x, y, 5*(w+dist)-dist, 70*size )
	draw.DrawText( "Settings", font, x+dist, y+dist, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	if (_mapmaker_button(x, by, w, h, pressed, "cancel", cvars.Bool("map_builder_replace"),"Replace",60,size,font)) then
		GetConVar("map_builder_replace"):SetBool(!cvars.Bool("map_builder_replace"))
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "shape_square_go", !cvars.Bool("map_builder_overlap"),"Selection Outcrop",130,size,font)) then
		GetConVar("map_builder_overlap"):SetBool(!cvars.Bool("map_builder_overlap"))
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "vector", cvars.Bool("map_builder_dynamic_normal"),"Dynamic Selection Surface",180,size,font)) then
		GetConVar("map_builder_dynamic_normal"):SetBool(!cvars.Bool("map_builder_dynamic_normal"))
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "bullet_go", cvars.Bool("map_builder_auto_use"),"Auto Apply",80,size,font)) then
		GetConVar("map_builder_auto_use"):SetBool(!cvars.Bool("map_builder_auto_use"))
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "car", cvars.Bool("map_builder_auto_nudge"),"Auto Nudge",80,size,font)) then
		GetConVar("map_builder_auto_nudge"):SetBool(!cvars.Bool("map_builder_auto_nudge"))
	end
	x = x+w*1.5+dist
	surface.SetDrawColor(color)
	surface.DrawRect( x, y, 5*(w+dist)-dist, 70*size )
	draw.DrawText( "Selection", font, x+dist, y+dist, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	by = by+h+dist
	x = x+(w+dist)*3
	if (_mapmaker_button(x, by, w, h, pressed, "building_add", false,"Extrude Selection Up",160,size,font)) then
		selectionEnd = selectionEnd+Vector(0,0,snap.x)
		LocalPlayer():SetNWVector("selectionEnd", selectionEnd)
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "building_delete", false,"Extrude Selection Down",160,size,font)) then
		selectionEnd = selectionEnd-Vector(0,0,snap.x)
		LocalPlayer():SetNWVector("selectionEnd", selectionEnd)
	end
	x = x-(w+dist)*4
	by = by-h-dist
	if (_mapmaker_button(x, by, w, h, pressed, "bullet_white", false,"Nudge Selection Forward",160,size,font)) then
		local angle = Angle(0,math.Round(LocalPlayer():EyeAngles().y/90)*90,0)
		selectionPos = selectionPos+angle:Forward()*snap.x
		LocalPlayer():SetNWVector("selectionPos", selectionPos)
		selectionEnd = selectionEnd+angle:Forward()*snap.x
		LocalPlayer():SetNWVector("selectionEnd", selectionEnd)
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "bullet_arrow_top", false,"Nudge Selection Up",130,size,font)) then
		selectionPos = selectionPos+Vector(0,0,snap.z)
		LocalPlayer():SetNWVector("selectionPos", selectionPos)
		selectionEnd = selectionEnd+Vector(0,0,snap.z)
		LocalPlayer():SetNWVector("selectionEnd", selectionEnd)
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "bullet_arrow_bottom", false,"Nudge Selection Down",145,size,font)) then
		selectionPos = selectionPos-Vector(0,0,snap.z)
		LocalPlayer():SetNWVector("selectionPos", selectionPos)
		selectionEnd = selectionEnd-Vector(0,0,snap.z)
		LocalPlayer():SetNWVector("selectionEnd", selectionEnd)
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "bullet_arrow_up", false,"Nudge Sel. 1/4 Up",125,size,font,-30)) then
		selectionPos = selectionPos+Vector(0,0,snap.z/4)
		LocalPlayer():SetNWVector("selectionPos", selectionPos)
		selectionEnd = selectionEnd+Vector(0,0,snap.z/4)
		LocalPlayer():SetNWVector("selectionEnd", selectionEnd)
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "bullet_arrow_down", false,"Nudge Sel. 1/4 Down",145,size,font,-100)) then
		selectionPos = selectionPos-Vector(0,0,snap.z/4)
		LocalPlayer():SetNWVector("selectionPos", selectionPos)
		selectionEnd = selectionEnd-Vector(0,0,snap.z/4)
		LocalPlayer():SetNWVector("selectionEnd", selectionEnd)
	end
	x = x+w*1.5+dist
	surface.SetDrawColor(color)
	surface.DrawRect( x, y, 3*(w+dist)-dist, 70*size )
	draw.DrawText( "Symmetry", font, x+dist, y+dist, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	by = by+h+dist
	if (_mapmaker_button(x, by, w, h, pressed, "arrow_refresh", cvars.Number("map_builder_symmetry") == 3,"Rotated",60,size,font)) then
		GetConVar("map_builder_symmetry"):SetInt(3)
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "arrow_out", cvars.Number("map_builder_symmetry") == 4,"4-Way Mirrored",100,size,font)) then
		GetConVar("map_builder_symmetry"):SetInt(4)
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "arrow_rotate_clockwise", cvars.Number("map_builder_symmetry") == 5,"4-Way Rotated",100,size,font)) then
		GetConVar("map_builder_symmetry"):SetInt(5)
	end
	x = x-(w+dist)*2
	by = by-h-dist
	if (_mapmaker_button(x, by, w, h, pressed, "arrow_up", cvars.Number("map_builder_symmetry") == 0,"None",50,size,font)) then
		GetConVar("map_builder_symmetry"):SetInt(0)
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "arrow_divide", cvars.Number("map_builder_symmetry") == 1,"Mirrored X",70,size,font)) then
		GetConVar("map_builder_symmetry"):SetInt(1)
	end
	x = x+w+dist
	if (_mapmaker_button(x, by, w, h, pressed, "arrow_divide", cvars.Number("map_builder_symmetry") == 2,"Mirrored Y",70,size,font)) then
		GetConVar("map_builder_symmetry"):SetInt(2)
	end
end

function TOOL:OpenHelpMenu()
	local pl = LocalPlayer()
	local w = 450
	local h = ScrH()*0.6
	if (pl.popupMenu != nil) then pl.popupMenu:Remove() end
	pl.popupMenu = vgui.Create("DFrame")

	pl.popupMenu:SetSize(w,h)
	pl.popupMenu:SetPos((ScrW()-w)/2,(ScrH()-h)/2)
	pl.popupMenu:SetTitle("Help")
	pl.popupMenu:MakePopup()

	local richtext = vgui.Create( "RichText", pl.popupMenu )
	function richtext:PerformLayout()
		self:SetFontInternal( "Trebuchet24" )
		self:SetFGColor( Color( 255, 255, 255 ) )
	end
	richtext:Dock( FILL )
	richtext:InsertColorChange( 255, 255, 224, 255 )
	richtext:AppendText( [[
	How to use
]] )
	richtext:InsertColorChange( 192, 192, 192, 255 )
	richtext:AppendText( [[
This tool works by selecting areas and then executing an action in that area. Hold and drag the Left Click to select and area, and press E to apply your chosen action. Choose an action and change the settings with the buttons above. You can access this buttons by holding the Context Menu button (default C).

]] )
	richtext:InsertColorChange( 255, 255, 224, 255 )
	richtext:AppendText( [[
Actions
]] )
	richtext:InsertColorChange( 192, 192, 192, 255 )
	richtext:AppendText( [[
> Build:
Spawn a Block in each selected space

> Delete:
Remove all props in the selected space

> Stack Up:
Copy all selected props one block above

> Apply Material & Color:
Set the material and color of all selected props to the chosen material and color
	]] )
	richtext:InsertColorChange( 255, 255, 224, 255 )
	richtext:AppendText( [[

Prop
]] )
	richtext:InsertColorChange( 192, 192, 192, 255 )
	richtext:AppendText( [[
> Block:
Choose the group of props to be spawned with the "Build" action

> Color:
Pick a color to be applied when spawning props, or when using the "Apply Material & Color" action

> Material:
Pick a material to be applied when spawning props, or when using the "Apply Material & Color" action
	]] )

	richtext:InsertColorChange( 255, 255, 224, 255 )
	richtext:AppendText( [[
		
Settings
]] )
	richtext:InsertColorChange( 192, 192, 192, 255 )
	richtext:AppendText( [[
> Replace:
Delete selected props before building

> Selection Outcrop:
Select the block on top of the click position instead of the block itself

> Dynamic Selection Surface:
Set the selection plane to be the same as the surface at the start of the selection. If off, it will always be a horizontal plane

> Auto Apply:
Execute the action as soon as you end your selection

> Auto Nudge:
Nudge your selection up every time you press E

	]] )

	richtext:InsertColorChange( 255, 255, 224, 255 )
	richtext:AppendText( [[
Symmetry
]] )
	richtext:InsertColorChange( 192, 192, 192, 255 )
	richtext:AppendText( [[
> None:
Plain old normal building

> Mirrored X:
Every action you make, will be mirrored to the other side of the Origin Prop marked by the white square, across the X coordinate

> Mirrored Y:
Every action you make, will be mirrored to the other side of the Origin Prop marked by the white square, across the Y coordinate

> Rotated:
Every action you make, will be repeated on the oposite area rotated 180 degrees around the Origin Prop marked by the white square

> 4-Way Mirrored:
Every action you make, will be mirrored both ways, with the Origin Prop marked by the white square as the center

> 4-Way Rotated:
Every action you make, will be repeated on the areas rotated 90, 180 and 270 degrees around the Origin Prop marked by the white square

	]] )

	richtext:InsertColorChange( 255, 255, 224, 255 )
	richtext:AppendText( [[
Special Tools
]] )
	richtext:InsertColorChange( 192, 192, 192, 255 )
	richtext:AppendText( [[
At the bottom center of the screen there is a special tool button

> Choose Origin Prop:
With this tool selected, click on a prop to make it your new origin prop. This is useful to set your grid to a prop of another map, if you lost your origin, or you want to work in someone else's map.
	]] )
end

hook.Add( "OnContextMenuOpen", "closeContext", function()
	contextMenu = true
end)

hook.Add( "OnContextMenuClose", "closeContext", function()
	contextMenu = false
end)

hook.Add( "PostDrawOpaqueRenderables", "example", function()
	local ply = LocalPlayer()
	if (ply.drawBuildOverlay == nil) then
		ply.drawBuildOverlay = 0
	end
	if (ply.drawBuildOverlay > 0) then
		ply.drawBuildOverlay = ply.drawBuildOverlay-0.1
		local selectedBlock = cvars.Number("map_builder_model")
		local boxSize = Vector(snap.x/2, snap.y/2, snap.z/2)
		local selectionPos = ply:GetNWVector("selectionPos", Vector(0,0,0))
		local selectionEnd = ply:GetNWVector("selectionEnd", Vector(0,0,0))
		if (selectionPos != Vector(0,0,0)) then
			local xdif = (selectionEnd.x-selectionPos.x)/snap.x
			local ydif = (selectionEnd.y-selectionPos.y)/snap.y
			local zdif = (selectionEnd.z-selectionPos.z)/snap.z
			xdif = math.Clamp(xdif, -50, 50)
			ydif = math.Clamp(ydif, -50, 50)
			zdif = math.Clamp(zdif, -50, 50)
			local xinc = _sign(xdif)
			local yinc = _sign(ydif)
			local zinc = _sign(zdif)
			local x = 0
			local tooBig = false
			if (math.abs(xdif)+math.abs(ydif)+math.abs(zdif) > 20) then tooBig = true end
			while(x <= math.abs(xdif)) do
				local y = 0
				while(y <= math.abs(ydif)) do
					local z = 0
					while(z <= math.abs(zdif)) do
						local boxPos = selectionPos+Vector(x*snap.x*xinc, y*snap.y*yinc, z*snap.z*zinc)
						if (!tooBig || x+y == 0 || y+z == 0 || z+x == 0 || math.abs(x) == math.floor(math.abs(xdif)) && math.abs(y) == math.floor(math.abs(ydif)) &&  math.abs(z) == math.floor(math.abs(zdif)) ) then
							render.DrawWireframeBox(boxPos,Angle(0,0,0),-boxSize,boxSize,Color(255,255,0,40),false)
							render.DrawWireframeBox(boxPos,Angle(0,0,0),-boxSize,boxSize,Color(255,255,255),true)
						end
						z = z + 1
					end
					y = y + 1
				end
				x = x + 1
			end
			--else
			--	local bigBoxSize = Vector(math.ceil((snap.x*xdif)/snap.x)*snap.x,math.ceil((snap.y*ydif)/snap.y)*snap.y,math.ceil((snap.z*zdif)/snap.z)*snap.z)
			--	local bigBoxPos = selectionPos
			--	render.DrawWireframeBox(Vector(math.floor(bigBoxPos.x/snap.x)*snap.x,math.floor(bigBoxPos.y/snap.y)*snap.y,math.floor(bigBoxPos.z/snap.z)*snap.z),Angle(0,0,0),bigBoxSize,Vector(0,0,0),Color(255,255,255,40),false)
			--end
		end
	end
end )

function _sign(number)
	if (number == 0) then
		return 0
	else
		return number/math.abs(number)
	end
end

function _mapmaker_button(x,y,w,h,pressed,image,on,description,descriptionWidth,size,font,xoffset)
	if (xoffset == nil) then xoffset = 0 end
	if (size == nil) then size = 1 end
	local hover = (mousex > x and mousex < x+w and mousey > y and mousey < y+h)
	local color = Color(60,60,60)
	local pressedthis = false
	size = size*1.5
	xoffset = xoffset*size
	if (on) then color = Color(240,30,30) end
	if (hover) then
		pressedthis = pressed
		surface.SetDrawColor(Color(color.r+30, color.g+30, color.b+30))
		if (description != nil) then
			surface.DrawRect( x+xoffset+w/2-descriptionWidth*size, y+h+20-10*size, descriptionWidth*2*size, 40*size )
			draw.DrawText( description, font, x+xoffset+w/2, y+h+15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		end
	else
		surface.SetDrawColor(color)
	end
	surface.DrawRect( x, y, w, h )
	surface.SetMaterial( Material( "icon16/"..image..".png", "noclamp" ) )
	surface.SetDrawColor(Color(255,255,255))
	surface.DrawTexturedRectUV( x+w*0.2, y+h*0.2, w*0.6, h*0.6, 0, 0, 1, 1 )
	if (pressedthis) then
		MOUSE_cooldown = CurTime()
		LMB_down = false
	end
	return pressedthis
end

if (CLIENT) then
language.Add( "tool.map_builder.name", "" )
language.Add( "tool.map_builder.desc", "" )
language.Add( "tool.map_builder.0", "" )
language.Add( "undone.map_builder", "Block has been undone." )
end