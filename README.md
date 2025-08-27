# projeto_704apps

Mobility Watch 🎤📱

Aplicativo Flutter para monitoramento e transcrição de áudio em tempo real ou segundo plano, com integração a APIs de transcrição de voz (Google Speech-to-Text ou Whisper API).

📌 Funcionalidades

  🎙️ Gravação de áudio com Flutter Sound

  🔄 Envio periódico de áudio para processamento (a cada 30 segundos no modo AUTO)

  🤖 Transcrição automática com IA (Whisper API ou Google STT)

  ⚡ Execução em segundo plano usando Workmanager

🎛️ Interface simples com botões:

  AUTO → grava e processa em segundo plano

  ON → grava apenas uma vez no foreground

  OFF → encerra o serviço

🚀 Como rodar o projeto
  1. Clonar o repositório
    git clone https://github.com/seu-usuario/mobility-watch.git
    cd mobility-watch

  2. Instalar dependências
    flutter pub get

  3. Rodar em modo debug
    flutter run

  4. Gerar APK (para instalar no celular)
    flutter build apk --release

   5. Gerar AAB (para Play Store)
    flutter build appbundle --release

  O arquivo será gerado em:
    build/app/outputs/flutter-apk/app-release.apk

🔑 Permissões necessárias

  O app utiliza:

  🎤 Microfone → para capturar o áudio

  💾 Armazenamento → salvar temporariamente os chunks de áudio

  🔔 Notificações → manter serviço em segundo plano

No Android, essas permissões já estão configuradas no AndroidManifest.xml.

🛠️ Tecnologias

  Flutter

  Workmanager
   → tarefas em segundo plano

  Flutter Sound
   → captura de áudio

  Permission Handler
   → permissões

Este projeto está sob a licença MIT.
Sinta-se livre para usar, modificar e distribuir.
