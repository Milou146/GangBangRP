if engine.ActiveGamemode() ~= "darkrp" then return end
----------------------------
---- G A N G -- M E T A ----
----------------------------

local gangMeta = {}
function gangMeta:GetMembersCount()
    local count = 0
    for _,ply in pairs(player.GetAll()) do
        if ply:GetGang() == self then count = count + 1 end
    end
    return count
end
function gangMeta:GetShops()
    local shops = {}
    for _,ent in pairs(ents.GetAll()) do
        if ent:GetClass() == "gbrp_shop" and ent:GetGang() == self then table.insert(shops,ent:GetShopName()) end
    end
    return shops
end
function gangMeta:GetProperties()
    local propertylist = {}
    for k,v in pairs(gbrp.doors) do
        local door = ents.GetByIndex(k)
        if door:getDoorData().groupOwn == self.name and gbrp.doors[k].typ ~= "shop" then
            propertylist[gbrp.doors[k].doorgroup] = gbrp.doors[k].typ
        end
    end
    return propertylist
end
function gangMeta:GetBalance()
    return GetGlobalInt(self.name .. "Balance")
end
function gangMeta:GetExpenses()
    return GetGlobalInt(self.name .. "Expenses")
end
function gangMeta:GetEarnings()
    return GetGlobalInt(self.name .. "Earnings")
end
function gangMeta:CanAfford(amount)
    return self:GetBalance() - amount >= 0
end
function gangMeta:GetPrivateDoorsCount()
    return GetGlobalInt(self.name .. "PrivateDoorsCount")
end
if SERVER then
    function gangMeta:AddEarnings(amount)
        SetGlobalInt(self.name .. "Earnings",self:GetEarnings() + amount)
    end
    function gangMeta:AddExpenses(amount)
        SetGlobalInt(self.name .. "Expenses",self:GetExpenses() + amount)
    end
    function gangMeta:SetBalance(val)
        SetGlobalInt(self.name .. "Balance",val)
    end
    function gangMeta:Cash(amount)
        self:SetBalance(self:GetBalance() + amount)
        self:AddEarnings(amount)
    end
    function gangMeta:Pay(amount)
        self:SetBalance(self:GetBalance() - amount)
        self:AddExpenses(amount)
    end
    function gangMeta:Reset()
        for k,v in pairs(gbrp.doors) do
            local door = ents.GetByIndex(k)
            if door:getDoorData().groupOwn == self.name and gbrp.doorgroups[gbrp.doors[k].doorgroup].owner ~= self.name then
                for _,doorid in pairs(gbrp.doorgroups[gbrp.doors[k].doorgroup].doors) do
                    door = ents.GetMapCreatedEntity(doorid)
                    door:setDoorGroup(nil)
                    if door:getDoorOwner() then
                        door:keysUnOwn(door:getDoorOwner())
                        self:AddPrivateDoor(-1)
                    end
                    door:Fire("lock", "", 0)
                end
            end
        end
        local shops = ents.FindByClass("gbrp_shop")
        for i,shop in pairs(shops) do
            if shop:GetGang() == self then
                shop:SetGang(nil)
            end
        end
    end
    function gangMeta:SetPrivateDoorsCount(count)
        return SetGlobalInt(self.name .. "PrivateDoorsCount",count)
    end
    function gangMeta:AddPrivateDoor(amount)
        self:SetPrivateDoorsCount(self:GetPrivateDoorsCount() + amount)
    end
end

--------------------------
---- P L Y -- M E T A ----
--------------------------

local plyMeta = FindMetaTable("Player")
function plyMeta:IsGangLeader()
    return self:getJobTable().gangLeader;
end
function plyMeta:GetGang()
    return self:getJobTable().gang;
end
function plyMeta:GetBalance()
    return self:GetNWInt("GBRP::balance")
end
function plyMeta:CanAfford(amount)
    return self:GetBalance() - amount >= 0;
end
if CLIENT then
    function plyMeta:BuyShop(shop)
        local gang = self:GetGang()
        if shop:GetGang() and shop:GetGang() ~= gang then
            GAMEMODE:AddNotify("Ce magasin appartient à un autre gang.",1,2)
        elseif shop:GetGang() == gang then
            GAMEMODE:AddNotify("Votre gang possède déjà le magasin.",0,2)
        elseif not self:IsGangLeader() then
            GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
        elseif not gang:CanAfford(shop.price) then
            GAMEMODE:AddNotify("Solde insuffisant.",1,2)
        elseif #gang:GetShops() >= 4 then
            GAMEMODE:AddNotify("Votre gang a atteint le nombre maximal de magasins en sa possession.",1,2)
        else
            net.Start("GBRP::buyshop")
            net.WriteEntity(shop)
            net.SendToServer()
            surface.PlaySound("gui/gbrp/buy_sell.mp3")
            GAMEMODE:AddNotify("Vous avez acheté le magasin.",0,2)
        end
    end
    function plyMeta:SellShop(shop)
        if self:IsGangLeader() then
            net.Start("GBRP::sellshop")
            net.WriteEntity(shop)
            net.SendToServer()
            surface.PlaySound("gui/gbrp/buy_sell.mp3")
            GAMEMODE:AddNotify("Vous avez vendu le magasin.",0,2)
        else
            GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
        end
    end
    function plyMeta:WithdrawLaunderedMoney(shop)
        if self:IsGangLeader() then
            net.Start("GBRP::shopwithdraw")
            net.WriteEntity(shop)
            net.SendToServer()
            surface.PlaySound("gui/gbrp/withdraw.wav")
            GAMEMODE:AddNotify("Vous avez retiré l'argent blanchis du magasin.",0,2)
        else
            GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
        end
    end
    function plyMeta:DropCash(frame)
        local textEntry = vgui.Create("DTextEntry",frame)
        textEntry:SetSize(200,25)
        textEntry:SetPlaceholderText("ex: 500")
        textEntry:Center()
        textEntry:RequestFocus()
        textEntry.OnEnter = function()
            local amount = tonumber(textEntry:GetValue())
            if amount > 0 and self:getDarkRPVar("money") - amount >= 0 then
                net.Start("GBRP::shopdeposit")
                net.WriteUInt(amount,32)
                net.WriteEntity(frame.shop)
                net.SendToServer()
                surface.PlaySound("gui/gbrp/dropcash.wav")
                GAMEMODE:AddNotify("Vous avez déposé " .. DarkRP.formatMoney( amount ) .. ".",0,2)
            elseif amount <= 0 then
                GAMEMODE:AddNotify("Valeur non valide.",1,2)
            else
                GAMEMODE:AddNotify("Solde insuffisant.",1,2)
            end
            textEntry:Remove()
        end
    end
end
if SERVER then
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

--------------------------
-- G B R P -- T A B L E --
--------------------------

gbrp = {}
gbrp.doors = {}
gbrp.startingFunds = 100000
gbrp.doorgroups = {
    ["1 Mapple Rd"] = {doors = {2237,2236,2240,2243,2244,2246},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "1 Mapple Rd",typ = "house"}};
    ["2 Mapple Rd"] = {doors = {2261,2245,2264,2265,2263,2262},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "2 Mapple Rd",typ = "house"}};
    ["3 Mapple Rd"] = {doors = {2268,2271,2272,2270,2269,2267},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "3 Mapple Rd",typ = "house"}};
    ["4 Mapple Rd"] = {doors = {2238,2277,2278,4875,2276,2274},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "4 Mapple Rd",typ = "house"}};
    ["5 Mapple Rd"] = {doors = {2313,2318,2319,2317,2316,2314},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "5 Mapple Rd",typ = "house"}};
    ["6 Mapple Rd"] = {doors = {2414,2409,4876,4873,2410,2239},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "6 Mapple Rd",typ = "house"}};
    ["7 Mapple Rd"] = {doors = {2286,2288,2291,2290,2289,2287},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "7 Mapple Rd",typ = "house"}};
    ["8 Mapple Rd"] = {doors = {2534,2304,2307,2306,2305,2287},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "8 Mapple Rd",typ = "house"}};
    ["9 Mapple Rd"] = {doors = {2509,2417,4874,4877,2416,2415},locked = true,attributes = {owner = "gang",buyable = true,price = 10000,value = 8000,doorgroup = "9 Mapple Rd",typ = "house"}};
    ["gunshop"] = {doors = {2608,2610,2609},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "armory",typ = "shop"}};
    ["bar"] = {doors = {2712,2742,2779,2771,2744},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "bar",typ = "shop"}};
    ["NYPD open"] = {doors = {2791,2790},locked = false,attributes = {owner = "NYPD",buyable = false,price = 10000,value = 8000,doorgroup = "NYPD open",typ = "NYPD"}};
    ["NYPD closed"] = {doors = {2792,2793,2811,4200,2806,2808,2807,2875,2796,2797,2846,2847,2845,2849,2844,2848,2824,2822,2819,2812,2798,2917,2918,2916,2915,2801,2853,2802,2803,2809,2810},locked = true,attributes = {owner = "NYPD",buyable = false,price = 10000,value = 8000,doorgroup = "NYPD closed",typ = "NYPD"}};
    ["Caserne des pompiers"] = {doors = {2214,2227,2226,2213},locked = true,attributes = {owner = "NYPD",buyable = false,price = 10000,value = 8000,doorgroup = "Caserne des pompiers",typ = "NYPD"}};
    ["1 Haviture Way"] = {doors = {2002,2001},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "1 Haviture Way",typ = "hangar"}};
    ["1 Grand Way"] = {doors = {3569,3574},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "1 Grand Way",typ = "appartment"}};
    ["2 Grand Way"] = {doors = {3600,3577},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "2 Grand Way",typ = "appartment"}};
    ["3 Grand Way"] = {doors = {3601,3583},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "3 Grand Way",typ = "appartment"}};
    ["4 Grand Way"] = {doors = {3602,3581},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "4 Grand Way",typ = "appartment"}};
    ["5 Grand Way"] = {doors = {3603,3560},locked = true,attributes = {owner = "yakuzas",buyable = true,price = 10000,value = 8000,doorgroup = "5 Grand Way",typ = "appartment"}};
    ["6 Grand Way"] = {doors = {3604,3565},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "6 Grand Way",typ = "appartment"}};
    ["1 River Rd"] = {doors = {2033},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "1 River Rd",typ = "garage"}};
    ["2 River Rd"] = {doors = {2034},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "2 River Rd",typ = "garage"}};
    ["3 River Rd"] = {doors = {2030},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "3 River Rd",typ = "garage"}};
    ["4 River Rd"] = {doors = {2000},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "4 River Rd",typ = "garage"}};
    ["5 River Rd"] = {doors = {2032},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "5 River Rd",typ = "garage"}};
    ["6 River Rd"] = {doors = {2031},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "6 River Rd",typ = "garage"}};
    ["7 River Rd"] = {doors = {2035},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "7 River Rd",typ = "garage"}};
    ["8 River Rd"] = {doors = {2036},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "8 River Rd",typ = "garage"}};
    ["NYPD Hangar"] = {doors = {2018,2008,2007,2555,2302,2301,2019 },locked = true,attributes = {owner = "NYPD",buyable = false,price = 10000,value = 8000,doorgroup = "NYPD Hangar",typ = "NYPD"}};
    ["10 River Rd"] = {doors = {2005,2004,2220,2221},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "10 River Rd",typ = "hangar"}};
    ["11 River Rd"] = {doors = {2021},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "11 River Rd",typ = "house"}};
    ["1 Any Way"] = {doors = {3852,3867},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "1 Any Way",typ = "appartment"}};
    ["2 Any Way"] = {doors = {3849,3861},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "2 Any Way",typ = "appartment"}};
    ["3 Any Way"] = {doors = {3848,3859},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "3 Any Way",typ = "appartment"}};
    ["4 Any Way"] = {doors = {3840,3844},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "4 Any Way",typ = "appartment"}};
    ["5 Any Way"] = {doors = {3845,2341},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "5 Any Way",typ = "appartment"}};
    ["6 Any Way"] = {doors = {3851,3865},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "6 Any Way",typ = "appartment"}};
    ["7 Any Way"] = {doors = {3847,3857},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "7 Any Way",typ = "appartment"}};
    ["8 Any Way"] = {doors = {3850,3863},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "8 Any Way",typ = "appartment"}};
    ["9 Any Way"] = {doors = {3839,3842},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "9 Any Way",typ = "appartment"}};
    ["10 Any Way"] = {doors = {3846,3855},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "10 Any Way",typ = "appartment"}};
    ["12 Any Way"] = {doors = {2011,2010},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "11 Any Way",typ = "hangar"}};
    ["13 Any Way"] = {doors = {2052,2013,2051},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "12 Any Way",typ = "hangar"}};
    ["hardwarestore"] = {doors = {2049,2571,2570},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "hardwarestore",typ = "shop"}};
    ["gasstation"] = {doors = {2111,2112,2113},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "gasstation",typ = "shop"}};
    ["14 Any Way"] = {doors = {1290,1291,1288,1289,2231,2299},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "14 Any Way",typ = "hangar"}};
    ["club"] = {doors = {2100,2101,3539,3466,3465,3546,3545,3551,3468,3481},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "nightclub",typ = "shop"}};
    ["1 Pleasant Rd"] = {doors = {2699,2698,2700},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "1 Pleasant Rd",typ = "hangar"}};
    ["1 South St"] = {doors = {2025,2026,2027,2170},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "1 South St",typ = "hangar"}};
    ["bank"] = {doors = {3114,3115},locked = true,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "bank",typ = "shop"}};
    ["1 Bank St"] = {doors = {2707,2706,2708},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "1 Bank St",typ = "hangar"}};
    ["6-1 Crooked Ln"] = {doors = {3258},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "6-1 Crooked Ln",typ = "hugetower"}};
    ["6-2 Crooked Ln"] = {doors = {3257},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "6-2 Crooked Ln",typ = "hugetower"}};
    ["8-1 Crooked Ln"] = {doors = {3264},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "8-1 Crooked Ln",typ = "hugetower"}};
    ["8-2 Crooked Ln"] = {doors = {3265},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "8-2 Crooked Ln",typ = "hugetower"}};
    ["10-1 Crooked Ln"] = {doors = {3268},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "10-1 Crooked Ln",typ = "hugetower"}};
    ["10-2 Crooked Ln"] = {doors = {3269},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "10-2 Crooked Ln",typ = "hugetower"}};
    ["12 Crooked Ln"] = {doors = {3298,3305},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "12 Crooked Ln",typ = "hugetower"}};
    ["jewelrystore"] = {doors = {2050,2195,2059},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "jewelry",typ = "shop"}};
    ["A Union Sq"] = {doors = {3135,3137,3136},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "A Union Sq",typ = "appartment"}};
    ["B Union Sq"] = {doors = {3138,3139,3140},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "B Union Sq",typ = "appartment"}};
    ["C Union Sq"] = {doors = {3132,3133,3134},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "C Union Sq",typ = "appartment"}};
    ["D Union Sq"] = {doors = {3130,3131,2956},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "D Union Sq",typ = "appartment"}};
    ["E Union Sq"] = {doors = {3002,3004,3003},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "E Union Sq",typ = "appartment"}};
    ["F Union Sq"] = {doors = {1358,1359,1360},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "F Union Sq",typ = "appartment"}};
    ["G Union Sq"] = {doors = {1353,1354,1355},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "G Union Sq",typ = "appartment"}};
    ["H Union Sq"] = {doors = {1356,2957,1357},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "H Union Sq",typ = "appartment"}};
    ["I Union Sq"] = {doors = {2997,3001,3000},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "I Union Sq",typ = "appartment"}};
    ["J Union Sq"] = {doors = {1361,1362,1363},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "J Union Sq",typ = "appartment"}};
    ["K Union Sq"] = {doors = {1364,1366,1365},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "K Union Sq",typ = "appartment"}};
    ["L Union Sq"] = {doors = {1367,2958,1368},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "L Union Sq",typ = "appartment"}};
    ["1 New Life St"] = {doors = {1958,2372,2363},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "1 New Life St",typ = "garage"}};
    ["2 New Life St"] = {doors = {2044,2373,2364},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "2 New Life St",typ = "garage"}};
    ["3 New Life St"] = {doors = {2046,2376,2055},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "3 New Life St",typ = "garage"}};
    ["Mairie open"] = {doors = {3008,3007},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "Mairie open",typ = "garage"}};
    ["Mairie closed"] = {doors = {3018,3019},locked = true,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "Mairie closed",typ = "garage"}};
    ["archivist"] = {doors = {2047,2380,2054},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "archivist",typ = "shop"}};
    ["1 13th St"] = {doors = {1964,1965,1300},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "1 13th St",typ = "appartment"}};
    ["2 13th St"] = {doors = {2259,2260,1296},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "2 13th St",typ = "appartment"}};
    ["3 13th St"] = {doors = {2257,2258,1295},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "3 13th St",typ = "appartment"}};
    ["4 13th St"] = {doors = {1969,1299,1968},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "4 13th St",typ = "appartment"}};
    ["5 13th St"] = {doors = {2256,2255,1293},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "5 13th St",typ = "appartment"}};
    ["6 13th St"] = {doors = {1970,1298,1972},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "6 13th St",typ = "appartment"}};
    ["7 13th St"] = {doors = {1977,1978,1294},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "7 13th St",typ = "appartment"}};
    ["8 13th St"] = {doors = {1971,1297,1973},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "8 13th St",typ = "appartment"}};
    ["9 13th St"] = {doors = {2048,2381,2053},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "1 13th St",typ = "garage"}};
    ["repairgarage"] = {doors = {2060,2062,2066,2061,2067,2065},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "garage",typ = "shop"}};
    ["drugstore"] = {doors = {2166,2582,2167},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "drugstore",typ = "shop"}};
}
gbrp.foods = {
    ["mre"] = {model = "models/crunchy/props/eft_props/mre.mdl", energy = 25, price = 15},
    ["beefstew"] = {model = "models/crunchy/props/eft_props/beefstew.mdl", energy = 17, price = 7},
    ["beefstew_family"] = {model = "models/crunchy/props/eft_props/beefstew2.mdl", energy = 20, price = 10},
    ["canned_fish"] = {model = "models/crunchy/props/eft_props/herring.mdl", energy = 13, price = 3},
    ["peas"] = {model = "models/crunchy/props/eft_props/peas.mdl", energy = 18, price = 8},
    ["squash"] = {model = "models/crunchy/props/eft_props/squash.mdl", energy = 19, price = 9},
    ["hotrod"] = {model = "models/crunchy/props/eft_props/hotrod.mdl", energy = 22, price = 12},
    ["juice"] = {model = "models/crunchy/props/eft_props/juice.mdl", energy = 16, price = 6},
    ["oatmeal"] = {model = "models/crunchy/props/eft_props/oatmeal.mdl", energy = 13, price = 3},
    ["water"] = {model = "models/crunchy/props/eft_props/waterbottle.mdl", energy = 16, price = 6},
    ["hotdog"] = {model = "models/food/hotdog.mdl", energy = 16, price = 6},
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
if SERVER then
    function gbrp.SpawnNPCs()
        local bank1 = ents.Create("gbrp_bank_receptionist")
        bank1.gender = "female"
        bank1:SetModel("models/mossman.mdl")
        bank1:SetPos(Vector(-954.399658,2831.927979,-38.031754))
        bank1:SetAngles(Angle(0,-89.345398,0))
        bank1:Spawn()

        local bank2 = ents.Create("gbrp_bank_receptionist")
        bank2.gender = "male"
        bank2:SetModel("models/sentry/sentryoldmob/mafia/sentrymobmale2pm.mdl")
        bank2:SetPos(Vector(-1063.368408,2830.685547,-38.031754))
        bank2:SetAngles(Angle(0,-89.730392,0))
        bank2:Spawn()

        local bank3 = ents.Create("gbrp_bank_receptionist")
        bank3.gender = "female"
        bank3:SetModel("models/mossman.mdl")
        bank3:SetPos(Vector(-1159.221558,2812.594482,-38.031754))
        bank3:SetAngles(Angle(0,-90,0))
        bank3:Spawn()

        local jewelry = ents.Create("gbrp_shop")
        jewelry:SetModel("models/sentry/sentryoldmob/mafia/sentrymobmale7pm.mdl")
        jewelry:SetPos(Vector(-576.345520,253.843369,-30.031754))
        jewelry:SetAngles(Angle(0,0,0))
        jewelry:SetShopName("jewelrystore")
        jewelry:Spawn()

        local hardwarestore = ents.Create("gbrp_shop")
        hardwarestore:SetModel("models/odessa.mdl")
        hardwarestore:SetPos(Vector(1298.557983,-1579.187866,-29.987122))
        hardwarestore:SetAngles(Angle(0,90.987114,0))
        hardwarestore:Spawn()

        local gunshop = ents.Create("gbrp_shop")
        gunshop:SetModel("models/monk.mdl")
        gunshop:SetPos(Vector(-1099.968750,10497.299805,202.012878))
        gunshop:SetAngles(Angle(0,-179.686249,0))
        gunshop:SetShopName("gunshop")
        gunshop:Spawn()

        local drugstore = ents.Create("gbrp_shop")
        drugstore:SetModel("models/Kleiner.mdl")
        drugstore:SetPos(Vector(-6566.270508,3409.478027,42.012878))
        drugstore:SetAngles(Angle(0,-90.832703,0))
        drugstore:SetShopName("drugstore")
        drugstore:Spawn()

        local club = ents.Create("gbrp_shop")
        club:SetModel("models/breen.mdl")
        club:SetPos(Vector(-7678.176758,5545.522461,66.012878))
        club:SetAngles(Angle(0,89.205963,0))
        club:SetShopName("club")
        club:Spawn()

        local repairgarage = ents.Create("gbrp_shop")
        repairgarage:SetModel("models/odessa.mdl")
        repairgarage:SetPos(Vector(-2378.206543,6402.301758,90.012878))
        repairgarage:SetAngles(Angle(0,-5.253576,0))
        repairgarage:SetShopName("repairgarage")
        repairgarage:Spawn()

        local bar = ents.Create("gbrp_shop")
        bar:SetModel("models/alyx.mdl")
        bar:SetPos(Vector(4955.289063,8042.855957,210.012878))
        bar:SetAngles(Angle(0,0,0))
        bar:SetShopName("bar")
        bar:Spawn()

        local gasstation = ents.Create("gbrp_shop")
        gasstation:SetModel("models/eli.mdl")
        gasstation:SetPos(Vector(-5872.972168,1543.199097,50.012878))
        gasstation:SetAngles(Angle(0,-92.799614,0))
        gasstation:SetShopName("gasstation")
        gasstation:Spawn()

        local archivist = ents.Create("gbrp_shop")
        archivist:SetModel("models/humans/Group01/female_03.mdl")
        archivist:SetPos(Vector(3966.805908,6776.076660,16.896027))
        archivist:SetAngles(Angle(0,-90,0))
        archivist:Spawn()

        local unknown = ents.Create("gbrp_shop")
        unknown:SetModel("models/player/hostage/hostage_01.mdl")
        unknown:SetPos(Vector(1505.933350,7163.607422,81.896027))
        unknown:SetAngles(Angle(0,-90,0))
        unknown:Spawn()
    end
    function gbrp.SpawnHotdogSalesmans()
        local salesman1 = ents.Create("gbrp_hotdogsalesman")
        salesman1:SetModel("models/Eli.mdl")
        salesman1.hotdogpos = Vector(1985.312012,5540.983398,46.440498)
        salesman1:SetPos(Vector(1953.749268,5490.832520,8.031250))
        salesman1:SetAngles(Angle(0,90,0))
        salesman1:Spawn()

        local salesman2 = ents.Create("gbrp_hotdogsalesman")
        salesman2:SetModel("models/Eli.mdl")
        salesman2.hotdogpos = Vector(3762.856201,5870.750000,46.440498)
        salesman2:SetPos(Vector(3740.848389,5814.738281,8.031242))
        salesman2:SetAngles(Angle(0,90,0))
        salesman2:Spawn()

        local salesman3 = ents.Create("gbrp_hotdogsalesman")
        salesman3:SetModel("models/Eli.mdl")
        salesman3.hotdogpos = Vector(5800.159668,4402.841309,-17.559513)
        salesman3:SetPos(Vector(5840.312500,4459.221191,-55.968750))
        salesman3:SetAngles(Angle(0,-90,0))
        salesman3:Spawn()

        local salesman4 = ents.Create("gbrp_hotdogsalesman")
        salesman4:SetModel("models/Eli.mdl")
        salesman4.hotdogpos = Vector(-6306.340332,2667.020508,-1.559502)
        salesman4:SetPos(Vector(-6298.107910,2717.878174,-40))
        salesman4:SetAngles(Angle(0,-90,0))
        salesman4:Spawn()

        local salesman5 = ents.Create("gbrp_hotdogsalesman")
        salesman5:SetModel("models/Eli.mdl")
        salesman5.hotdogpos = Vector(-6306.340332,2667.020508,-7)
        salesman5:SetPos(Vector(-6298.107910,2717.878174,-40))
        salesman5:SetAngles(Angle(0,-90,0))
        salesman5:Spawn()

        local salesman6 = ents.Create("gbrp_hotdogsalesman")
        salesman6:SetModel("models/Eli.mdl")
        salesman6.hotdogpos = Vector(5211.087402,8753.347656,166.440491)
        salesman6:SetPos(Vector(5186.979492,8707.676758,128))
        salesman6:SetAngles(Angle(0,90,0))
        salesman6:Spawn()

        local salesman7 = ents.Create("gbrp_hotdogsalesman")
        salesman7:SetModel("models/Eli.mdl")
        salesman7.hotdogpos = Vector(6286.805664,888.787598,-65.55950)
        salesman7:SetPos(Vector(6341.223145,865.494080,-103))
        salesman7:SetAngles(Angle(0,180,0))
        salesman7:Spawn()

        local salesman8 = ents.Create("gbrp_hotdogsalesman")
        salesman8:SetModel("models/Eli.mdl")
        salesman8.hotdogpos = Vector(1560.791504,340.471008,-65.559509)
        salesman8:SetPos(Vector(1601,323,-104))
        salesman8:SetAngles(Angle(0,180,0))
        salesman8:Spawn()

        local salesman9 = ents.Create("gbrp_hotdogsalesman")
        salesman9:SetModel("models/Eli.mdl")
        salesman9.hotdogpos = Vector(-2793.504395,11675.882813,166.44)
        salesman9:SetPos(Vector(-2749,11658,130))
        salesman9:SetAngles(Angle(0,180,0))
        salesman9:Spawn()
    end
    function gbrp.RemoveHotdogSalesmans()
        for _,npc in pairs(ents.FindByClass("gbrp_hotdogsalesman")) do
            npc:Remove()
        end
    end
    function gbrp.InitDoors()
        gbrp.doors = {}
        local counter = 0
        for doorgroupname,doorgroup in pairs(gbrp.doorgroups) do
            for _,doormapid in pairs(doorgroup.doors) do
                counter = counter + 1
                local door = ents.GetMapCreatedEntity(doormapid)
                if not IsValid(door) then print("[GBRP] This door is causing problems" .. tostring(doormapid)) break end
                door:setDoorGroup(doorgroup.attributes.owner)
                if doorgroup.locked then
                    door:Fire("lock", "", 0)
                end
                gbrp.doors[door:EntIndex()] = doorgroup.attributes
            end
        end
    end
    function gbrp.SendDoorsData(ply)
        net.Start("GBRP::doorsinit")
        net.WriteInt(table.Count(gbrp.doors),32)
        for k,v in pairs(gbrp.doors) do
            net.WriteInt(k,32)
            net.WriteTable(v)
        end
        net.Send(ply)
    end
    function gbrp.SaveDoors()
        gbrp.savedDoors = {}
        for doorgroupname,doorgroup in pairs(gbrp.doorgroups) do
            for _,doormapid in pairs(doorgroup.doors) do
                local door = ents.GetMapCreatedEntity(doormapid)
                if not table.IsEmpty(door:getDoorData()) then
                    gbrp.savedDoors[doormapid] = {}
                    gbrp.savedDoors[doormapid].darkrpvars = door:getDoorData()
                    gbrp.savedDoors[doormapid].locked = door:GetInternalVariable("m_bLocked")
                end
            end
        end
    end
    function gbrp.LoadDoors()
        for doormapid,tab in pairs(gbrp.savedDoors) do
            local door = ents.GetMapCreatedEntity(doormapid)
            door:setDoorGroup(tab.darkrpvars.groupOwn)
            if tab.darkrpvars.owner then
                door:keysOwn(tab.darkrpvars.owner)
            end
            if tab.locked then
                door:Fire("Lock", "", 0)
            else
                door:Fire("Unlock", "", 0)
            end
        end
    end
    function gbrp.SaveShops()
        gbrp.savedShops = {}
        for _,ent in pairs(ents.FindByClass("gbrp_shop")) do
            gbrp.savedShops[ent:GetShopName()] = {}
            gbrp.savedShops[ent:GetShopName()].balance = ent:GetBalance()
            gbrp.savedShops[ent:GetShopName()].dirtyMoney = ent:GetDirtyMoney()
            gbrp.savedShops[ent:GetShopName()].gangName = ent:GetGangName()
        end
    end
    function gbrp.LoadShops()
        for _,ent in pairs(ents.FindByClass("gbrp_shop")) do
            for name,val in pairs(gbrp.savedShops) do
                if name == ent:GetShopName() then
                    ent:SetBalance(val.balance)
                    ent:SetDirtyMoney(val.dirtyMoney)
                    ent:SetGangName(val.gangName)
                end
            end
        end
    end
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
        ["jewelrystore"] = {mat = Material("gui/gbrp/gangpanel/diamond.png"),x = 5,y = 9},
        ["repairgarage"] = {mat = Material("gui/gbrp/gangpanel/tire.png"),x = 6,y = 7},
        ["drugstore"] = {mat = Material("gui/gbrp/gangpanel/drugstore.png"),x = 8,y = 10},
        ["bar"] = {mat = Material("gui/gbrp/gangpanel/beer.png"),x = 15,y = 7},
        ["club"] = {mat = Material("gui/gbrp/gangpanel/cocktail.png"),x = 7,y = 7},
        ["gunshop"] = {mat = Material("gui/gbrp/gangpanel/gun.png"),x = 7,y = 17},
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
end
SetGlobalInt("yakuzasBalance",0);
SetGlobalInt("yakuzasPrivateDoorsCount",0);
SetGlobalInt("mafiaBalance",0);
SetGlobalInt("mafiaPrivateDoorsCount",0);
SetGlobalInt("gangBalance",0);
SetGlobalInt("gangPrivateDoorsCount",0);

gbrp.yakuzas = {
    subject = "Les yakuzas",
    name = "yakuzas"
}
table.Inherit(gbrp.yakuzas,gangMeta)

gbrp.mafia = {
    subject = "La Mafia",
    name = "mafia"
}
table.Inherit(gbrp.mafia,gangMeta)

gbrp.gang = {
    subject = "Les gangsters",
    name = "gang"
}
table.Inherit(gbrp.gang,gangMeta)