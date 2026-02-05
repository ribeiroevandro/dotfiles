function convert_mov --description 'Convert MOV to MP4 using ffmpeg'
    set -l DESKTOP_PATH "$HOME/Desktop"
    set -l CURRENT_PATH $PWD

    cd $DESKTOP_PATH

    set -l MOV_FILES (find . -maxdepth 1 -type f \( -iname "*.mov" \) -exec basename {} \;)

    # Obter a quantidade de itens
    set -l total (count $MOV_FILES)

    if test (count $MOV_FILES) -eq 0
        gum style --foreground 196 "Nenhum arquivo .mov encontrado no Desktop"
        cd $CURRENT_PATH
        return 1
    end

    set -l height (math "min(max($total + 2, 5), 15)")

    # Selecionar arquivo da lista filtrada
    set -l INPUT (printf '%s\n' $MOV_FILES | gum filter \
                             --indicator.foreground 46 \
                             --indicator="❯" \
                             --placeholder "Selecione o arquivo .mov" \
                             --height $height)

    if test -z "$INPUT"
        gum style --foreground 196 "Nenhum arquivo selecionado. Saindo..."
        cd (string replace '~' $HOME $CURRENT_PATH)
        return 1
    end

    if not string match -qr '^/' $INPUT
        set INPUT "$DESKTOP_PATH/$INPUT"
    end

    set -l NAME (gum input --placeholder "Nome do arquivo de saída") || return 1

    set NAME (string replace -a ' ' '_' $NAME)

    # Confirmar ação
    gum style --foreground 45 "Arquivo selecionado: $INPUT"
    gum style --foreground 45 "Nome escolhido: $NAME"
    gum confirm "Está tudo certo?" || return 1

    # Iniciar conversão
    gum spin --title "Convertendo vídeo..." -- ffmpeg -i "$INPUT" -c:v libx264 -crf 24 -r 40/1 -c:a aac -strict experimental "$NAME.mp4"

    if test $status -eq 0
        gum style --foreground 46 "Conversão concluída com sucesso!"

        cd (string replace '~' $HOME $CURRENT_PATH)
    else
        gum style --foreground 196 "Erro durante a conversão."
        exit 1
    end
end
