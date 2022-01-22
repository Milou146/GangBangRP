gbrp = {}
local gbrp_gang = {}
function gbrp_gang:GetMembersCount()
    local count = 0
    for _,ply in pairs(player.GetAll()) do
        if gbrp.jobs[team.GetName(ply:Team())].gang == self.name then count = count + 1 end
    end
    return count
end
function gbrp_gang:GetShops()
    local shops = {}
    for _,ent in pairs(ents.GetAll()) do
        if ent:GetClass() == "gbrp_shop" and ent:GetGang() == self.name then table.insert(shops,ent:GetName()) end
    end
    return shops
end
function gbrp_gang:GetProperties()
    local propertylist = {}
    for k,v in pairs(gbrp.doors) do
        local door = ents.GetByIndex(k)
        if door:getDoorData().groupOwn == self.subject then
            propertylist[gbrp.doors[k].doorgroup] = gbrp.doors[k].typ
        end
    end
    return propertylist
end
function gbrp_gang:GetBalance()
    return GetGlobalInt(self.name .. "Balance")
end
function gbrp_gang:GetExpenses()
    return GetGlobalInt(self.name .. "Expenses")
end
function gbrp_gang:GetEarnings()
    return GetGlobalInt(self.name .. "Earnings")
end
gbrp.yakuzas = {
    subject = "Les yakuzas",
    name = "yakuzas"
}
table.Merge(gbrp.yakuzas,gbrp_gang)
gbrp.mafia = {
    subject = "La Mafia",
    name = "mafia"
}
table.Merge(gbrp.mafia,gbrp_gang)
gbrp.gang = {
    subject = "Les gangsters",
    name = "gang"
}
table.Merge(gbrp.gang,gbrp_gang)

gbrp.jobs = {
    ["Citoyen"] = {gang = nil,gangChief = nil};
    ["N.Y.P.D"] = {gang = nil,gangChief = nil};
    ["S.W.A.T"] = {gang = nil,gangChief = nil};
    ["S.W.A.T Médic"] = {gang = nil,gangChief = nil};
    ["S.W.A.T Sniper"] = {gang = nil,gangChief = nil};
    ["Chef des Yakuzas"] = {gang = "yakuzas",gangChief = true};
    ["Yakuza"] = {gang = "yakuzas",gangChief = false};
    ["Yakuza Architecte"] = {gang = "yakuzas",gangChief = false};
    ["Yakuza Médecin"] = {gang = "yakuzas",gangChief = false};
    ["Parrain"] = {gang = "mafia",gangChief = true};
    ["Mafieux"] = {gang = "mafia",gangChief = false};
    ["Mafieux Architecte"] = {gang = "mafia",gangChief = false};
    ["Mafieux Médecin"] = {gang = "mafia",gangChief = false};
    ["Chef Gangster"] = {gang = "gang",gangChief = true};
    ["Gangster"] = {gang = "gang",gangChief = false};
    ["Gangster Architecte"] = {gang = "gang",gangChief = false};
    ["Gangster Médecin"] = {gang = "gang",gangChief = false};
    ["STAFF"] = {gang = nil,gangChief = nil};
    ["YAMAKASI"] = {gang = nil,gangChief = nil};
    ["Chauffeur de taxi"] = {gang = nil,gangChief = nil};
    ["Vendeur hot dog"] = {gang = nil,gangChief = nil};
    ["Hacker"] = {gang = nil,gangChief = nil};
    ["Agent secret"] = {gang = nil,gangChief = nil};
    ["Vendeur d'amres ambulant"] = {gang = nil,gangChief = nil};
    ["Tueur à gage"] = {gang = nil,gangChief = nil};
}
gbrp.doors = {}

local plyMeta = FindMetaTable("Player")

function plyMeta:IsGangChief()
    return gbrp.jobs[team.GetName(self:Team())].gangChief
end

function plyMeta:GetGang()
    return gbrp.jobs[team.GetName(self:Team())].gang
end

gbrp.doorgroups = {
    ["1 MAPPLE RD"] = {doors = {2237,2236,2240,2243,2244,2246},owner = "nobody",locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 MAPPLE RD",typ = "house"}};
    ["2 MAPPLE RD"] = {doors = {2261,2245,2264,2265,2263,2262},owner = "nobody",locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "2 MAPPLE RD",typ = "house"}};
    ["3 MAPPLE RD"] = {doors = {2268,2271,2272,2270,2269,2267},owner = "nobody",locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "3 MAPPLE RD",typ = "house"}};
    ["4 MAPPLE RD"] = {doors = {2238,2277,2278,4875,2276,2274},owner = "nobody",locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "4 MAPPLE RD",typ = "house"}};
    ["5 MAPPLE RD"] = {doors = {2313,2318,2319,2317,2316,2314},owner = "nobody",locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "5 MAPPLE RD",typ = "house"}};
    ["6 MAPPLE RD"] = {doors = {2414,2409,4876,4873,2410,2239},owner = "nobody",locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "6 MAPPLE RD",typ = "house"}};
    ["7 MAPPLE RD"] = {doors = {2286,2288,2291,2290,2289,2287},owner = "nobody",locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "7 MAPPLE RD",typ = "house"}};
    ["8 MAPPLE RD"] = {doors = {2534,2304,2307,2306,2305,2287},owner = "nobody",locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "8 MAPPLE RD",typ = "house"}};
    ["9 MAPPLE RD"] = {doors = {2509,2417,4874,4877,2416,2415},owner = "gang",locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "9 MAPPLE RD",typ = "house"}};
}