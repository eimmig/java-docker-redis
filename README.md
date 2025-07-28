# CodeChella API

Uma API REST desenvolvida em Spring Boot para um sistema de eventos musicais, implementando cache com Redis e containerização com Docker.

## 🚀 Tecnologias Utilizadas

- **Java 17**
- **Spring Boot 3.2.2**
- **Spring Security** - Autenticação e autorização
- **Spring Data JPA** - Persistência de dados
- **Spring Cache** - Sistema de cache
- **Spring Data Redis** - Cache distribuído
- **MySQL 8.0** - Banco de dados
- **Flyway** - Migração de banco de dados
- **JWT** - Autenticação por tokens
- **Docker & Docker Compose** - Containerização
- **Nginx** - Load balancer e proxy reverso
- **Maven** - Gerenciamento de dependências

## 📋 Funcionalidades

- **Autenticação JWT**: Sistema de login e autenticação de usuários
- **Gerenciamento de Eventos**: CRUD de eventos musicais
- **Compra de Ingressos**: Sistema de compra e validação de ingressos
- **Cache Redis**: Cache de próximos eventos para melhor performance
- **Envio de Emails**: Notificações por email (configurável)
- **Load Balancing**: Múltiplas instâncias da aplicação com Nginx

## 🏗️ Arquitetura

A aplicação segue os princípios de Clean Architecture com separação clara de responsabilidades:

```
src/main/java/br/com/alura/codechella/
├── controller/          # Controladores REST
├── domain/             # Regras de negócio
│   ├── autenticacao/   # Domínio de autenticação
│   ├── evento/         # Domínio de eventos
│   └── email/          # Domínio de email
└── infra/              # Infraestrutura
    ├── email/          # Implementações de email
    ├── exception/      # Tratamento de exceções
    └── security/       # Configurações de segurança
```

## 🐳 Docker

### Serviços Containerizados

- **MySQL**: Banco de dados principal
- **Redis**: Cache distribuído
- **App (2 instâncias)**: Aplicação Spring Boot
- **Nginx**: Load balancer

### Configuração do Ambiente

1. **Crie os arquivos de ambiente necessários:**

```bash
mkdir env nginx
```

2. **Arquivo `env/mysql.env`:**
```env
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=codechella
MYSQL_USER=app
MYSQL_PASSWORD=app123
```

3. **Arquivo `env/app.env`:**
```env
SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/codechella?createDatabaseIfNotExist=true
SPRING_DATASOURCE_USERNAME=app
SPRING_DATASOURCE_PASSWORD=app123
SPRING_DATA_REDIS_HOST=redis
SPRING_DATA_REDIS_PORT=6379
APP_SECURITY_JWT_SECRET=minha-chave-secreta-jwt-muito-segura
```

4. **Arquivo `nginx/default.conf`:**
```nginx
upstream app {
    server app-1:8080;
    server app-2:8080;
}

server {
    listen 80;
    
    location / {
        proxy_pass http://app;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 🚀 Como Executar

### Usando Docker (Recomendado)

1. **Clone o repositório:**
```bash
git clone <repository-url>
cd java-docker-redis
```

2. **Configure os arquivos de ambiente conforme mostrado acima**

3. **Execute com Docker Compose:**
```bash
docker-compose up -d
```

4. **A aplicação estará disponível em:**
   - **API**: http://localhost (através do Nginx)
   - **Instâncias diretas**: http://localhost:8080 e http://localhost:8081

### Desenvolvimento Local

1. **Pré-requisitos:**
   - Java 17+
   - Maven 3.6+
   - MySQL 8.0
   - Redis

2. **Configure o banco de dados MySQL e Redis localmente**

3. **Execute a aplicação:**
```bash
./mvnw spring-boot:run
```

## 📚 API Endpoints

### Autenticação
- `POST /login` - Autenticação de usuário
- `POST /usuarios` - Cadastro de usuário

### Eventos
- `GET /eventos` - Lista próximos eventos (com cache)
- `GET /eventos/{id}` - Detalhes de um evento
- `POST /eventos` - Cadastra novo evento

### Compras
- `POST /compra` - Realiza compra de ingresso

## 💾 Cache Redis

O sistema implementa cache para otimizar consultas frequentes:

- **Cache de Eventos**: Os próximos eventos são cacheados para reduzir consultas ao banco
- **Invalidação**: O cache é automaticamente invalidado quando novos eventos são cadastrados

### Configuração do Cache

```java
@Cacheable(value = "proximosEventos")
public List<DadosEvento> listarProximosEventos() {
    // Implementação
}

@CacheEvict(value = "proximosEventos", allEntries = true)
public DadosEvento cadastrar(DadosCadastroEvento dados) {
    // Implementação
}
```

## 🗄️ Banco de Dados

### Migrations Flyway

- `V001__autenticacao.sql` - Estrutura de usuários e autenticação
- `V002__eventos.sql` - Estrutura de eventos e ingressos
- `V003__cria_indice_ingressos_disponiveis.sql` - Otimizações de performance

### Pool de Conexões HikariCP

```properties
spring.datasource.hikari.minimum-idle=25
spring.datasource.hikari.maximum-pool-size=50
spring.datasource.hikari.connectionTimeout=10000
spring.datasource.hikari.idleTimeout=600000
spring.datasource.hikari.maxLifetime=1800000
```

## 🔒 Segurança

- **JWT Authentication**: Tokens seguros para autenticação
- **Spring Security**: Proteção de endpoints
- **CORS**: Configurado para permitir requisições de frontend
- **Validation**: Validação de dados de entrada

## 📊 Monitoramento

- **Health Checks**: Verificação de saúde dos serviços
- **Logs estruturados**: Para facilitar debugging
- **Graceful shutdown**: Finalização controlada dos serviços

## 🛠️ Desenvolvimento

### Build da Aplicação

```bash
./mvnw clean package
```

### Testes

```bash
./mvnw test
```

### Build da Imagem Docker

```bash
docker build -t codechella-api .
```

## 📝 Notas Importantes

1. **Configuração de Produção**: Lembre-se de alterar as senhas e chaves secretas em produção
2. **Volumes Docker**: Os dados do MySQL são persistidos no volume `mysql-data`
3. **Load Balancing**: O Nginx distribui as requisições entre as duas instâncias da aplicação
4. **Cache**: O Redis mantém o cache entre reinicializações da aplicação

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.
