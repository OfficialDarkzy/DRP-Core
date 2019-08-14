---------------------------------------------------------------------------
--- Functions
---------------------------------------------------------------------------
function DoesRankHavePerms(rank, perm)
    local playerPerms = DRPCoreConfig.StaffRanks.perms[rank]
    for a = 1, #playerPerms do
        if playerPerms[a] == perm then
            return true
        end
    end
    return false
end