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
        if ent:GetClass() == "gbrp_shop" and ent:GetGang() == self.name then table.insert(shops,ent:GetShopName()) end
    end
    return shops
end
function gbrp_gang:GetProperties()
    local propertylist = {}
    for k,v in pairs(gbrp.doors) do
        local door = ents.GetByIndex(k)
        if door:getDoorData().groupOwn == self.name and gbrp.doors[k].typ ~= "shop" then
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
    ["1 MAPPLE RD"] = {doors = {2237,2236,2240,2243,2244,2246},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 MAPPLE RD",typ = "house"}};
    ["2 MAPPLE RD"] = {doors = {2261,2245,2264,2265,2263,2262},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "2 MAPPLE RD",typ = "house"}};
    ["3 MAPPLE RD"] = {doors = {2268,2271,2272,2270,2269,2267},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "3 MAPPLE RD",typ = "house"}};
    ["4 MAPPLE RD"] = {doors = {2238,2277,2278,4875,2276,2274},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "4 MAPPLE RD",typ = "house"}};
    ["5 MAPPLE RD"] = {doors = {2313,2318,2319,2317,2316,2314},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "5 MAPPLE RD",typ = "house"}};
    ["6 MAPPLE RD"] = {doors = {2414,2409,4876,4873,2410,2239},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "6 MAPPLE RD",typ = "house"}};
    ["7 MAPPLE RD"] = {doors = {2286,2288,2291,2290,2289,2287},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "7 MAPPLE RD",typ = "house"}};
    ["8 MAPPLE RD"] = {doors = {2534,2304,2307,2306,2305,2287},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "8 MAPPLE RD",typ = "house"}};
    ["9 MAPPLE RD"] = {doors = {2509,2417,4874,4877,2416,2415},owner = "gang",locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "9 MAPPLE RD",typ = "house"}};
    ["armory"] = {doors = {2608,2610,2609},owner = nil,locked = false,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "armory",typ = "shop"}};
    ["bar"] = {doors = {2712,2742,2779,2771,2744},owner = nil,locked = false,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "bar",typ = "shop"}};
    ["NYPD open"] = {doors = {2791,2790},owner = "NYPD",locked = false,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "NYPD open",typ = "NYPD"}};
    ["NYPD closed"] = {doors = {2792,2793,2811,4200,2806,2808,2807,2875,2796,2797,2846,2847,2845,2849,2844,2848,2824,2822,2819,2812,2798,2917,2918,2916,2915,2801,2853,2802,2803,2809,2810},owner = "NYPD",locked = true,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "NYPD closed",typ = "NYPD"}};
    ["Caserne des pompiers"] = {doors = {2214,2227,2226,2213},owner = "NYPD",locked = true,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "Caserne des pompiers",typ = "NYPD"}};
    ["Hangar HAVITURE WAY"] = {doors = {2002,2001},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "Hangar HAVITURE WAY",typ = "hangar"}};
    ["1 LE GRANDE"] = {doors = {3569,3574},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 LE GRANDE",typ = "appartment"}};
    ["2 LE GRANDE"] = {doors = {3600,3577},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "2 LE GRANDE",typ = "appartment"}};
    ["3 LE GRANDE"] = {doors = {3601,3583},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "3 LE GRANDE",typ = "appartment"}};
    ["4 LE GRANDE"] = {doors = {3602,3581},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "4 LE GRANDE",typ = "appartment"}};
    ["5 LE GRANDE"] = {doors = {3603,3560},owner = "yakuzas",locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "5 LE GRANDE",typ = "appartment"}};
    ["6 LE GRANDE"] = {doors = {3604,3565},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "5 LE GRANDE",typ = "appartment"}};
}
doorscount = 0
for i,doorgroup in pairs(gbrp.doorgroups) do
    for j,door in pairs(doorgroup.doors) do
        doorscount = doorscount + 1
    end
end