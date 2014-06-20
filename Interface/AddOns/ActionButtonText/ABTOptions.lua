local addon = abtNS
local ABT_abouttext = '<HTML><BODY>\
<H1>|cff00ff00ActionButtonText (1.02)|r</H1>\
<H2>Created by &lt;Damage Inc&gt; of (EU)Draenor</H2>\
<P>EMail: damageinc@theedgeofthevoid.com</P>\
<BR/>\
<H1>|cffffff00Presets|r</H1>\
</BODY></HTML>'

function addon.prehash(name)
	if string.find(name,'#') then
		return name
	else
		return '#' .. name
	end
end

function addon.optclick(self)
	local to = 'PRESET' .. addon.prehash(self.spellname)

	if self:GetChecked() then
		if not ABT_SpellDB then
			ABT_SpellDB = {}
		end
		ABT_SpellDB[to] = {}
		for name,val in pairs(addon.presets[self.classname][self.spellname]) do
			ABT_SpellDB[to][name] = val
		end
	else
		ABT_SpellDB[to] = nil
	end
end

function addon.addopt(n,class,spellname,text)
	local optbtn = CreateFrame('CheckButton', 'obiopt'..n , _G['obiabout'], 'UICheckButtonTemplate')
	_G[optbtn:GetName() .. 'Text']:SetText(text)
	_G[optbtn:GetName() .. 'Text']:SetWidth(400)
	_G[optbtn:GetName() .. 'Text']:SetHeight(30)
	_G[optbtn:GetName() .. 'Text']:SetJustifyH('LEFT')
	optbtn:SetPoint('TOPLEFT', _G['obiabout'], 'BOTTOMLEFT', 0, -30 * (n - 1) + -40)
	optbtn.classname = class
	optbtn.spellname = spellname
	optbtn:SetScript('OnClick', addon.optclick)

	if ABT_SpellDB and ABT_SpellDB['PRESET'..addon.prehash(spellname)] then
		optbtn:SetChecked(true)
	end
end

function addon.optshow()
	local x = 1
	local optb = _G['obiopt'..x]

	while optb do
		if ABT_SpellDB and ABT_SpellDB['PRESET'..addon.prehash(optb.spellname)] then
			optb:SetChecked(true)
		else
			optb:SetChecked(false)
		end

		x = x + 1
		optb = _G['obiopt'..x]
	end
end