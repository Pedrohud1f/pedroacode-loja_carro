var app = new Vue({
    el: '#app',
    data: {
        show: false,
        carros: [],
        meus_carros: [],
        p: "lista_carros",
        p_venda: 0
    }
})

function sair() {
    app.show = false

    fetch("http://loja_carros/fechar", { method: "POST" })

}


function comprar_carro(carro) {

    Swal.fire({
        title: 'Tem certeza que quer comprar esse carro?',
        text: "Confirme abaixo!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#43822A',
        cancelButtonColor: '#f00',
        confirmButtonText: 'SIM'
    }).then((result) => {
        if (result.isConfirmed) {
            sair()
            fetch('http://loja_carros/comprar_carro', { 
                headers: { "Content-Type": "application/json" },
                method: "POST",
                body: JSON.stringify(carro)
            })
            .then(response => { return response.json(); })
            .then(function(data) {
                console.log(data)
            }).catch(function(error) {
                console.log(error)
            });
        }
    })

}

function vender_carro(carro) {

    Swal.fire({
        title: 'Tem certeza que quer vender esse carro?',
        text: "Confirme abaixo!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#43822A',
        cancelButtonColor: '#f00',
        confirmButtonText: 'SIM'
    }).then((result) => {
        if (result.isConfirmed) {
            sair()
            fetch('http://loja_carros/vender_carro', { 
                headers: { "Content-Type": "application/json" },
                method: "POST",
                body: JSON.stringify(carro)
            })
            .then(response => { return response.json(); })
            .then(function(data) {
                console.log(data)
            }).catch(function(error) {
                console.log(error)
            });
        }
    })

}


function transferir_carro(carro) {
    Swal.fire({
        title: 'Tem certeza que quer transferir esse carro?',
        text: "Confirme abaixo!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#43822A',
        cancelButtonColor: '#f00',
        confirmButtonText: 'SIM'
    }).then((result) => {
        if (result.isConfirmed) {
            
            Swal.fire({
                title: 'Digite id usuário que vai receber o carro!',
                input: 'number',
                showCancelButton: true,
                confirmButtonText: 'Transferir'
              }).then((result2) => {
                if (result2.isConfirmed) {
                    sair()
                    fetch('http://loja_carros/transferir_carro', { 
                        headers: { "Content-Type": "application/json" },
                        method: "POST",
                        body: JSON.stringify({
                            id_usuario_detisno : result2.value,
                            car: carro
                        })
                    })
                    .then(response => { return response.json(); })
                    .then(function(data) {
                        console.log(data)
                    }).catch(function(error) {
                        console.log(error)
                    });
                }
              })

        }
    })
}



function test_driver(carro) {
    
    fetch('http://loja_carros/test_driver', { 
        headers: { "Content-Type": "application/json" },
        method: "POST",
        body: JSON.stringify(carro)
     })
     .then(response => { return response.json(); })
     .then(function(data) {
        console.log(data)
     }).catch(function(error) {
        console.log(error)
     });

     app.show = false
}



document.addEventListener("DOMContentLoaded", function() {

	window.addEventListener("message", function (event) {
        app.show = event.data.montrar
        if(app.show) {
            app.carros = event.data.carros
            app.meus_carros = event.data.meus_carros
            app.p_venda = (event.data.p_venda * 100) + "%"
        }
   })

    document.onkeyup = function(data) {
        if (data.which == 27){
            sair()
        }
    }

})


