gbrp = {}
gbrp.yakuzas = {
    subject = "Les yakuzas"
}
gbrp.mafia = {
    subject = "La Mafia"
}
gbrp.gang = {
    subject = "Le Gang"
}
gbrp.jobs = {
    ["Citoyen"] = {gang = "nil",gangChief = nil};
    ["N.Y.P.D"] = {gang = "nil",gangChief = nil};
    ["N.Y.P.D"] = {gang = "nil",gangChief = nil};
    ["S.W.A.T"] = {gang = "nil",gangChief = nil};
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
    ["STAFF"] = {gang = "nil",gangChief = nil};
    ["YAMAKASI"] = {gang = "nil",gangChief = nil};
    ["Chauffeur de taxi"] = {gang = "nil",gangChief = nil};
    ["Vendeur hot dog"] = {gang = "nil",gangChief = nil};
    ["Hacker"] = {gang = "nil",gangChief = nil};
    ["Agent secret"] = {gang = "nil",gangChief = nil};
    ["Vendeur d'amres ambulant"] = {gang = "nil",gangChief = nil};
    ["Tueur à gage"] = {gang = "nil",gangChief = nil};
}

local plyMeta = FindMetaTable("Player")

function plyMeta:IsGangChief()
    return gbrp.jobs[team.GetName(self:Team())].gangChief
end

function plyMeta:GetGang()
    return gbrp.jobs[team.GetName(self:Team())].gang
end