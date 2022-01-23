    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]


    function Aero.DeployNexus( self )
        if not Nexus then 
            Aero.SendMessage( "No content here as Nexus (https://www.gmodstore.com/market/view/nexus-crates-crate-unboxing-system) is not owned. Set it to disabled if you DO NOT own it." )
            return 
        end
        self.Core_Container = self:MakeBaseContainer()
        Nexus.GetCrateMenu( true, self.Core_Container )
    end

