# WellBlog

App iOS e API para criação e visualização de posts.

No arquivo [desafio.pdf](desafio.pdf) contem a descrição do desafio. A definição nos recomenda a criar duas pastas chamadas [API](API) e [APP](APP) que deverá conter a implementação da Web API e a aplicação iOS respectivamente. Sendo assim, iremos construir essa documentação falando sobre Tecnologias, Instalação, Uso e Implementação de ambas em separado.

## Sobre o projeto

A primeira tarefa definitivamente foi a criação dos Projects e do Board aqui no Github mesmo para organização de tarefas e necessidades de ambas as aplicações. Tais projetos podem ser encontrados aqui: [WellBlog API 1.0.0](https://github.com/users/wnhirsch/projects/4) e [WellBlog iOS 1.0.0](https://github.com/users/wnhirsch/projects/5).

O GitFlow do projeto funciona da seguinte forma:
- `main` é branch principal que contém o mesmo código que está em produção.
- `api` e `app` são as "develop" de cada aplicação.
- `api#XXX` e `app#XXX` são as branchs de tarefa de cada tecnologia onde `#XXX` é o número da tarefa no Board.
- Todos os merges para cima na hierarquia (`main` > `api` e `app` > `api#XXX` e `app#XXX`) devem ser feitos por meio de Pull Request.
- Commits devem começar com o número das tarefas do Board relacionadas ao commit.

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

Você pode executar a API localmente executando o comando `dotnet run` na pasta root do projeto, porém a forma de uso ideal é acessando o URL https://wellblog.bsite.net (Não disponível desde 13/07/2023) que hospeda tanto a API quanto o Banco de dados e também é a mesma URL que a aplicação iOS está utilizando como padrão para as requisições.

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

## APP

### Tecnologias

- **Linguagem / Framework**: Swift com Storyboard
- **IDE**: Xcode
- **Design Pattern**: MVVM-C
- **FrameWorks Nativas**: Combine
- **Frameworks de Terceiros**: CocoaPods com Alamofire, Moya e Snapkit
- **Testes**: Testes Unitários com XCTest

### Instalação

1. Garanta que você possui o Xcode e CocoaPods instalados e o repositório baixado na sua máquina

2. Abra o terminal dentro do repositório e efetue a instalação das frameworks:
```shell
$ cd WellBlog/APP
$ pod install
```

3. Abra o arquivo [WellBlog.xcworkspace](APP/WellBlog.xcworkspace) com o Xcode.

### Implementação

Optei por utilizar Storyboard com MVVM-c para garantir a melhor organização de código e suporte a diversas versões de sistema. A organização do projeto pode ser resumidos em 3 diretórios:
- **API**: Contém todas as configurações API e definição das requisições.
- **Core**: Contém diversos arquivos auxiliares que podem ser utilizados em qualquer contexto do App, como Extensões, Componentes de UI, Strings localizadas, Protocolos, entre outros.
- **Scenes**: Contém os fluxos da nossa aplicação. Cada diretório dentro desse grupo representa um fluxo e dentro de cada fluxo existem a definição de cada uma de suas telas e demais arquivos auxiliares globais do fluxo, como Coordinator, Models e Workers. Para cada tela, existe uma View, uma ViewController, uma ViewModel e também pode haver componentes que se classificariam como SubViews.

Sendo assim, a aplicação se inicia com o [Coordinator.App](APP/WellBlog/Core/Coordinator/Coordinator.App.swift) que invoca o Coordinator do fluxo de Post e ele por sua vez invoca as telas que precisa. A porta de entrada de cada tela é a sua respectiva ViewController que cria uma View para exibir a UI e uma ViewModel para obter e computar dados. A View e a ViewModel não se comunicam diretamente, essa comunicação é intermediada pela ViewController por meio de Observables e Subscribers fornecidos pela framework Combine.

Além dessas informações, também estarei compartilhando a justificativa de algumas decisões de implementação que ao ler o código pode criar confusão:
- Na Tela de Listagem eu recebo todos os atributos de um Post, sendo assim, eu não precisaria fazer uma requisição na Tela de Detalhes porque tudo que eu preciso já está na memória do aplicativo. Mesmo assim, optei por chamar novamente para mostrar uma requisição distinta a que eu tinha chamado e gerar mais complexidade na aplicação, porém entendo que só seria necessário se por acaso na Tela de Listagem o app não recebesse todos os atributos.
- Mesmo a API não exigindo que o cliente envie um tamanho para paginação, optei por deixar possível essa escolha para deixar disponível para teste de volume ou relacionados.
