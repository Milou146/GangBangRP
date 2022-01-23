    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]

    --> All colors used in Aero. Please note, I will NOT help you with recoloring it. <--
    Aero.Colors = {
        BASE_BACKGROUND = Color( 24, 24, 24 ),
        BASE_HEADER = Color( 21, 21, 21 ),
        BASE_CONTAINER = Color( 21, 21, 21 ),
        WHITE = Color( 255, 255, 255 ),
        RED = Color( 214, 48, 49 ),
        ORANGE = Color( 238,90,36 ),
        GREEN = Color( 54, 205, 66, 175 ),
        GREY = Color( 104, 104, 104 ),
        DARK_BLACK = Color( 52, 52, 52, 20 ),
        PURPLE = Color( 112, 111, 211 ),
        GOLD = Color( 251, 197, 49 ),
        BLUE = Color( 40, 212, 230 )
    }

    --> Which Theme is Aero using? (Classic) or (Dark) <--
    --!!!!!!!!!! cAsE mAtTeRs !!!!!!!!!!--
    Aero.Theme = "Dark"

    --> What title should Aero use? <--
    Aero.Main_Title = "Aero F4"

    --> Chat Prefix <--
    Aero.Chat_Prefix = "[Aero]: "
    Aero.Prefix_Color = Aero.Colors.RED
    --> The color of a message when it's sent <--
    Aero.Chat_Color = Aero.Colors.WHITE

    --[[
        Should Aero block Jobs that the user CAN NOT use.
        customCheck.
    --]]
    Aero.Hide_Unusable_Jobs = true

    --> Staff Ranks shown in the F4 menu <--
    Aero.Staff_Ranks = {
        [ "superadmin" ] = { rank = "Super Admin", color = Color( 15, 188, 249, 90 ) },
        [ "admin" ] = { rank = "Admin", color = Color( 214, 48, 49 ) }
    }

    --> Enter the exact name of your Gun Dealer Job <--
    --[[
        This is for the Dashboard "Shops Open" and to hide Weapons/Shipments
        If the user is not any of these jobs.
        --!!!!!!!!!! cAsE mAtTeRs !!!!!!!!!!--
    --]]
    Aero.Gun_Dealers = {
        [ "Light Gun Dealer" ] = true,
        [ "Heavy Gun Dealer" ] = true,
        [ "Gun Dealer" ] = true
    }

    --> Which modules are enabled? Set false to disable <--
    --[[
        Rewards - Comes with Aero for free.
        Nexus Crates: https://www.gmodstore.com/market/view/nexus-crates-crate-unboxing-system
        Reporter: https://www.gmodstore.com/market/view/reporter-the-advanced-reporting-system

        The above listed addons are my own, and will work with Aero out of the box.
        Don't own one? Feel free to purchase them and then you can enabled them below. :]
    --]]
    Aero.Modules = {
        [ "Rewards" ] = true, -- Playtime Rewards
        [ "Nexus" ] = false, -- Nexus Crates,
        [ "Reporter" ] = false -- Reporter - The Advanced Reporting System
    }

    --> Which sub tabs are enabled? <--
    Aero.Tabs = {
        [ "Ammo" ] = true,
        [ "Food" ] = false,
        [ "Vehicles" ] = false
    }

    ---- How often we update how many active Printers there are (Seconds) <--
    Aero.Printer_Scan_Time = 60 * 5

    --> Enter Printer classes here, or leave blank to disable <--
    Aero.Printer_Classes = {
        [ "money_printer" ] = true
    }

    --> Enter Bitminer classes here, or leave blank to disable <--
    Aero.Bitminer_Classes = {
        [ "money_printer" ] = true
    }

    --> The rewards given once the user has played for the specified amount of time <--

    Aero.Playtime_Payouts = {
        [ "Hourly" ] = 1000,
        [ "Daily" ] = 5000,
        [ "Weekly" ] = 10000,
    }

    --> The amount paid out when a user completes a task <--
    Aero.Task_Payouts = {
        [ "Name Change" ] = 500,
        [ "Drop Money" ] = 50,
        [ "Mayor" ] = 700,
        [ "Buy Door" ] = 250,
        [ "Gun Dealer" ] = 700,
        [ "Wanted" ] = 500,
        [ "Lottery Started" ] = 150,
        [ "First Words" ] = 25,
        [ "24 Hours" ] = 15000
    }

    --> Links shown in the F4 menu <--
    --> Do not include https://
    Aero.Links = {
        [ "Steam" ] = "www.google.co.uk",
        [ "Discord" ] = "discord.gg/KYZeZa"
    }



    