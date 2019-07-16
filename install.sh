prompt() {
    echo -n "$1 already exists. Overwrite? [Yn]"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        return 0
    else
        return 1
    fi
}

install_file() {
    local should_link="No"
    if [ -f $HOME/$1 ]; then
        if prompt "$HOME/$1"; then
            mv -f $HOME/$1 $HOME/$1.bak
            should_link="Yes"
        fi
    else
        should_link="Yes"
    fi
    if [ $should_link == "Yes" ]; then
        ln -s `pwd`/$1 $HOME/$1
        return 0
    else
        return 1
    fi
}


os=$(uname)

if [ $os == "Linux"]; then
    install_file .ubunturc
fi

if [ $os == "Darwin"]; then
    install_file .macrc
fi


install_file .gitconfig

install_file .tmux.conf

install_file tmux.completion.bash

install_file git-completion.bash

install_file .vim

if install_file .vimrc; then
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | \
        sh -s -- $HOME/.vim/bundle
            vim -c "call dein#update()|quit"
fi
