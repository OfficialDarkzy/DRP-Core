_G.exports.drp_core = {
    ---@param name string
    ---@param handler fun(cb: fun(...: any): void): void
    RegisterClientCallback = function(name, handler)

    end,

    ---@param target number
    ---@param name string
    ---@param cb fun(...: any): void
    ---@vararg
    TriggerClientCallback = function(target, name, cb, ...)

    end
}