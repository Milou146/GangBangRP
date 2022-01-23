        --[[ 
            Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
            Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

            Please do not edit anything in this file; it WILL remove support from you.
            
            Have an issue with the script? Please make a ticket and we will assist you.
        --]]
        
        --> Purchase Tracking <--

        local file_path = "Aero/money_spent/money_spent.txt"

        --> The hooks we want to track <--
        local hooks = {
            { 
                hook = "playerBoughtAmmo", 
                callback = function( ply, ammoTable, ent, price )
                    Aero.UpdateMoneySpent( price )
                end 
            },
            { 
                hook = "playerBoughtCustomEntity", 
                callback = function( ply, entTable, ent, price )
                    Aero.UpdateMoneySpent( price )
                end 
            },
            { 
                hook = "playerBoughtCustomVehicle", 
                callback = function( ply, vehTable, ent, price )
                    Aero.UpdateMoneySpent( price )
                end 
            },
            { 
                hook = "playerBoughtDoor", 
                callback = function( ply, ent, price )
                    Aero.UpdateMoneySpent( price )
                end 
            },
            { 
                hook = "playerBoughtFood", 
                callback = function( ply, food, ent, price )
                    Aero.UpdateMoneySpent( price )
                end 
            },
            { 
                hook = "playerBoughtPistol", 
                callback = function( ply, wepTable, ent, price )
                    Aero.UpdateMoneySpent( price )
                end 
            },
            { 
                hook = "playerBoughtShipment", 
                callback = function( ply, wepTable, ent, price )
                    Aero.UpdateMoneySpent( price )
                end 
            }
        }
    
        -- Quickly deploys all hooks to track money spent <--
        function Aero.DeployStatHooks()
            for k, v in pairs( hooks ) do
                hook.Add( v.hook, "Aero.Stats." .. v.hook, v.callback )
            end
        end

        function Aero.GetMoneySpent()
            if not file.Exists( file_path, "DATA" ) then
                file.Write( file_path, "0" )
                Aero.MoneySpent = 0
            else
                Aero.MoneySpent = file.Read( file_path, "DATA" )
            end
            Aero.DeployStatHooks()
        end
        hook.Add( "Initialize", "Aero.Load.Money_Spent", Aero.GetMoneySpent )

        --> Updates amount spent <--
        function Aero.UpdateMoneySpent( price )
            Aero.MoneySpent = Aero.MoneySpent + price
            file.Write( file_path, tostring( Aero.MoneySpent ) )
        end

    
    