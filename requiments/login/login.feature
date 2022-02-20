Feature: Login
Como um cliente 
quero poder acessar minha conta e manter logado
para que eu possa ver e responder  enquetes de forma rápida

Cenário: Credenciais válidas
Dado que o cliente informou credenciais válidas
Quando solicitar para fazer login
Então deve ser redirecionado para a página de pesquisa
E manter o usuário conectado

Cenário: Credenciais Invalidas	
Dado que o cliente informou credenciais inválidas
Quando solicitar para fazer login
Então o sistema deve retornar uma mensagem de erro