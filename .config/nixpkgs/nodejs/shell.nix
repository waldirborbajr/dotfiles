{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    nodejs-18_x
    nodePackages.typescript-language-server
    yarn
    helix
    git
    # zsh
  ];

  shellHook = ''
    export LANG=en_US.UTF-8
    export PATH="$PWD/node_modules/.bin/:$PATH"

    alias nr='npm run dev'
    alias ni='npm install'
    alias nl='npm run lint'

    alias l='ls -la'
    alias ll='ls -la'
    alias ys='yarn serve'
    alias yr='yarn dev'
    alias yb='yarn build'
    alias yp='yarn preview'

    echo "=> get VueJS in here"
    # npm i vue @vue/cli
    yarn global add @vue/cli

    # echo "=> get NodeMon in here"
    # npm i -D nodemon
    #
    # echo ="=> get Bulma in here"
    # npm i bulma

    # source ./setup

    echo ""
    echo "That's all folks."
    echo ""
    echo "To start a project type"
    echo ""
    echo "npm init vue@latest"
  '';
}

