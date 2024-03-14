ConfigServer = { }
--------------------------------------------------------------------------------------------------------------------------------
-- Prepares
-----------------------------------------------------------------------------------------------------------------------------------------
ConfigServer.mysql_insert_car = "select * from vrp_vehicles where user_id = @user_id and work = 'false'"
ConfigServer.mysql_verificar_carros = "select * from vrp_vehicles where user_id = @user_id and vehicle = @carro"
ConfigServer.mysql_remover_carro = "DELETE FROM vrp_vehicles WHERE user_id=@user_id AND vehicle=@carro;"
ConfigServer.mysql_transferir_carro = "UPDATE vrp_vehicles SET user_id = @user_id_destino WHERE user_id=@user_id AND vehicle=@carro;"
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function ConfigServer.comprar_carro(carro) 

    local source = source
    local user_id = vRP.getUserId(source)

    local carros_player = cnServer.carros_player(user_id)
    local infos_user = vRP.getInformation(user_id)

    if infos_user then 
        if #carros_player < infos_user[1].garage then 
            local carros_temp = cnServer.player_tem_esse_carro(user_id, carro.nome)
            if #carros_temp == 0 then 
                if vRP.paymentBank(user_id, parseInt(carro.preco)) then 
                    cnServer.adicionar_carro(user_id, carro.nome)
                    TriggerClientEvent("Notify",source,"verde","Você comprou um carro.",10000)
                else 
                    TriggerClientEvent("Notify",source,"vermelho","Saldo do banbco insuficiente.",10000)
                end
            else
                TriggerClientEvent("Notify",source,"vermelho","Você já tem esse carro.",10000)
            end
        else
            TriggerClientEvent("Notify",source,"vermelho","Não tem mais vagas de garage.",10000)
        end

    end
	
    --vRP.createWeebHook(webhookaddcar,"```prolog\n[ID]: "..user_id.." \n[ADICIONOU]: "..args[2].." \n[DO ID]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		
end

-- gerador e liberação de placas
function ConfigServer.gerarPlate(user_id) 

    local placa = vRP.generatePlateNumber()

    TriggerEvent("setPlateEveryone",placa)
	TriggerEvent("setPlatePlayers",placa,user_id)

    return placa
end


function ConfigServer.vender_carro(carro) 

    local source = source
    local user_id = vRP.getUserId(source)

    local carros_temp = cnServer.player_tem_esse_carro(user_id, carro.nome)
    if #carros_temp > 0 then 
        vRP.addBank(user_id, parseInt(carro.preco*config.porcetagem_pagar_carro_player_ao_vender))  
        cnServer.remover_carro(user_id, carro.nome)
        TriggerClientEvent("Notify",source,"verde","Você vendeu seu carro.",10000)  
    else
        TriggerClientEvent("Notify",source,"vermelho","Você não tem esse carro.",10000)
    end

    --vRP.createWeebHook(webhookaddcar,"```prolog\n[ID]: "..user_id.." \n[ADICIONOU]: "..args[2].." \n[DO ID]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		
end

function ConfigServer.transferir_carro(data) 

    local source = source
    local user_id = vRP.getUserId(source)

    local carro = data.car
    local id_user_destino = data.id_usuario_detisno

    local carros_temp = cnServer.player_tem_esse_carro(user_id, carro.nome)
    if #carros_temp > 0 then 
    
        local infos_user = vRP.getInformation(parseInt(id_user_destino))

        if infos_user and #infos_user > 0 then 
            local carros_player = cnServer.carros_player(id_user_destino)
            if #carros_player < infos_user[1].garage then 
                cnServer.transferir_carro_execute(user_id, carro.nome, id_user_destino)
                TriggerClientEvent("Notify",source,"verde","Você transferiru seu carro para id: "..id_user_destino ,15000) 
            else
                TriggerClientEvent("Notify",source,"vermelho","Usuario de destino não tem vagas de garages disponiveis" ,15000) 
            end

        else
            TriggerClientEvent("Notify",source,"vermelho","Usuario de destino não existe id: "..id_user_destino ,15000) 
        end

    else
        TriggerClientEvent("Notify",source,"vermelho","Você não tem esse carro.",10000)
    end

    --vRP.createWeebHook(webhookaddcar,"```prolog\n[ID]: "..user_id.." \n[ADICIONOU]: "..args[2].." \n[DO ID]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		
end

