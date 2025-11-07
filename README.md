# 🍅 MyPomodoro

**Um Timer Pomodoro Moderno e Eficiente Construído com SwiftUI e o Padrão MVVM/Combine.**

MyPomodoro é um aplicativo de produtividade *open source* que implementa a técnica Pomodoro de forma elegante e robusta. Ele oferece sincronização de configurações em tempo real, tratamento de *background* para precisão do timer e uma arquitetura limpa em Swift.



## ✨ Funcionalidades Principais

* **Ciclos Clássicos:** Foco, Pausa Curta e Pausa Longa (configuráveis).
* **Persistência de Configurações:** Todas as durações e opções de automação são salvas usando o `AppStorage`.
* **Notificações Inteligentes:** Alertas de fim de ciclo no *background* com cancelamento de requisição.
* **Contagem Precisa:** Recálculo robusto do tempo restante ao voltar do *background* (`reconcileTime`) para garantir precisão.
* **Automação:** Opções de iniciar automaticamente o próximo ciclo de Foco ou Pausa.

## 📐 Arquitetura do Projeto (MVVM + Combine)

O projeto segue estritamente o padrão **Model-View-ViewModel (MVVM)**, utilizando o **Combine** para reatividade e gerenciamento do fluxo de dados.

A arquitetura se destaca pela clara separação de responsabilidades entre os ViewModels:

| Componente | Responsabilidade | Tecnologia |
| :--- | :--- | :--- |
| **`PomodoroViewModel`** | **Lógica de Domínio.** Gerenciamento do `Timer`, transição de estados (`.running`, `.paused`, etc.), controle de ciclos e integração com `UserNotifications`. | `@ObservableObject`, `@MainActor`, `Timer`, `Combine`. |
| **`SettingsViewModel`** | **Lógica de Persistência e Configuração.** Proprietário exclusivo de todo o `@AppStorage` e responsável por sincronizar as configurações da UI com o `PomodoroViewModel`. | `@ObservableObject`, `@AppStorage`, Combine (`sink`, `assign`). |
| **Views** | **Camada de Apresentação.** Exibição do estado reativo fornecido pelos ViewModels. | `SwiftUI`. |

### 📂 Estrutura de Arquivos

A estrutura do projeto é modular e segue a organização por domínio (App, PomodoroMain, Settings) e tipo de componente.

Para uma visão detalhada da organização de pastas e arquivos, consulte o documento:
[`Docs/project_structure.md`](Docs/project_structure.md)

## 🤖 Ferramentas de IA Utilizadas

O desenvolvimento do MyPomodoro foi aprimorado com o auxílio de ferramentas de Inteligência Artificial:

* **Gemini AI:** Utilizado para ajustes e otimizações de código, sugestões de refatoração, e para a criação de ativos visuais, incluindo o ícone do aplicativo.
* **Appscreens.com:** Empregado na geração de *screenshots* atraentes e padronizados para a App Store, garantindo uma apresentação profissional do aplicativo.

## 🚀 Publicado na App Store\!

MyPomodoro está disponível na App Store! Baixe agora e aumente sua produtividade:

**[Link para o App na App Store]**

## 🛠️ Instalação e Execução

Para rodar o MyPomodoro localmente, você precisa do **Xcode 15+** e do SDK do iOS.

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/SeuUsuario/MyPomodoro.git](https://github.com/SeuUsuario/MyPomodoro.git)
    cd MyPomodoro
    ```
2.  **Abra o projeto no Xcode:**
    ```bash
    open MyPomodoro.xcodeproj
    ```
3.  **Execute (Cmd + R)** em um simulador ou dispositivo iOS.

## 🤝 Contribuições

Este projeto é *open source* e incentiva a colaboração. Se você tiver uma sugestão de *feature* ou quiser implementar uma melhoria na arquitetura (como modularizar o serviço de notificações), sinta-se à vontade para abrir uma **Issue** ou um **Pull Request**.

## 📄 Licença

Este projeto está sob a licença **MIT License**. Para mais detalhes, consulte o arquivo [`LICENSE`](LICENSE).

---
