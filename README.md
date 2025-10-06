# Ecommerce Supabase

## Descrição
API desenvolvida utilizando o Supabase (BaaS) para gerenciamento de um Ecommerce.

## Sobre a API

**Principais funcionalidades**
  - Cadastro de clientes, produtos e pedidos como tabelas no banco, além de views para ajudar na visualização de dados.
  - Policies e RLS implementadas.
  - Funções para auxiliar na automação de processos e triggers para atualizar automaticamente o banco de dados após alterações
  - Edge functions para enviar emails e exportar pedidos (CSV)

## Organização do projeto
```YAML
EcommerceSupabase
  supabase
    functions
      email_pedido_confirmado
        .npmrc
        deno.json
        index.ts
      exportar_pedido_csv
        .npmrc
        deno.json
        index.ts
    migrations
      20251005211127_tables.sql
      20251005211650_functions.sql
      20251005211657_views.sql
      20251005211703_seeds.sql
      20251005211712_rls_policies.sql
      20251005211718_triggers.sql
    config.toml
  .gitignore
  README.md
```

### Explicação do conteúdo dos arquivos

- **EcommerceSupabase**
    - **supabase** - Base do projeto, pasta criada com "supabase init".
        - **functions** - Edge functions criadas via terminal.
            - **email_pedido_confirmado** - Edge function capaz de enviar um email ao cliente (Resend).
              - **.npmrc** 
              - **deno.json** 
              - **index.ts** - Onde a função está escrita.
            - **exportar_pedido_csv** - Edge function que importa o CSV de um pedido.
              - **.npmrc** -
              - **deno.json** - 
              - **index.ts** - Onde a função está escrita.
        - **migrations** - Migrations criadas via terminal
            - **20251005211127_tables.sql** - Criação das tabelas pedidos, pedidos_itens, produtos, clientes.
            - **20251005211650_functions.sql** - Funções para calcular o total de um pedido, atualizar o status do pedido e faturamento total.
            - **20251005211657_views.sql** - Criação das views (resumo de pedidos, itens de pedidos e estoque de produtos).
            - **20251005211703_seeds.sql** - Seeds para povoar o banco.
            - **20251005211712_rls_policies.sql** - Proteção RLS e policies.
            - **20251005211718_triggers.sql** - Triggers para reduzir/ajustar o estoque.
        - **config.toml** - Configurações gerais do projeto.
    - **.gitignore** - Arquivos que não devem ser upados ao github.
    - **README.md** - Este arquivo. 

## Baixando e testando a aplicação

Antes de prosseguirmos, devemos ter Docker devidamente instalado e configurado. Link para download: https://www.docker.com/products/docker-desktop/

Abra o terminal dentro da pasta de sua escolha e rode o seguinte comando:

```BASH
    git clone https://github.com/1alvaropaiva/EcommerceSupabase.git
    cd ./EcommerceSupabase/
```
Isso irá baixar o projeto e acessar a pasta em que ele se encontra.

Para iniciarmos o ambiente de testes, rodamos o seguinte comando:

```BASH
    npx supabase start
```

Esse comando irá subir os containeres do docker automaticamente (podem ser conferidos com o comando "docker ps" no terminal).

Interaja com a versão no Supabase Studio URL (normalmente no http://127.0.0.1:54323/).

## Upando a aplicação no Supabase

Com o terminal aberto na pasta do projeto, digite o comando:

```BASH
    npx supabase login
```
Após isso, siga o passo a passo para realizar o login.

Feito o login, rode o comando: 

```BASH
    npx supabase link --project-ref *ref do seu projeto*
```

Para saber a ref do seu projeto, basta ir no dashboard do seu projeto -> configurações (settings) -> Data API -> Project URL (https:// aqui >> vxtujjqfrrbfwgxklpnv << .supabase.co).

Feito isso, nosso projeto está devidamente configurado e sincronizado, faltando apenas fazer o deploy das migrations e edge functions.

### Deploy das migrations

IMPORTANTE: O arquivo  20251005211703_seeds.sql apenas povoa o banco de dados com dados fictícios. Caso não queira isso, apague o arquivo.

Para uparmos todas as migrations no Supabase, devemos digitar o seguinte comando:

```BASH
    npx supabase db push
```

### Deploy das edge functions

IMPORTANTE: O arquivo  20251005211703_seeds.sql apenas povoa o banco de dados com dados fictícios. Caso não queira isso, apague o arquivo.

Para uparmos as edge functions no Supabase, devemos digitar o seguinte comando:

```BASH
    npx supabase functions deploy
```
Agora, o nosso projeto está devidamente sincronizado com o Supabase cloud.

## Testes

Para testarmos os "endpoints" da nossa aplicação, usarei o Postman. Antes de começarmos, precisamos ter o Postman baixado (ou cURL, caso prefira) e adicionar o bearer token (service_role) e a chave pública (para o header). Conseguimos as chaves no dashboard Supabase -> Settings -> API Keys. 

Antes de começarmos, abrimos a aba Authorization no postman e selecionamos "Bearer token" em auth type, e colamos nossa service_role nela. Nos headers, adicionamos a key "apikey" e colamos nossa chave "anon" (primeira chave) na aba Value. Dessa forma não teremos problemas de autorização ao realizar nossas queries. 

### Clientes

**GET** - Clientes  
https://<SEU PROJECT REF>.supabase.co/rest/v1/clientes

**GET** - Clientes por email  
https://<SEU PROJECT REF>.supabase.co/rest/v1/clientes?email=eq.<EMAIL>

**POST** - Adicionar clientes  
https://<SEU PROJECT REF>.supabase.co/rest/v1/clientes

json:  
{  
  "nome": "Nome aqui",  
  "email": "email@email.com",  
  "endereco": "Av. das Amelias, 34"  
}

### Pedidos

**GET** - Pedidos  
https://<SEU PROJECT REF>.supabase.co/rest/v1/pedidos

**GET** - Pedidos de um cliente  
https://<SEU PROJECT REF>.supabase.co/rest/v1/pedidos?cliente_id=eq.<ID DO CLIENTE>

**PATCH** - Atualizar o status de um pedido  
https://<SEU PROJECT REF>.supabase.co/rest/v1/pedidos?cliente_id=eq.<ID DO CLIENTE> 

json:  
{  
  "status": "<NOVO STATUS>"  
}

**POST** - Calcular total do pedido   
https://<SEU PROJECT REF>.supabase.co/rest/v1/rpc/calcular_total_pedido

json:  
{  
  "pedido": "<ID DO PEDIDO>"  
}

**POST** - Faturamento total  
https://<SEU PROJECT REF>.supabase.co/rest/v1/rpc/faturamento_total

### Edge Functions

**GET** - Exportar CSV (pedido_id)  
https://<SEU PROJECT REF>.supabase.co/functions/v1/exportar_pedido_csv?pedido_id=<ID DO PEDIDO>

**POST** - Email de confirmação.  

**ATENÇÃO**: Usei o Resend para enviar emails, como não possuo um domínio, apenas posso usar o email de testes do Resend (delivery@resend.dev) para enviar o email, e apenas posso receber no meu próprio email (email que está vinculado a minha conta Resend). Antes de prosseguirmos, precisaremos da api key do Resend. Para conseguirmos uma, vamos ao dashboard do Resend -> API Keys -> Create API Key. Após isso, vamos no dashboard Supabase -> Edge Functions -> Secrets e adicionaremos a API Key do Render lá com a key "RESEND_API_KEY". Após isso, os testes devem funcionar normalmente. 

https://<SEU PROJECT REF>.supabase.co/functions/v1/email_pedido_confirmado.

json:  
{  
  "email": "seuemail@email.com",  
  "clienteNome": "Nome",  
  "pedidoId": "<ID PEDIDO>",  
  "endereco": "<ENDERECO>"  
}. :)