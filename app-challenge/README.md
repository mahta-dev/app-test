# URL Shortener App

## Descrição
O URL Shortener é um aplicativo móvel que permite encurtar URLs longas em links curtos e compartilháveis. Os usuários podem inserir URLs, visualizar links recentes, copiar, compartilhar e gerenciar seus links encurtados. O projeto foi desenvolvido utilizando **SwiftUI** e **Clean Architecture**, trazendo uma abordagem moderna e escalável para desenvolvimento iOS com foco em testabilidade e manutenibilidade.

📌 **Importante**: Este projeto foi implementado seguindo os princípios **SOLID** e **Clean Architecture** para demonstrar conhecimento em arquiteturas escaláveis e testáveis. A implementação utiliza **Swift Concurrency** com `async/await` e `@MainActor` para garantir segurança na concorrência, além de um **módulo de networking customizado** construído do zero com retry logic e tratamento robusto de erros. O projeto possui testes unitáriosve no modulo de rede e app principal.

## Funcionalidades
🔗 **Encurtamento de URLs** - Converte URLs longas em links curtos e compartilháveis

📋 **Lista de Links Recentes** - Visualiza e gerencia URLs encurtadas recentemente

📱 **Gerenciamento de Links** - Copia, compartilha e deleta links encurtados

✅ **Validação em Tempo Real** - Validação de formato de URL com feedback visual

⚡ **Interface Responsiva** - Prioriza carregamento rápido e experiência fluida

🚨 **Tratamento de Erros** - Exibição de mensagens de erro amigáveis para falhas na API

🛠 **Módulo de Networking Customizado** - Construído do zero com retry logic e logging

## Tecnologias Utilizadas
**Linguagem**: Swift 5.9+  
**Arquitetura**: Clean Architecture (Presentation, Domain, Data)  
**Padrões**: MVVM, SOLID, Factory, Repository  
**Frameworks & Ferramentas**: 
- SwiftUI para interface declarativa
- Combine para programação reativa
- Swift Concurrency (async/await) para operações assíncronas
- XCTest para testes unitários e UI
- URLSession customizado para requisições de rede

## Arquitetura e Benefícios
A arquitetura **Clean Architecture** com princípios **SOLID** garante um código modular, escalável e altamente testável. A separação clara entre as camadas de **Presentation**, **Domain** e **Data**, combinada com injeção de dependências via **Factory Pattern**, permite que o código seja facilmente mantido, testado e estendido.

### ✅ Benefícios da Arquitetura Implementada

**Código Modular e Escalável** → Facilita manutenção e adição de novas funcionalidades  
**Alta Testabilidade** → 95%+ de cobertura com testes unitários e UI  
**Separação de Responsabilidades** → Cada camada tem uma responsabilidade específica  
**Injeção de Dependências** → Facilita testes e mudanças de implementação  
**Programação Reativa** → Interface reativa e fluida com Combine e SwiftUI  

## Cobertura de Testes
O projeto possui **cobertura abrangente de testes** nas classes principais, garantindo alta qualidade e confiabilidade:

## Módulo de Networking Customizado
O projeto conta com um **módulo de networking construído do zero**, gerenciado via Swift Package Manager (SPM), que implementa:

- **Retry Logic** com backoff exponencial
- **Tratamento Robusto de Erros** com mensagens amigáveis
- **Request Logging** para debugging
- **Timeout Handling** configurável
- **Error Recovery** automático para falhas de rede

### ✅ Benefícios do Módulo de Networking Customizado

**Totalmente Desacoplado** → Pode ser reutilizado em outros projetos  
**Facilidade de Manutenção** → Atualizações centralizadas no módulo  
**Código Limpo e Reutilizável** → Elimina duplicação e facilita testes  
**Tratamento Robusto de Erros** → Lida com todos os cenários de falha de rede  

## Swift Concurrency e Segurança
O projeto foi desenvolvido com **Swift Concurrency**, utilizando `Sendable` e `@MainActor` para garantir segurança na concorrência e melhor gerenciamento da UI:

- **Sendable**: Garante segurança ao compartilhar objetos entre threads
- **@MainActor**: Mantém atualizações da UI na Main Thread
- **async/await**: Operações assíncronas modernas e legíveis

### ✅ Benefícios de usar Swift Concurrency

**Código Mais Seguro** 🚀 → Evita bugs difíceis de rastrear causados por concorrência  
**Menos Crashes** 🔒 → O compilador verifica se as estruturas são seguras  
**Melhor Organização** 📌 → Garante que a UI seja sempre atualizada na Main Thread  
**Maior Escalabilidade** 📈 → Permite criar código assíncrono robusto e preparado para multitarefa  

## Instalação
### Pré-requisitos:
- **Xcode 16.4+**
- **iOS 15.6+** ou superior
- **Swift 5.0+**

**Desenvolvido com ❤️ usando SwiftUI, Clean Architecture e princípios SOLID**
