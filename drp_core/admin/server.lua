---------------------------------------------------------------------------
--- Functions
---------------------------------------------------------------------------
function DoesRankHavePerms(rank, perm)
    local playerRank = string.lower(rank)
    local playerPerms = DRPCoreConfig.StaffRanks.perms[playerRank]
    for a = 1, #playerPerms do
        if playerPerms[a] == perm then
            return true
        end
    end
    return false
end
