gbrp = {}
local gbrp_gang = {}
function gbrp_gang:GetWorkforce()
    local count = 0
    for _,ply in pays(player.GetAll()) do
        if gbrp.jobs[team.GetName(ply:Team())].gang == tostring(self) then count = count + 1 end
    end
    return count
end
function gbrp_gang:GetShops()
    local shops = {}
    for _,ent in pays(ents.GetAll()) do
        if ent:GetClass() == "gbrp_shop" and ent:GetGang() == tostring(self) then table.insert(shops,ent:GetName()) end
    end
    return shops
end
function gbrp_gang:GetPropertiesNb()
    return 0
end
function gbrp_gang:GetBalance()
    return GetGlobalInt(tostring(self) .. "Balance")
end
function gbrp_gang:GetExpenses()
    return GetGlobalInt(tostring(self) .. "Expenses")
end
function gbrp_gang:GetEarnings()
    return GetGlobalInt(tostring(self) .. "Earnings")
end
gbrp.yakuzas = {
    subject = "Les yakuzas"
}
table.Add(gbrp.yakuzas,gbrp_gang)
gbrp.mafia = {
    subject = "La Mafia"
}
table.Add(gbrp.mafia,gbrp_gang)
gbrp.gang = {
    subject = "Le Gang"
}
table.Add(gbrp.gang,gbrp_gang)

gbrp.jobs = {
    ["Citoyen"] = {gang = "nil",gangChief = nil};
    ["N.Y.P.D"] = {gang = "nil",gangChief = nil};
    ["S.W.A.T"] = {gang = "nil",gangChief = nil};
    ["S.W.A.T Médic"] = {gang = "nil",gangChief = nil};
    ["S.W.A.T Sniper"] = {gang = "nil",gangChief = nil};
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
    ["STAFF"] = {gang = "nil",gangChief = nil};
    ["YAMAKASI"] = {gang = "nil",gangChief = nil};
    ["Chauffeur de taxi"] = {gang = "nil",gangChief = nil};
    ["Vendeur hot dog"] = {gang = "nil",gangChief = nil};
    ["Hacker"] = {gang = "nil",gangChief = nil};
    ["Agent secret"] = {gang = "nil",gangChief = nil};
    ["Vendeur d'amres ambulant"] = {gang = "nil",gangChief = nil};
    ["Tueur à gage"] = {gang = "nil",gangChief = nil};
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
    ["1 MAPPLE RD"] = {doors = {2237,2236,2240,2243,2244,2246},owner = "nobody",attributes = {locked = true,buyable = true,price = 10000,value = 8000,doorgroup = "1 MAPPLE RD"}};
    ["2 MAPPLE RD"] = {doors = {2246,2245,2264,2265,2263,2262},owner = "nobody",attributes = {locked = true,buyable = true,price = 10000,value = 8000,doorgroup = "2 MAPPLE RD"}};
    ["3 MAPPLE RD"] = {doors = {2268,2271,2272,2270,2269,2267},owner = "nobody",attributes = {locked = true,buyable = true,price = 10000,value = 8000,doorgroup = "3 MAPPLE RD"}};
    ["4 MAPPLE RD"] = {doors = {2238,2277,2278,4875,2276,2274},owner = "nobody",attributes = {locked = true,buyable = true,price = 10000,value = 8000,doorgroup = "4 MAPPLE RD"}};
    ["5 MAPPLE RD"] = {doors = {2313,2318,2319,2317,2316,2314},owner = "nobody",attributes = {locked = true,buyable = true,price = 10000,value = 8000,doorgroup = "5 MAPPLE RD"}};
    ["6 MAPPLE RD"] = {doors = {2414,2409,4876,4873,2410,2239},owner = "nobody",attributes = {locked = true,buyable = true,price = 10000,value = 8000,doorgroup = "6 MAPPLE RD"}};
    ["7 MAPPLE RD"] = {doors = {2286,2288,2291,2290,2289,2287},owner = "nobody",attributes = {locked = true,buyable = true,price = 10000,value = 8000,doorgroup = "7 MAPPLE RD"}};
    ["8 MAPPLE RD"] = {doors = {2534,2304,2307,2306,2305,2287},owner = "nobody",attributes = {locked = true,buyable = true,price = 10000,value = 8000,doorgroup = "8 MAPPLE RD"}};
    ["9 MAPPLE RD"] = {doors = {2509,2417,4874,4877,2416,2415},owner = "gang",attributes = {locked = true,buyable = false,price = 10000,value = 8000,doorgroup = "9 MAPPLE RD"}};
}