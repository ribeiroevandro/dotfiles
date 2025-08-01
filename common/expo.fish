function apps -d "Gerencia apps Expo"
    set cmd $argv[1]
    switch $cmd
        case ''
            apps help
        case 'build'
            if test (count $argv) -lt 2
                echo "Uso: app build <android|ios>"
            else
                switch $argv[2]
                    case 'android'
                        eas build --platform android
                    case 'ios'
                        eas build --platform ios
                    case '*'
                        echo "Plataforma desconhecida: $argv[2]"
                end
            end
        case 'prebuild'
            if test (count $argv) -lt 2
                echo "Uso: app prebuild <android|ios> [clean]"
            else
                set platform $argv[2]
                set clean_flag ''
                if test (count $argv) -ge 3; and test $argv[3] = 'clean'
                    set clean_flag '--clean'
                end
                switch $platform
                    case 'android' 'ios'
                        npx expo prebuild -p $platform $clean_flag
                    case '*'
                        echo "Plataforma desconhecida: $platform"
                end
            end
        case 'doctor'
            npx expo-doctor
        case 'help'
            echo ""
            echo "Uso: app <comando> [args]"
            echo ""
            echo "Comandos disponíveis:"
            echo "  build <android|ios>             - Executa build para a plataforma escolhida"
            echo "  prebuild <android|ios> [clean]  - Executa prebuild para a plataforma, com opção de limpeza"
            echo "  doctor                          - Executa o expo-doctor"
            echo "  help                            - Mostra esta mensagem de ajuda"
            echo ""
        case '*'
            echo "Comando desconhecido: $cmd"
            echo "Use 'app help' para ver os comandos disponíveis."
    end
end
