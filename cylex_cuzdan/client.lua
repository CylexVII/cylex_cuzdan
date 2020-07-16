local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX             				 = nil


-- Servern callback

RegisterNetEvent('jsfour-legitimation:open')
AddEventHandler('jsfour-legitimation:open', function(playerData)
	cardOpen = true
	SendNUIMessage({
		action = "open",
		array = playerData
	})
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

-- No one Near Animation
RegisterNetEvent("cylex:wallet")
AddEventHandler("cylex:wallet", function()
  OpenCivilianActionsMenu()
end)

function OpenShowGiveID()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'id_card_menu',
    {
      title    = ('Kimlik Menüsü'),
      align    = 'right',
      elements = {
        {label = ('Kimliğine Bak'), value = 'check'},
        {label = ('Kimliğini Uzat'), value = 'show'}
      }
    },
    function(data2, menu2)
      if data2.current.value == 'check' then
        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
      elseif data2.current.value == 'show' then
        local player, distance = ESX.Game.GetClosestPlayer()

        if distance ~= -1 and distance <= 3.0 then
          TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
        else
          exports['mythic_notify']:DoHudText('error', 'Yakında oyuncu yok')
        end
      end
    end,
    function(data2, menu2)
      menu2.close()
      OpenCivilianActionsMenu()
    end)
end

function OpenShowEhliyet()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'ehliyet_card_menu',
    {
      title    = ('Ehliyet Menüsü'),
      align    = 'right',
      elements = {
        {label = ('Ehliyetine Bak'), value = 'checks'},
        {label = ('Ehliyetini Uzat'), value = 'shows'}
      }
    },
    function(data2, menu2)
      if data2.current.value == 'checks' then
        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
      elseif data2.current.value == 'shows' then
        local player, distance = ESX.Game.GetClosestPlayer()

        if distance ~= -1 and distance <= 3.0 then
          TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
        else
          --ESX.ShowNotification('No players nearby')
          exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok')
        end
      end
    end,
    function(data2, menu2)
      menu2.close()
      OpenCivilianActionsMenu()
    end
  )
  
  end

function OpenCivilianActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
  'default', GetCurrentResourceName(), 'civilian_actions',
  {
    title    = ('Cüzdan'),
    align    = 'right',
    elements = {
      {label = ('Kimlik'), value = 'id'},
      {label = ("Ehliyet"), value = 'ehliyet'}
    }
  },
    
    function(data, menu)

      if data.current.value == 'id' then
      	OpenShowGiveID()
      end

      if data.current.value == 'ehliyet' then
      	OpenShowEhliyet()
      end
    end,
    function(data, menu)
      menu.close()
    end
  )
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlPressed(0, 322) or IsControlPressed(0, 177) and cardOpen then
			SendNUIMessage({
				action = "close"
			})
			cardOpen = false
		end
	end
end)