# Avantsoft Project API

API para gerenciamento de clientes e vendas, com estatísticas e autenticação.

## Pré-requisitos

- Docker & Docker Compose instalados
- Ruby 3.4.5
- Bundler (`gem install bundler`)

---

## Configuração com Docker Compose

O projeto utiliza Docker Compose para subir o banco PostgreSQL.

0. Com base no arquivo `.env.example` crie os seguintes arquivos: `.env.development` e `.env.test` e configure conforme necessário.

1. Suba os containers com:

```bash
docker compose up -d
```

3. Faça o setup inicial (criar banco, rodar migrations e seeds) com o comando abaixo:
   OBS: A seed irá criar um usuário admin e alguns poucos registros para as tabelas de `clients` e `sales`.

```bash
rails db:setup
```

---

## Rodando a aplicação

Para iniciar o servidor Rails, execute:

```bash
rails server
ou
r s (atalho)
```

A API ficará disponível em:

```
http://localhost:3000
```

---

## Executando os testes

O projeto utiliza **RSpec** + **Rswag**.

1. Para rodar os testes RSpec comuns:

```bash
bundle exec rspec
```

2. Para gerar a documentação Swagger via Rswag:

```bash
RAILS_ENV=test rails rswag
```

- Isso executa os testes de integração que também alimentam o Swagger com exemplos reais.

---

## Acessando a documentação Swagger

O Swagger UI está disponível dentro da aplicação Rails:

```
http://localhost:3000/api-docs
```

- Aqui você verá todos os endpoints documentados.
- Os exemplos de request/response vêm diretamente dos testes executados pelo **Rswag**.
- Você pode testar os endpoints diretamente pelo Swagger UI, usando o token gerado ao fazer login para autenticação.
