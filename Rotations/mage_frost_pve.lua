--[[[
@rotation Frost Mage PvE
@class mage
@spec frost
@author SwollNMember
@description 
SimCraft 5.3
]]--

ma_fr = {}
-- Enemy Tracking
function ma_fr.rangedTarget()
	local rangedTarget = "target"
	if jps.canDPS("target") then 
		return "target"
	elseif jps.canDPS("focustarget") then 
		return "focustarget"
	elseif jps.canDPS("targettarget") then 
		return "targettarget"
	else
		local enemycount,targetcount = jps.RaidEnemyCount()
		local EnemyUnit = {}
		for name, index in pairs(jps.RaidTarget) do table.insert(EnemyUnit,index.unit) end
		if jps.canDPS(EnemyUnit[1]) then 
			return EnemyUnit[1] 
		else
			return "target" 
		end
	end
end

function ma_fr.hasRune()
	local hasOne,_ = GetTotemInfo(1)
	local hasSecond,_ = GetTotemInfo(2)
	if hasOne ~= false then 
		return true
	end
	if hasSecond ~= false then 
		return true
	end
	return false
end


function ma_fr.hasPet() 
	if UnitExists("pet") == nil then return false end
	return true
end

function ma_fr.kick(unit)
	return jps.shouldKick(unit) or jps.IsCastingPoly(unit)
end
ma_fr.invokersEnergy = select(1,GetSpellInfo(116257))
--[[[
@rotation Noxxic PvE
@class mage
@spec frost
@author Kirk24788
@description 
Based on Noxxic 5.3
]]--

jps.registerStaticTable("MAGE","FROST",{
	-- Noxxic
	-- pre fight
	{ "Summon Water Elemental", 'ma_fr.hasPet() == false and not jps.Moving'},
	{ "slow fall", 'IsFalling()==1 and not jps.buff("slow fall")' },
	{ "arcane brilliance", 'not jps.buff("arcane brilliance")' }, 
	{ "frost armor", 'not jps.buff("frost armor")' }, 
	{ "ice barrier", 'not jps.buff("ice barrier")' }, 
	{ "Freeze",	'IsAltKeyDown() ~= nil' },
	{ "rune of power", 'IsLeftShiftKeyDown() ~= nil and GetCurrentKeyBoardFocus() == nil and jps.IsSpellKnown("Rune of Power")'}, 
	{ "mirror image", 'jps.UseCDs'}, 
	

	-- Remove Snares, Roots, Loss of Control, etc.
	{ "every man for himself", 'jps.LoseControl(player,"CC")' },
	-- Kicks, Crowd Control, etc.
	{ "counterspell", 'ma_fr.kick(ma_fr.rangedTarget())' , ma_fr.rangedTarget },
	
	{ {"macro","/use Mana Gem"}, 'jps.mana() < 0.70 and GetItemCount("Manaa Gem", 0, 1) > 0' }, 
	{ {"macro","/cast icy veins\n/cast evocation"}, 'jps.hp() <= 0.4 and jps.cooldown("icy veins") == 0 and jps.cooldown("evocation") == 0 and not jps.Moving'  },
    { jps.useBagItem(5512), 'jps.hp("player") < 0.7' }, -- Healthstone
	
	-- Rotation ALL
	{ "nether tempest", 'jps.myDebuffDuration("nether tempest", "target") < 1' }, 
	{ "nether tempest", 'jps.myDebuffDuration("nether tempest","mouseover") < 2 and jps.canDPS("mouseover")',"mouseover"},
	{ "living bomb", 'not jps.myDebuff("living bomb","target")'},
	{ "living bomb", 'not jps.myDebuff("living bomb","mouseover") and jps.canDPS("mouseover")',"mouseover"},
	{ "frost bomb", 'not jps.myDebuff("frost bomb","mouseover") and not jps.Moving'},
	{ "frost bomb", 'not jps.myDebuff("frost bomb","mouseover") and not jps.Moving and jps.canDPS("mouseover")',"mouseover"},

	{ "nested", 'jps.buffDuration(ma_fr.invokersEnergy) < 6 and not jps.Moving and jps.LastCast ~= "Evocation" and jps.IsSpellKnown("Invocation")',{
		{ "Evocation", 'jps.myDebuffDuration("frost bomb","target") > 5'},
		{ "Evocation", 'jps.myDebuffDuration("living bomb","target") > 5'},
		{ "Evocation", 'jps.myDebuffDuration("nether tempest","target") > 5'},
	}},
	
	-- Rotation AoE
	{ "freeze", 'IsShiftKeyDown() ~= nil and GetCurrentKeyBoardFocus() == nil and jps.MultiTarget' }, 
	{ "flamestrike", 'IsShiftKeyDown() ~= nil and GetCurrentKeyBoardFocus() == nil and jps.MultiTarget' }, 
	{ "frozen orb", 'jps.MultiTarget' }, 
	{ "arcane explosion", 'jps.MultiTarget' }, 
	
	-- Rotation Single
	{ "mirror image",'jps.UseCDs'}, 
	{ "frozen orb", 'not jps.buff("fingers of frost")'}, 
	{ "icy veins", 'jps.buff("brain freeze")'}, 
	{ "icy veins", 'jps.buff("fingers of frost")'}, 
	{ "icy veins", 'jps.TimeToDie("target") <22 and not jps.Moving'}, 
	{ "berserking", 'jps.buff("icy veins") or jps.TimeToDie("target") < 18 and jps.UseCDs'}, 
	{ "jade serpent potion", 'jps.buff("icy veins") or jps.TimeToDie("target") <45'}, 
	{ "presence of mind", 'jps.buff("icy veins") or jps.cooldown("icy veins") >15 or jps.TimeToDie("target") <15'}, 
	{ "alter time", 'not jps.buff("alter time") and jps.buff("icy veins") and jps.UseCDs'}, 
	{ "frostfire bolt", 'jps.buff("alter time") and jps.buff("brain freeze")' }, 
	{ "ice lance", 'jps.buff("alter time") and jps.buff("fingers of frost")' }, 
	
	{ "frostfire bolt", 'jps.buff("brain freeze") and jps.cooldown("icy veins") > 2' }, 
	{ "ice lance", 'jps.buff("fingers of frost")' }, 
	{ "frostbolt" , 'not jps.Moving' }, 
	{ "fire blast", 'jps.Moving'}, 
	{ "ice lance", 'jps.Moving'}, 
},"Noxxic PvE",true,false)
