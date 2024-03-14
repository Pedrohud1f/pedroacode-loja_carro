-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cnServer = {}
Tunnel.bindInterface(GetCurrentResourceName(), cnServer)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------
-- Prepares
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("pegar_carros_player",ConfigServer.mysql_insert_car)
vRP.prepare("player_tem_esse_carro",ConfigServer.mysql_verificar_carros)
vRP.prepare("remover_carro_player",ConfigServer.mysql_remover_carro)
vRP.prepare("transferir_carro_player" ,ConfigServer.mysql_transferir_carro)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------

function cnServer.comprar_carro(carro) 
    ConfigServer.comprar_carro(carro)
end

function cnServer.remover_carro(user_id, carro) 
    vRP.execute("remover_carro_player", { user_id = user_id, carro = carro} )
end

function cnServer.transferir_carro_execute(user_id, carro, id_user_destino)
    vRP.execute("transferir_carro_player", { user_id = user_id, carro = carro, user_id_destino = id_user_destino} )
end

function cnServer.transferir_carro(data) 
    ConfigServer.transferir_carro(data)
end

function cnServer.vender_carro(carro) 
    ConfigServer.vender_carro(carro)
end

function cnServer.carros_player(user_id)
    return vRP.query("pegar_carros_player", { user_id = user_id} )
end

function cnServer.pegar_carros_player()
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.query("pegar_carros_player", { user_id = user_id} )
end

function cnServer.player_tem_esse_carro(user_id, nome_carro)
    return vRP.query("player_tem_esse_carro", { user_id = user_id, carro = nome_carro } )
end

function cnServer.adicionar_carro(user_id, nome_carro)
    vRP.execute("vRP/add_vehicle",{ user_id = user_id, vehicle = nome_carro,plate = vRP.generatePlateNumber(),phone = vRP.getPhone(user_id), work = tostring(false) })
end

function cnServer.trocar_session()
    
    local source = source
	local user_id = vRP.getUserId(source)

    SetPlayerRoutingBucket( source, user_id )

end

function cnServer.voltar_session()
    
    local source = source
	local user_id = vRP.getUserId(source)

    SetPlayerRoutingBucket( source, 0 )

end

function cnServer.gerarPlate() 
    local source = source
	local user_id = vRP.getUserId(source)

    return ConfigServer.gerarPlate(user_id) 
end
