# WellBlog

App iOS e API para criação e visualização de posts.

No arquivo [desafio.pdf](desafio.pdf) contem a descrição do desafio. A definição nos recomenda a criar duas pastas chamadas [API](Readme.md#API) e [APP](Readme.md#APP) que deverá conter a implementação da Web API e a aplicação iOS respectivamente. Sendo assim, iremos construir essa documentação falando sobre Tecnologias, Instalação, Uso e Implementação de ambas em separado.

## API

### Tecnologias

- **Linguagem / Framework**: C# com ASP.NET
- **Bando de dados**: SQL Server da Microsoft
- **IDE**: Visual Studio Code
- **Hospedagem**: https://freeasphosting.net/
- **Design Pattern**: MVC

### Instalação

1. Instale o .NET SDK (Software Development Kit). Para verificar se ele está instalado corretamente na sua máquina, execute no terminal:
```shell
$ dotnet
```
2. Com o repositório baixado, execute o comando para iniciar a execução do servidor:
```shell
$ cd WellBlog/API
$ dotnet watch
```
3. Em seguida, será aberta uma janela no seu navegador dando maiores informações sobre a aplicação.

### Uso

Você pode executar a API localmente executando o comando `dotnet run` na pasta root do projeto, porém a forma de uso ideal é acessando o URL https://wellblog.bsite.net que hospeda tanto a API quanto o Banco de dados e também é a mesma URL que a aplicação iOS está utilizando como padrão para as requisições.

### Implementação

A aplicação é focada em Posts, sendo assim, a primeira tarefa é definir um modelo que represente esse objeto. Os seus atributos são:
- `id`: Identificador único do tipo Inteiro (Criado pela API).
- `title`: Título do Post do tipo String (Criado pelo cliente, no nosso caso, a aplicação iOS). 
- `description`: Texto do Post do tipo String (Criado pelo cliente, no nosso caso, a aplicação iOS).
- `createdAt`: Data de criação do Post (Criado pela API baseado no UTC).

Segue a definição do modelo em SQL:
```sql
CREATE TABLE [dbo].[Post] (
    [id]          INT      IDENTITY (1, 1) NOT NULL,
    [title]       TEXT     NOT NULL,
    [description] TEXT     NOT NULL,
    [createdAt]   DATETIME NOT NULL,
    CONSTRAINT [id] PRIMARY KEY CLUSTERED ([id] ASC)
);
```

Com esse modelo, foram criadas 4 requisições que nos permitisse operar sobre esse modelo de forma simples e efetiva:
- `[GET] api/posts/{id}`: Busca um Post baseado no seu identificador.
- `[GET] api/posts?page={page}&pageSize={pageSize}`: Busca uma lista de Posts de forma paginada. A paginação deve ser administrada pelo cliente sendo que a primeira página sempre sera a com número 1 e o tamanho padrão de cada página é 10.
- `[POST] api/posts`: Cria um Post enviando no corpo da requisição apenas o título e o texto porque os demais dados são criados pelo servidor.
```json
{
  "title": "Título",
  "description": "Conteúdo"
}
```
- `[DELETE] api/posts/{id}`: Remove um Post baseado no seu identificador.