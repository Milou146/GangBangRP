



MASK = MASK or {}
MASK.Theme = {
['back'] = Color(0, 0, 0, 255), -- background color
['back2'] = Color(189, 189, 189, 200),
['back3'] = Color(140, 140, 140, 200),
['back4'] = Color(66, 66, 66, 200),
['back5'] = Color(38, 38, 38, 255),
['back6'] = Color(105, 105, 105, 255),
['back7'] = Color(71, 71, 71, 255),
['text'] = Color(255, 255, 255), 
['text2'] = Color(191, 191, 191), 
['rect'] = Color(0, 0, 0, 150), 
['button1'] = Color(0, 0, 0, 255),
['button2'] = Color(64, 64, 64, 255),
['button3'] = Color(87, 87, 87, 150),
['button4'] = Color(41, 41, 41, 150),
['button5'] = Color(59, 58, 58, 150),
['button6'] = Color(0, 0, 0, 100),
}

--[[
{job = 'Citizen', -- profession name 
model = {'models/player/Group01/male_04.mdl'}, -- model / models 
alowall = true, -- true - available to all professions / false - only available to professions in alow 
alow = {'Citizen',}, -- access to professions if alowall = false example: Citizen
},
]]





MASK.Costym = {

{job = 'Gangster', 
 model = {"models/sentry/gtav/ballas/ogbalpm.mdl",
"models/sentry/gtav/ballas/balfpm.mdl",
"models/sentry/gtav/ballas/ballaseastpm.mdl",
"models/sentry/gtav/ballas/ballasorigpm.mdl",
"models/sentry/gtav/ballas/ballassoutpm.mdl",
"models/sentry/gtav/families/famfpm.mdl",
"models/sentry/gtav/families/famcapm.mdl",
"models/sentry/gtav/families/famfopm.mdl",
"models/sentry/gtav/families/famdnpm.mdl",
"models/sentry/gtav/lost/lostgirlbpm.mdl",
"models/sentry/gtav/lost/lostgirlwpm.mdl"}, 
alowall = true, 
alow = {''},
color = Color(0, 255, 0, 255)
},

{job = 'Mafieux', 
model = {"models/sentry/sentryoldmob/irish/sentryirishmale2pm.mdl", 
"models/sentry/sentryoldmob/irish/sentryirishmale4pm.mdl",
"models/sentry/sentryoldmob/irish/sentryirishmale6pm.mdl",
"models/sentry/sentryoldmob/irish/sentryirishmale7pm.mdl",
"models/sentry/sentryoldmob/irish/sentryirishmale8pm.mdl", 
"models/sentry/sentryoldmob/irish/sentryirishmale9pm.mdl",
"models/sentry/sentryoldmob/mafia/sentrymobmale2pm.mdl",
"models/sentry/sentryoldmob/mafia/sentrymobmale4pm.mdl",
"models/sentry/sentryoldmob/mafia/sentrymobmale6pm.mdl",
"models/sentry/sentryoldmob/mafia/sentrymobmale7pm.mdl",
"models/sentry/sentryoldmob/mafia/sentrymobmale8pm.mdl",
"models/sentry/sentryoldmob/mafia/sentrymobmale9pm.mdl",
"models/sentry/sentryoldmob/oldgoons/sentrybusi1male2pm.mdl",
"models/sentry/sentryoldmob/oldgoons/sentrybusi1male4pm.mdl",
"models/sentry/sentryoldmob/oldgoons/sentrybusi1male6pm.mdl",
"models/sentry/sentryoldmob/oldgoons/sentrybusi1male7pm.mdl",
"models/sentry/sentryoldmob/oldgoons/sentrybusi1male8pm.mdl",
"models/sentry/sentryoldmob/oldgoons/sentrybusi1male9pm.mdl"},
alowall = true, 
alow = {''},
color = Color(0, 255, 0, 255)
},

{job = 'Yakuza', 
model = {"models/players/Kimonos.mdl", 
"models/players/Kimonos_02.mdl", 
"models/players/Kimonos_03.mdl", 
"models/players/Kimonos_04.mdl", 
"models/players/Kimonos_05.mdl", 
"models/players/Kimonos_06.mdl", 
"models/players/Kimonos_07.mdl", 
"models/players/Kimonos_10.mdl", 
"models/players/Kimonos_14.mdl", 
"models/players/Kimonos_15.mdl", 
"models/players/Kimonos_17.mdl", 
"models/players/Kimonos_18.mdl", 
"models/players/Kimonos_19.mdl", 
"models/players/Kimonos_21.mdl", 
"models/players/Kimonos_26.mdl"},
alowall = true, 
alow = {''},
color = Color(0, 255, 0, 255)
},

{job = 'Police', 
model = {"models/taggart/police01/male_01.mdl", 
	"models/taggart/police01/male_02.mdl", 
	"models/taggart/police01/male_04.mdl", 
	"models/taggart/police01/male_05.mdl", 
	"models/taggart/police01/male_06.mdl", 
	"models/taggart/police01/male_07.mdl", 
	"models/taggart/police01/male_08.mdl", 
	"models/taggart/police01/male_09.mdl"
	},
alowall = true, 
alow = {''},
color = Color(0, 255, 0, 255)
},

}

MASK.Config = {
deplay = 540, -- recharge disguise  
timemask = 360, -- disguise time
rect = 1, -- width of frames 
notify = false, -- true enable notifications, false use chat 
notify_time = 5, -- duration of notifications if notify = true
time_button = true, -- true - Shows the time until the end of the disguise 
hear_disguise = true, -- if enabled next to the disguised person the message "hear" will be played 
drop_time_on_death_etc = true, -- if true, the disguise recharge timer will be reset upon death, change of profession 
 
}

MASK.Lang = 'fr' -- ru, en

MASK.Language = {
['en'] ={ 
        title = 'Disguise menu',
        title2 = 'Choisissez un modèle',
        drop_disguise = 'Supprimer le déguisement',
        button = 'Disguise:',
        disguise = 'You are in disguise!',
        hear = 'Have you heard the sounds of clothes',
        time_out = 'Disguise time is up!',
        wait = 'Wait',
        time_next = 'seconds for disguise',
        cancel_disguise = 'You have canceled the disguise!',
        not_disguise = 'You are not in disguise!',
        cancel_disguise2 = 'Disguise canceled!',
		end_disguise = 'seconds until the end of disguise ',
		none_disguise = 'You are not in disguise',
        },
['fr'] ={ 
        title = 'Menu Déguisement',
        title2 = 'Choisissez un modèle',
        drop_disguise = 'Supprimer le déguisement',
        button = 'Déguisement :',
        disguise = 'Vous êtes déguisé !',
        hear = 'Avez-vous entendu le bruit des vêtements ?',
        time_out = 'Le temps du déguisement est terminé !',
        wait = 'Patientez',
        time_next = 'secondes pour le déguisement',
        cancel_disguise = 'Vous avez annulé le déguisement !',
        not_disguise = 'Vous n êtes pas déguisé',
        cancel_disguise2 = 'Déguisement annulé !',
		end_disguise = 'secondes jusqu à la fin du déguisement',
		none_disguise = 'Vous n êtes pas déguisé',
        },

}
 