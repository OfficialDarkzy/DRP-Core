---------------------------------------------------------------------------
-- Global variable
---------------------------------------------------------------------------
DRP.Locales = {}

---------------------------------------------------------------------------
-- Add a locales file
---------------------------------------------------------------------------
function DRP.Locales:AddLocale(resourceName)
	local content = LoadResourceFile(resourceName, 'locales.json')
	
	-- Trying to be moron proof
	if content == nil then
		content = LoadResourceFile(resourceName, 'locale.json')
	end
	if content == nil then
		content = LoadResourceFile(resourceName, 'local.json')
	end
	
	if content ~= nil then
		local decoded = json.decode(content)
		local languages = {}
		local localLanguage = {}
		local languageExist = false
		local enExist = false
		
		for k in pairs(decoded) do
			if k == DRPCoreConfig.Language then 
				languageExist = true
			elseif k == 'en' then 
				enExist = true
			end
			table.insert(languages, k)
		end
		
		if languageExist then
			localLanguage = decoded[DRPCoreConfig.Language]
		elseif enExist then
			localLanguage = decoded.en
		else
			localLanguage = decoded[languages[1]]
		end
		
		local locales = Locales.New({Length = #languages, Languages = languages, Strings = decoded, SelectedLanguage = localLanguage})
		self[resourceName] = locales
		print(('^1[DRP] Local^0 :^4 locales.json file loaded for %s^0'):format(resourceName))
	end	
end

---------------------------------------------------------------------------
-- Remove a locales file
---------------------------------------------------------------------------
function DRP.Locales:RemoveLocale(resourceName)
	for k in pairs(self) do
		if k == resourceName then			
			print(('^1[DRP] Local^0 :^4 unloaded locales for %s^0'):format(resourceName))
			self[resourceName] = nil
		end
	end	
end

---------------------------------------------------------------------------
-- Get a locales file
---------------------------------------------------------------------------
function DRP.Locales:GetLocale(resourceName)
	return self[resourceName]
end

-- Export function
exports("GetLocalesData", function(resourceName)
	return DRP.Locales:GetLocale(resourceName)
end)