-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cnClient= {}
Tunnel.bindInterface(GetCurrentResourceName(),cnClient)
vSERVER = Tunnel.getInterface(GetCurrentResourceName())
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------

local locs_anterior = nil


-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
       local time = 1000
       local ped = PlayerPedId()
       local coords = GetEntityCoords(ped) 
       local distance = #(coords - vector3(config.inicio.x,config.inicio.y,config.inicio.z))
       if distance < 10 then
          DrawMarker(2,config.inicio.x,config.inicio.y,config.inicio.z,0,0,0,0,0,0,1.00,1.00,1.00,0,14,255,100,0,0,0,1)
          time = 1
          if distance < 2 then
            if IsControlJustPressed(1,38) then

                local carros_player = vSERVER.pegar_carros_player()
                local carros_player_preenchida = {} 

                for k,v in pairs(carros_player) do 

                    if config.carros[v.vehicle] == nil then
                        print("Carro não existe na config: "..v.vehicle)
                    else
                        local car_temp = config.carros[v.vehicle]
                        table.insert(carros_player_preenchida,car_temp)
                    end

                end

                SendNUIMessage({
                    montrar = true,
                    carros = config.carros,
                    meus_carros = carros_player_preenchida,
                    p_venda = config.porcetagem_pagar_carro_player_ao_vender
                }) 
                SetNuiFocus(true,true)

            end
          end
       end                        
       Wait(time)
    end
end)

RegisterNUICallback('fechar', function(data, cb)
    SetNuiFocus(false,false)
end)

RegisterNUICallback('comprar_carro', function(data, cb)
    vSERVER.comprar_carro(data)
end)

RegisterNUICallback('vender_carro', function(data, cb)
    vSERVER.vender_carro(data)
end)

RegisterNUICallback('transferir_carro', function(data, cb)
    vSERVER.transferir_carro(data)
end)



RegisterNUICallback('test_driver', function(data, cb)
    -- pega o ped
    local ped = PlayerPedId()

    -- remove o mouse
    SetNuiFocus(false, false)

    -- troca a sessão
    vSERVER.trocar_session()

    -- salva loc atual
    locs_anterior = GetEntityCoords(ped)

    -- deixa invencivel
    SetEntityInvincible(ped, true)

    -- efeito fadout
    DoScreenFadeOut(500)
    Wait(500)

    -- teleport
    SetEntityCoords(ped, config.spanw_teste_drive.x, config.spanw_teste_drive.y, config.spanw_teste_drive.z,1,0,0,1)

    local car_teste = cnClient.spwan_car(data.nome) 

    -- seta player no banco do motorista
    SetPedIntoVehicle(ped,car_teste,-1)

    -- efeito fadin
    DoScreenFadeIn(500)
    
    local esta_no_carro = true
    local time_teste_limite = config.time_teste_drive

    local init_time = 0

    while esta_no_carro and init_time <= time_teste_limite do 
        if GetPedInVehicleSeat(car_teste, -1) ~= ped then
            esta_no_carro = false
        end
        init_time = init_time + 1
        Wait(1000)
    end

    DoScreenFadeOut(500)
    Wait(500)

    if IsEntityAVehicle(car_teste) then
        DeleteEntity(car_teste)
    end

    vSERVER.voltar_session()

    SetEntityCoords(ped,locs_anterior.x,locs_anterior.y,locs_anterior.z,1,0,0,1)

    -- deixa vencivel
    SetEntityInvincible(ped, false)

    DoScreenFadeIn(500)
    
end)




function cnClient.spwan_car(name_car) 

    local ped = PlayerPedId()

    local mHash = GetHashKey(name_car)
    RequestModel(mHash)

    while not HasModelLoaded(mHash) do
        RequestModel(mHash)
        Citizen.Wait(10)
    end

    local carro_teste = CreateVehicle(mHash,config.spanw_teste_drive.x,config.spanw_teste_drive.y,config.spanw_teste_drive.z,config.spanw_teste_drive.grau,true,false)
    
    SetEntityHeading(carro_teste,config.spanw_teste_drive.grau)
    SetVehRadioStation(carro_teste, "OFF")

    local placa = vSERVER.gerarPlate()

    SetVehicleNumberPlateText(carro_teste, placa)
    
    SetEntityAsMissionEntity(carro_teste, true, true)
    SetModelAsNoLongerNeeded(mHash)

    return carro_teste

end




