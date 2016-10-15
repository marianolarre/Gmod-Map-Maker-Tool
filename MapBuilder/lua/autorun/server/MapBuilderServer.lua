util.AddNetworkString( "MapBuilder_SpawnProp" )
util.AddNetworkString( "MapBuilder_DeleteProp" )
util.AddNetworkString( "MapBuilder_StackProp" )
util.AddNetworkString( "MapBuilder_PaintProp" )

--util.AddNetworkString( "MapBuilder_SetCSModels" )

local function SetColour( ply, ent, data )

	if ( data.Color && data.Color.a < 255 && data.RenderMode == 0 ) then
		data.RenderMode = 1
	end

	if ( data.Color ) then ent:SetColor( Color( data.Color.r, data.Color.g, data.Color.b, data.Color.a ) ) end
	if ( data.RenderMode ) then ent:SetRenderMode( data.RenderMode ) end
	if ( data.RenderFX ) then ent:SetKeyValue( "renderfx", data.RenderFX ) end

	if ( SERVER ) then
		duplicator.StoreEntityModifier( ent, "colour", data )
	end

end

local function SetMaterial( Player, Entity, Data )

	if ( SERVER ) then

		if ( !game.SinglePlayer() && !list.Contains( "OverrideMaterials", Data.MaterialOverride ) && Data.MaterialOverride != "" ) then return end

		Entity:SetMaterial( Data.MaterialOverride )
		duplicator.StoreEntityModifier( Entity, "material", Data )
	end

	return true
end

net.Receive( "MapBuilder_SpawnProp", function( len, pl )
	local props = net.ReadTable()
	local material = net.ReadString()
	local colorVector = net.ReadVector()
	local snap = net.ReadVector()
	local pos = net.ReadVector()
	local endPos = net.ReadVector()
	undo.Create( "Prop" )
	local posTable = MapMaker_Matrix(snap, pos, endPos, pl)
	local color = Color(colorVector.x, colorVector.y, colorVector.z, alpha)
	for k, v in pairs(posTable) do
		for c, p in pairs(props) do
			local ent = ents.Create( "prop_physics" )
			local offset = Vector(p.offset.x, p.offset.y, p.offset.z)
			local angleMultiplier = v.angleMultiplier
			if (angleMultiplier == nil) then angleMultiplier = 1 end
			local angle = v.angle+p.angle+Angle(0,math.Round(pl:EyeAngles().y/90)*90*angleMultiplier,0)
			offset:Rotate( angle )
			ent:SetPos(v.vector+offset)
			ent:SetModel( tostring(p.model) )
			ent:SetAngles(angle)
			ent:Spawn()
			ent:GetPhysicsObject():EnableMotion(false)
			--ent:SetMaterial(material)
			SetMaterial( pl, ent, { MaterialOverride = material } )
			--ent:SetColor(color)
			SetColour( pl, ent, { Color = Color( color.r, color.g, color.b, color.a ), RenderMode = RENDERMODE_NORMAL, RenderFX = kRenderFxNone } )
			MapMaker_RemoveOverlap(ent)
			if (!IsValid(pl:GetNWEntity("originProp", nil))) then
				pl:SetNWEntity("originProp", ent)
				pl:SetNWVector("originPos", pos)
			end
			ent:SetNWVector("center", pos)
			ent:DrawShadow(false)
			undo.AddEntity( ent )
			constraint.Weld( ent, pl:GetNWEntity("originProp", nil), 0, 0, 0, true, false )
		end
	end
	undo.SetPlayer( pl )
	undo.Finish()
end )

net.Receive( "MapBuilder_PaintProp", function( len, pl )
	local snap = net.ReadVector()
	local pos = net.ReadVector()
	local endPos = net.ReadVector()
	local material = net.ReadString()
	local colorVector = net.ReadVector()
	local alpha = net.ReadFloat()
	local color = Color(colorVector.x, colorVector.y, colorVector.z, alpha)
	local posTable = MapMaker_Matrix(snap, pos, endPos, pl)
	for k, v in pairs(posTable) do
		local foundEnts = ents.FindInBox( v.vector-snap*0.49+Vector(0,0,0.1), v.vector+snap*0.49-Vector(0,0,0.1) )
		for c, b in pairs(foundEnts) do
			if (b:GetClass() == "prop_physics") then
				b:SetMaterial(material)
				b:SetColor(color)
			end
		end
	end
end )

net.Receive( "MapBuilder_DeleteProp", function( len, pl )

	local snap = net.ReadVector()
	local pos = net.ReadVector()
	local endPos = net.ReadVector()
	local originProp = net.ReadEntity()
	undo.Create( "Prop" )
	local posTable = MapMaker_Matrix(snap, pos, endPos, pl)
	for k, v in pairs(posTable) do
		local foundEnts = ents.FindInBox( v.vector-snap*0.49+Vector(0,0,0.1), v.vector+snap*0.49-Vector(0,0,0.1) )
		for c, b in pairs(foundEnts) do
			if (b:GetClass() == "prop_physics") then
				if (b != originProp) then
					b:Remove()
				end
			end
		end
	end
end )

net.Receive( "MapBuilder_StackProp", function( len, pl )
	local snap = net.ReadVector()
	local pos = net.ReadVector()
	local endPos = net.ReadVector()
	undo.Create( "Prop" )
	local posTable = MapMaker_Matrix(snap, pos, endPos, pl)
	for k, v in pairs(posTable) do
		local foundEnts = ents.FindInBox( v.vector-snap*0.49+Vector(0,0,0.1), v.vector+snap*0.49-Vector(0,0,0.1) )
		local spaceModel = nil
		local spacePos = Vector(0,0,0)
		local spaceAngle = Angle(0,0,0)
		local spaceMaterial = nil
		local spaceColor = Color(255,255,255,255)
		for c, b in pairs(foundEnts) do
			spaceModel = nil
			if (b:GetClass() == "prop_physics") then
				spaceModel = b:GetModel()
				spacePos = b:GetPos()
				spaceAngle = b:GetAngles()
				spaceMaterial = b:GetMaterial()
				spaceColor = b:GetColor()
			end
			if (spaceModel != nil) then
				local ent = ents.Create( "prop_physics" )
				--ent:SetPos(spacePos+Vector(0,0,snap.z))
				print(math.abs(snap.z+(pos.z-endPos.z)))
				ent:SetPos(spacePos+Vector(0,0,math.abs((-1+(pos.z-endPos.z)/snap.z)*snap.z)))
				ent:SetAngles(spaceAngle)
				ent:SetModel( spaceModel )
				ent:SetColor(spaceColor)
				ent:SetMaterial(spaceMaterial)
				ent:Spawn()
				ent:GetPhysicsObject():EnableMotion(false)
				undo.AddEntity( ent )
				constraint.Weld( ent, pl:GetNWEntity("originProp", nil), 0, 0, 0, true, false )
				MapMaker_RemoveOverlap (ent)
			end
		end
	end
	undo.SetPlayer( pl )
	undo.Finish()
end )

function MapMaker_Matrix (snap, pos, endPos, pl)
	local xdif = (endPos.x-pos.x)/snap.x
	local ydif = (endPos.y-pos.y)/snap.y
	local zdif = (endPos.z-pos.z)/snap.z
	xdif = math.Clamp(xdif, -50, 50)
	ydif = math.Clamp(ydif, -50, 50)
	zdif = math.Clamp(zdif, -50, 50)
	local xinc = _sign(xdif)
	local yinc = _sign(ydif)
	local zinc = _sign(zdif)
	local symmetry = pl:GetInfoNum( "map_builder_symmetry", 0 )
	local originPos = pl:GetNWVector("originPos", Vector(0,0,0))
	local originEntityExists = IsValid(pl:GetNWEntity("originProp", nil))
	local posTable = {}
	local x = 0
	while(x <= math.abs(xdif)) do
		local y = 0
		while(y <= math.abs(ydif)) do
			local z = 0
			while(z <= math.abs(zdif)) do
				table.insert(posTable, {vector = pos+Vector(x*snap.x*xinc, y*snap.y*yinc, z*snap.z*zinc), angle = Angle(0,0,0)})
				if (originEntityExists) then
					if (symmetry == 1) then --MIRRORED X
						table.insert(posTable, {vector = Vector(originPos.x,originPos.y,0)+(Vector(-originPos.x,originPos.y,0)-Vector(-pos.x, pos.y, -pos.z))+Vector(x*snap.x*xinc, -y*snap.y*yinc, z*snap.z*zinc),angle = Angle(0,0,0), angleMultiplier = -1})
					elseif (symmetry == 2) then --MIRRORED Y
						table.insert(posTable, {vector = Vector(originPos.x,originPos.y,0)+(Vector(originPos.x,-originPos.y,0)-Vector(pos.x, -pos.y, -pos.z))+Vector(-x*snap.x*xinc, y*snap.y*yinc, z*snap.z*zinc),angle = Angle(0,180,0), angleMultiplier = -1})
					elseif (symmetry == 3) then --ROTATED
						table.insert(posTable, {vector = Vector(originPos.x,originPos.y,0)*2-Vector(pos.x, pos.y, -pos.z)+Vector(-x*snap.x*xinc, -y*snap.y*yinc, z*snap.z*zinc),angle = Angle(0,180,0)})
					elseif (symmetry == 4) then --4-WAY MIRRORED
						table.insert(posTable, {vector = Vector(originPos.x,originPos.y,0)+Vector(-originPos.x,originPos.y,0)-Vector(-pos.x, pos.y, -pos.z)+Vector(x*snap.x*xinc, -y*snap.y*yinc, z*snap.z*zinc),angle = Angle(0,0,0), angleMultiplier = -1})
						table.insert(posTable, {vector = Vector(originPos.x,originPos.y,0)+Vector(originPos.x,originPos.y,0)-Vector(pos.x, pos.y, -pos.z)+Vector(-x*snap.x*xinc, -y*snap.y*yinc, z*snap.z*zinc),angle = Angle(0,180,0)})
						table.insert(posTable, {vector = Vector(originPos.x,originPos.y,0)+Vector(originPos.x,-originPos.y,0)-Vector(pos.x, -pos.y, -pos.z)+Vector(-x*snap.x*xinc, y*snap.y*yinc, z*snap.z*zinc),angle = Angle(0,180,0), angleMultiplier = -1})
					elseif (symmetry == 5) then --4-WAY ROTATED
						table.insert(posTable, {vector = Vector(originPos.x,originPos.y,0)+Vector(originPos.y,-originPos.x,0)-Vector(pos.y, -pos.x, -pos.z)+Vector(-y*snap.y*yinc, x*snap.x*xinc, z*snap.z*zinc),angle = Angle(0,90,0)})
						table.insert(posTable, {vector = Vector(originPos.x,originPos.y,0)+Vector(originPos.x,originPos.y,0)-Vector(pos.x, pos.y, -pos.z)+Vector(-x*snap.x*xinc, -y*snap.y*yinc, z*snap.z*zinc),angle = Angle(0,180,0)})
						table.insert(posTable, {vector = Vector(originPos.x,originPos.y,0)+Vector(-originPos.y,originPos.x,0)-Vector(-pos.y, pos.x, -pos.z)+Vector(y*snap.y*yinc, -x*snap.x*xinc, z*snap.z*zinc),angle = Angle(0,270,0)})
					end
				end
				z = z + 1
			end
			y = y + 1
		end
		x = x + 1
	end
	return posTable
end

function MapMaker_RemoveOverlap (ent)
	local foundEnts = ents.FindInBox( ent:GetPos()+ent:OBBMins(), ent:GetPos()+ent:OBBMaxs() )
	for c, b in pairs(foundEnts) do
		if (b != ent) then
			if (b:GetPos() == ent:GetPos()) then
				if (b:GetModel() == ent:GetModel()) then
					--if (b:GetAngles() == ent:GetAngles()) then
						ent:Remove()
					--end
				end
			end
		end
	end
end