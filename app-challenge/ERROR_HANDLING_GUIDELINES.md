# 🚨 Error Handling Guidelines

## 📋 **RequestError é o Padrão para TODO o Projeto**

### ✅ **O que usar:**
- **SEMPRE** use `RequestError` para erros de rede e API
- **SEMPRE** use `RequestError` para erros de parsing/decodificação
- **SEMPRE** use `RequestError` para erros de timeout
- **SEMPRE** use `RequestError` para erros de cancelamento

### ❌ **O que NÃO fazer:**
- **NUNCA** crie enums de erro customizados para operações de rede
- **NUNCA** use `NSError` ou `URLError` diretamente
- **NUNCA** use strings simples para erros
- **NUNCA** use `fatalError` ou `preconditionFailure`

## 🎯 **Tipos de RequestError Disponíveis**

```swift
public enum RequestError: Error, Sendable, LocalizedError, Equatable {
    case invalidURL                    // URL inválida
    case invalidResponse              // Resposta inválida
    case httpError(statusCode: Int, message: String?, data: SafeDictionary?)  // Erros HTTP
    case decodingError(String)        // Erros de decodificação
    case networkError(String)         // Erros de rede
    case timeout                      // Timeout
    case cancelled                    // Cancelamento
}
```

## 🔧 **Como Usar RequestError**

### **1. Em Services:**
```swift
func fetchData() async throws -> Data {
    do {
        return try await requestManager.request(endpoint: myEndpoint)
    } catch {
        // RequestError já é retornado automaticamente pelo RequestManager
        throw error
    }
}
```

### **2. Em ViewModels:**
```swift
func loadData() {
    executeAsyncOperation { [weak self] in
        guard let self = self else { 
            throw RequestError.networkError("Service unavailable") 
        }
        return try await self.service.fetchData()
    }
}
```

### **3. Em Error Models:**
```swift
struct MyErrorModel {
    init(from error: Error) {
        if let requestError = error as? RequestError {
            // Mapear RequestError para UI
            self.title = getTitle(for: requestError)
            self.message = requestError.errorDescription
            self.suggestion = requestError.recoverySuggestion
        }
    }
}
```

## 📱 **Benefícios do RequestError**

### **1. Consistência:**
- Todos os erros seguem o mesmo padrão
- Interface uniforme em toda a aplicação
- Fácil manutenção e debugging

### **2. Informações Ricas:**
- `errorDescription`: Descrição amigável
- `failureReason`: Razão técnica
- `recoverySuggestion`: Sugestões de ação

### **3. Funcionalidades Avançadas:**
- Suporte a HTTP status codes
- Tratamento de timeout e cancelamento
- Retry automático baseado no tipo de erro
- Logging estruturado

## 🏗️ **Arquitetura de Erro**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Network       │    │   Service       │    │   ViewModel     │
│   Layer         │───▶│   Layer         │───▶│   Layer         │
│                 │    │                 │    │                 │
│ RequestError    │    │ RequestError    │    │ APODErrorModel  │
│ (automático)    │    │ (propagado)     │    │ (para UI)       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📝 **Exemplos de Uso**

### **Erro de Rede:**
```swift
throw RequestError.networkError("Connection failed")
```

### **Erro HTTP:**
```swift
throw RequestError.httpError(statusCode: 404, message: "Not found", data: nil)
```

### **Erro de Decodificação:**
```swift
throw RequestError.decodingError("Failed to parse JSON")
```

### **Timeout:**
```swift
throw RequestError.timeout
```

## ⚠️ **Regras Importantes**

1. **SEMPRE** importe o módulo Network quando usar RequestError
2. **SEMPRE** use `RequestError` em vez de criar enums customizados
3. **SEMPRE** mapeie RequestError para modelos de UI quando necessário
4. **SEMPRE** forneça mensagens descritivas para `networkError` e `decodingError`

## 🔍 **Verificação de Conformidade**

Para verificar se o projeto está seguindo as diretrizes:

```bash
# Buscar por enums de erro customizados
grep -r "enum.*Error" app-challenge/

# Buscar por throws que não usam RequestError
grep -r "throw.*Error" app-challenge/

# Verificar se RequestError está sendo importado
grep -r "import Network" app-challenge/
```

---

**🎯 Lembre-se: RequestError é o padrão para TODO o projeto!**
