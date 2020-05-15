---------------------------------------------------------------------------
-- Locales function
-- You need to add shared_script "@drp_core/locales.lua" under the manifest
-- of your resource
-----------------------------How to use -----------------------------------
-- local localeData = exports['drp_core']:GetLocalesData(resourceName)
-- if localeData then
--   local locale = Locales:Convert(localeData)
--   print(locale:GetValue('key'))
-- end
---------------------------------------------------------------------------
Locales = {}
Locales.__index = Locales

function Locales.New(locales)
	local newLocale = {}

	newLocale.Length = locales.Length
	newLocale.Languages = locales.Languages
	newLocale.Strings = locales.Strings
	newLocale.SelectedLanguage = locales.SelectedLanguage
	setmetatable(newLocale, Locales)

	return newLocale
end

function Locales:Convert(localesObject)
	return setmetatable(localesObject, Locales)
end

function Locales:GetLength()
	return self.Length
end

function Locales:GetLanguages()
	return self.Languages
end

function Locales:SetLanguage(language)
	local languageExist = false

	for k,v in pairs(self.Languages) do
		if v == language then languageExist = true end
	end

	if languageExist then
		self.SelectedLanguage = self.Strings[language]
		return ('The language has been set to %s'):format(language)
	else
		return ('The language %s does not exist'):format(language)
	end
end

function Locales:GetValue(key)
	return tostring(self.SelectedLanguage[key])
end