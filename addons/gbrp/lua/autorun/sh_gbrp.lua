gbrp = {}
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
function gbrp.formatMoney(n)
    if not n then return "$0" end

    if n >= 1e14 then return "$" .. tostring(n) end
    if n <= -1e14 then return "-" .. "$" .. tostring(math.abs(n)) end

    local negative = n < 0

    n = tostring(math.abs(n))
    local dp = string.find(n, "%.") or #n + 1

    for i = dp - 4, 1, -3 do
        n = n:sub(1, i) .. "." .. n:sub(i + 1)
    end

    -- Make sure the amount is padded with zeroes
    if n[#n - 1] == "." then
        n = n .. "0"
    end

    return (negative and "-" or "") .. "$" .. n
end
gbrp.doorgroups = {
    ["1 Mapple Rd"] = {doors = {2237,2236,2240,2243,2244,2246},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 Mapple Rd",typ = "house"}};
    ["2 Mapple Rd"] = {doors = {2261,2245,2264,2265,2263,2262},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "2 Mapple Rd",typ = "house"}};
    ["3 Mapple Rd"] = {doors = {2268,2271,2272,2270,2269,2267},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "3 Mapple Rd",typ = "house"}};
    ["4 Mapple Rd"] = {doors = {2238,2277,2278,4875,2276,2274},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "4 Mapple Rd",typ = "house"}};
    ["5 Mapple Rd"] = {doors = {2313,2318,2319,2317,2316,2314},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "5 Mapple Rd",typ = "house"}};
    ["6 Mapple Rd"] = {doors = {2414,2409,4876,4873,2410,2239},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "6 Mapple Rd",typ = "house"}};
    ["7 Mapple Rd"] = {doors = {2286,2288,2291,2290,2289,2287},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "7 Mapple Rd",typ = "house"}};
    ["8 Mapple Rd"] = {doors = {2534,2304,2307,2306,2305,2287},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "8 Mapple Rd",typ = "house"}};
    ["9 Mapple Rd"] = {doors = {2509,2417,4874,4877,2416,2415},owner = "gang",locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "9 Mapple Rd",typ = "house"}};
    ["armory"] = {doors = {2608,2610,2609},owner = nil,locked = false,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "armory",typ = "shop"}};
    ["bar"] = {doors = {2712,2742,2779,2771,2744},owner = nil,locked = false,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "bar",typ = "shop"}};
    ["NYPD open"] = {doors = {2791,2790},owner = "NYPD",locked = false,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "NYPD open",typ = "NYPD"}};
    ["NYPD closed"] = {doors = {2792,2793,2811,4200,2806,2808,2807,2875,2796,2797,2846,2847,2845,2849,2844,2848,2824,2822,2819,2812,2798,2917,2918,2916,2915,2801,2853,2802,2803,2809,2810},owner = "NYPD",locked = true,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "NYPD closed",typ = "NYPD"}};
    ["Caserne des pompiers"] = {doors = {2214,2227,2226,2213},owner = "NYPD",locked = true,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "Caserne des pompiers",typ = "NYPD"}};
    ["1 Haviture Way"] = {doors = {2002,2001},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 Haviture Way",typ = "hangar"}};
    ["1 Grand Way"] = {doors = {3569,3574},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 Grand Way",typ = "appartment"}};
    ["2 Grand Way"] = {doors = {3600,3577},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "2 Grand Way",typ = "appartment"}};
    ["3 Grand Way"] = {doors = {3601,3583},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "3 Grand Way",typ = "appartment"}};
    ["4 Grand Way"] = {doors = {3602,3581},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "4 Grand Way",typ = "appartment"}};
    ["5 Grand Way"] = {doors = {3603,3560},owner = "yakuzas",locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "5 Grand Way",typ = "appartment"}};
    ["6 Grand Way"] = {doors = {3604,3565},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "6 Grand Way",typ = "appartment"}};
    ["1 River Rd"] = {doors = {2033},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 River Rd",typ = "garage"}};
    ["2 River Rd"] = {doors = {2034},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "2 River Rd",typ = "garage"}};
    ["3 River Rd"] = {doors = {2030},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "3 River Rd",typ = "garage"}};
    ["4 River Rd"] = {doors = {2000},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "4 River Rd",typ = "garage"}};
    ["5 River Rd"] = {doors = {2032},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "5 River Rd",typ = "garage"}};
    ["6 River Rd"] = {doors = {2031},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "6 River Rd",typ = "garage"}};
    ["7 River Rd"] = {doors = {2035},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "7 River Rd",typ = "garage"}};
    ["8 River Rd"] = {doors = {2036},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "8 River Rd",typ = "garage"}};
    ["NYPD Hangar"] = {doors = {2018,2008,2007,2555,2302,2301,2019 },owner = "NYPD",locked = true,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "NYPD Hangar",typ = "NYPD"}};
    ["10 River Rd"] = {doors = {2005,2004,2220,2221},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "10 River Rd",typ = "hangar"}};
    ["11 River Rd"] = {doors = {2021},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "11 River Rd",typ = "house"}};
    ["1 Any Way"] = {doors = {3852,3867},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 Any Way",typ = "appartment"}};
    ["2 Any Way"] = {doors = {3849,3861},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "2 Any Way",typ = "appartment"}};
    ["3 Any Way"] = {doors = {3848,3859},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "3 Any Way",typ = "appartment"}};
    ["4 Any Way"] = {doors = {3840,3844},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "4 Any Way",typ = "appartment"}};
    ["5 Any Way"] = {doors = {3845,2341},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "5 Any Way",typ = "appartment"}};
    ["6 Any Way"] = {doors = {3851,3865},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "6 Any Way",typ = "appartment"}};
    ["7 Any Way"] = {doors = {3847,3857},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "7 Any Way",typ = "appartment"}};
    ["8 Any Way"] = {doors = {3850,3863},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "8 Any Way",typ = "appartment"}};
    ["9 Any Way"] = {doors = {3839,3842},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "9 Any Way",typ = "appartment"}};
    ["10 Any Way"] = {doors = {3846,3855},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "10 Any Way",typ = "appartment"}};
    ["12 Any Way"] = {doors = {2011,2010},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "11 Any Way",typ = "hangar"}};
    ["13 Any Way"] = {doors = {2052,2013,2051},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "12 Any Way",typ = "hangar"}};
    ["hardwarestore"] = {doors = {2049,2571,2570},owner = nil,locked = false,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "hardwarestore",typ = "shop"}};
    ["gasstation"] = {doors = {2111,2112,2113},owner = nil,locked = false,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "gasstation",typ = "shop"}};
    ["14 Any Way"] = {doors = {1290,1291,1288,1289,2231,2299},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "14 Any Way",typ = "hangar"}};
    ["nightclub"] = {doors = {2100,2101,3539,3466,3465,3546,3545,3551,3468,3481},owner = nil,locked = false,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "nightclub",typ = "shop"}};
    ["1 Pleasant Rd"] = {doors = {2699,2698,2700},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 Pleasant Rd",typ = "hangar"}};
    ["1 South St"] = {doors = {2025,2026,2027,2170},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 South St",typ = "hangar"}};
    ["bank"] = {doors = {3114,3115},owner = nil,locked = true,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "bank",typ = "shop"}};
    ["1 Bank St"] = {doors = {2707,2706,2708},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 Bank St",typ = "hangar"}};
    ["6-1 Crooked Ln"] = {doors = {3258},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "6-1 Crooked Ln",typ = "hugetower"}};
    ["6-2 Crooked Ln"] = {doors = {3257},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "6-2 Crooked Ln",typ = "hugetower"}};
    ["8-1 Crooked Ln"] = {doors = {3264},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "8-1 Crooked Ln",typ = "hugetower"}};
    ["8-2 Crooked Ln"] = {doors = {3265},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "8-2 Crooked Ln",typ = "hugetower"}};
    ["10-1 Crooked Ln"] = {doors = {3268},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "10-1 Crooked Ln",typ = "hugetower"}};
    ["10-2 Crooked Ln"] = {doors = {3269},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "10-2 Crooked Ln",typ = "hugetower"}};
    ["12 Crooked Ln"] = {doors = {3298,3305},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "12 Crooked Ln",typ = "hugetower"}};
    ["jewelry"] = {doors = {2050,2195,2059},owner = nil,locked = false,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "jewelry",typ = "shop"}};
    ["A Union Sq"] = {doors = {3135,3137,3136},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "A Union Sq",typ = "appartment"}};
    ["B Union Sq"] = {doors = {3138,3139,3140},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "B Union Sq",typ = "appartment"}};
    ["C Union Sq"] = {doors = {3132,3133,3134},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "C Union Sq",typ = "appartment"}};
    ["D Union Sq"] = {doors = {3130,3131,2956},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "D Union Sq",typ = "appartment"}};
    ["E Union Sq"] = {doors = {3002,3004,3003},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "E Union Sq",typ = "appartment"}};
    ["F Union Sq"] = {doors = {1358,1359,1360},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "F Union Sq",typ = "appartment"}};
    ["G Union Sq"] = {doors = {1353,1354,1355},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "G Union Sq",typ = "appartment"}};
    ["H Union Sq"] = {doors = {1356,2957,1357},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "H Union Sq",typ = "appartment"}};
    ["I Union Sq"] = {doors = {2997,3001,3000},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "I Union Sq",typ = "appartment"}};
    ["J Union Sq"] = {doors = {1361,1362,1363},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "J Union Sq",typ = "appartment"}};
    ["K Union Sq"] = {doors = {1364,1366,1365},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "K Union Sq",typ = "appartment"}};
    ["L Union Sq"] = {doors = {1367,2958,1368},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "L Union Sq",typ = "appartment"}};
    ["1 New Life St"] = {doors = {1958,2372,2363},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 New Life St",typ = "garage"}};
    ["2 New Life St"] = {doors = {2044,2373,2364},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "2 New Life St",typ = "garage"}};
    ["3 New Life St"] = {doors = {2046,2376,2055},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "3 New Life St",typ = "garage"}};
    ["Mairie open"] = {doors = {3008,3007},owner = nil,locked = false,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "Mairie open",typ = "garage"}};
    ["Mairie closed"] = {doors = {3018,3019},owner = nil,locked = true,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "Mairie closed",typ = "garage"}};
    ["archivist"] = {doors = {2047,2380,2054},owner = nil,locked = false,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "archivist",typ = "shop"}};
    ["1 13th St"] = {doors = {1964,1965,1300},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 13th St",typ = "appartment"}};
    ["2 13th St"] = {doors = {2259,2260,1296},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "2 13th St",typ = "appartment"}};
    ["3 13th St"] = {doors = {2257,2258,1295},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "3 13th St",typ = "appartment"}};
    ["4 13th St"] = {doors = {1969,1299,1968},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "4 13th St",typ = "appartment"}};
    ["5 13th St"] = {doors = {2256,2255,1293},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "5 13th St",typ = "appartment"}};
    ["6 13th St"] = {doors = {1970,1298,1972},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "6 13th St",typ = "appartment"}};
    ["7 13th St"] = {doors = {1977,1978,1294},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "7 13th St",typ = "appartment"}};
    ["8 13th St"] = {doors = {1971,1297,1973},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "8 13th St",typ = "appartment"}};
    ["9 13th St"] = {doors = {2048,2381,2053},owner = nil,locked = true,attributes = {buyable = true,price = 10000,value = 8000,doorgroup = "1 13th St",typ = "garage"}};
    ["garage"] = {doors = {2060,2062,2066,2061,2067,2065},owner = nil,locked = false,attributes = {buyable = false,price = 10000,value = 8000,doorgroup = "garage",typ = "shop"}};
}
gbrp.doors = {}
if SERVER then
    hook.Add("InitPostEntity","GBRP::DoorsInit",function()
        gbrp.doors = {}
        for doorgroupname,doorgroup in pairs(gbrp.doorgroups) do
            for _,door in pairs(doorgroup.doors) do
                local ent = ents.GetMapCreatedEntity(door)
                if not IsValid(ent) then print(door) end
                ent:setDoorGroup(doorgroup.owner)
                if doorgroup.locked then
                    ent:Fire("lock", "", 0)
                end
                ent.groupname = doorgroupname
                gbrp.doors[ent:EntIndex()] = doorgroup.attributes
            end
        end
    end)
    hook.Add("PlayerInitialSpawn","GBRP:DoorsInitCS",function(ply)
        timer.Simple(4, function()
            net.Start("GBRP::doorsinit")
            for k,v in pairs(gbrp.doors) do
                net.WriteInt(k,32)
                net.WriteTable(v)
            end
            net.Send(ply)
        end)
    end)
end
if CLIENT then
    gbrp.gangpanel = {}
    gbrp.gangpanel.properties = {
        ["house"] = {mat = Material("gui/gbrp/gangpanel/house.png"),x = 12,y = 30},
        ["appartment"] = {mat = Material("gui/gbrp/gangpanel/appartment.png"),x = 10,y = 14},
        ["hangar"] = {mat = Material("gui/gbrp/gangpanel/hangar.png"),x = 7,y = 10},
        ["hugetower"] = {mat = Material("gui/gbrp/gangpanel/hugetower.png"),x = 18,y = 11},
        ["garage"] = {mat = Material("gui/gbrp/gangpanel/garage.png"),x = 5,y = 29},
    }
    gbrp.gangpanel.shops = {
        ["gasstation"] = {mat = Material("gui/gbrp/gangpanel/gasstation.png"),x = 10,y = 10},
        ["hardwarestore"] = {mat = Material("gui/gbrp/gangpanel/saw.png"),x = 15,y = 5},
        ["jewelry"] = {mat = Material("gui/gbrp/gangpanel/diamond.png"),x = 5,y = 9},
        ["garage"] = {mat = Material("gui/gbrp/gangpanel/tire.png"),x = 6,y = 7},
        ["pharmacy"] = {mat = Material("gui/gbrp/gangpanel/pharmacy.png"),x = 8,y = 10},
        ["bar"] = {mat = Material("gui/gbrp/gangpanel/beer.png"),x = 15,y = 7},
        ["nightclub"] = {mat = Material("gui/gbrp/gangpanel/cocktail.png"),x = 7,y = 7},
        ["armory"] = {mat = Material("gui/gbrp/gangpanel/gun.png"),x = 7,y = 17},
    }
    gbrp.voices = {
        female = {
            "npc/female_speech_1.wav",
            "npc/female_speech_2.wav"
        };
        male = {
            "npc/male_speech_1.wav"
        };
    }
    doorscount = 0
    for i,doorgroup in pairs(gbrp.doorgroups) do
        for j,door in pairs(doorgroup.doors) do
            doorscount = doorscount + 1
        end
    end
end

local gang = {}
local plyMeta = FindMetaTable("Player")

function gang:GetMembersCount()
    local count = 0
    for _,ply in pairs(player.GetAll()) do
        if gbrp.jobs[team.GetName(ply:Team())].gang == self.name then count = count + 1 end
    end
    return count
end
function gang:GetShops()
    local shops = {}
    for _,ent in pairs(ents.GetAll()) do
        if ent:GetClass() == "gbrp_shop" and ent:GetGang() == self then table.insert(shops,ent:GetShopName()) end
    end
    return shops
end
function gang:GetProperties()
    local propertylist = {}
    for k,v in pairs(gbrp.doors) do
        local door = ents.GetByIndex(k)
        if door:getDoorData().groupOwn == self.name and gbrp.doors[k].typ ~= "shop" then
            propertylist[gbrp.doors[k].doorgroup] = gbrp.doors[k].typ
        end
    end
    return propertylist
end
function gang:GetBalance()
    return GetGlobalInt(self.name .. "Balance")
end
function gang:GetExpenses()
    return GetGlobalInt(self.name .. "Expenses")
end
function gang:GetEarnings()
    return GetGlobalInt(self.name .. "Earnings")
end
function gang:CanAfford(amount)
    return self:GetBalance() - amount >= 0
end
function plyMeta:IsGangChief()
    return gbrp.jobs[team.GetName(self:Team())].gangChief;
end
function plyMeta:GetGang()
    return gbrp[gbrp.jobs[team.GetName(self:Team())].gang];
end
function plyMeta:GetBalance()
    return self:GetNWInt("GBRP::balance")
end
function plyMeta:CanAfford(amount)
    return self:GetBalance() - amount >= 0;
end
if SERVER then
    function gang:AddEarnings(amount)
        SetGlobalInt(self.name .. "Earnings",self:GetEarnings() + amount)
    end
    function gang:AddExpenses(amount)
        SetGlobalInt(self.name .. "Expenses",self:GetExpenses() + amount)
    end
    function gang:SetBalance(val)
        SetGlobalInt(self.name .. "Balance",val)
    end
    function gang:Cash(amount)
        self:SetBalance(self:GetBalance() + amount)
        self:AddEarnings(amount)
    end
    function gang:Pay(amount)
        self:SetBalance(self:GetBalance() - amount)
        self:AddExpenses(amount)
    end
    function gang:Reset()
        for k,v in pairs(gbrp.doors) do
            local door = ents.GetByIndex(k)
            if door:getDoorData().groupOwn == self.name and gbrp.doorgroups[gbrp.doors[k].doorgroup].owner ~= self.name then
                door:setDoorGroup(nil)
            end
        end
        local shops = ents.FindByClass("gbrp_shop")
        for i,shop in pairs(shops) do
            if shop:GetGang() == self then
                shop:SetGang(nil)
            end
        end
        gang:SetBalance(100000)
    end
    function plyMeta:AddLaunderedMoney(amount)
        self:SetNWInt("GBRP::launderedmoney", self:GetNWInt("GBRP::launderedmoney") + amount)
    end
    function plyMeta:Cash(pay)
        self:SetNWInt("GBRP::balance",self:GetBalance() + pay);
        sql.Query("update gbrp set balance = " .. self:GetNWInt("GBRP::balance") .. " where steamid64 = " .. self:SteamID64() .. ";");
    end
    function plyMeta:Pay(amount)
        self:SetNWInt("GBRP::balance",self:GetBalance() - amount);
        sql.Query("update gbrp set balance = " .. self:GetNWInt("GBRP::balance") .. " where steamid64 = " .. self:SteamID64() .. ";");
    end
end
gbrp.yakuzas = {
    subject = "Les yakuzas",
    name = "yakuzas"
}
table.Merge(gbrp.yakuzas,gang)
gbrp.mafia = {
    subject = "La Mafia",
    name = "mafia"
}
table.Merge(gbrp.mafia,gang)
gbrp.gang = {
    subject = "Les gangsters",
    name = "gang"
}
table.Merge(gbrp.gang,gang)