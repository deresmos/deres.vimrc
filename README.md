# DereS vimrc
**目次**

- [概要](#概要)
- [対応Vim](#対応vim)
- [インストール方法](#インストール方法)
- [使い方](#使い方)

## 概要
日々進歩のvim設定たちです。

## 対応Vim
* [Neovim](https://neovim.io/)
* [IdeaVim](https://github.com/JetBrains/ideavim)

## インストール方法
### リスト
* [Python3](#python3)
* [python-client](#python-client)
* [Neovim](#neovim)
* [揃ったら](#揃ったら)

### Python3
Python3が実行できる環境を作成しましょう。
パッケージ管理でインストールしてもよいでしょう。
筆者は[Miniconda](https://conda.io/miniconda.html)をオススメします。

### python-client
[Python client to Neovim](https://github.com/neovim/python-client) をインストールしましょう。
```sh
pip install neovim
```

### Neovim
Neovimをインストールしましょう。
[インストール方法](https://github.com/neovim/neovim/wiki/Installing-Neovim)

### 揃ったら
Linux, Macの方なら、setup.sh実行させれば、使えるようになります。
Neovimに対応してます。(Vimでも動きますが、いくつか使えないコマンドがあります)
```sh
./setup.sh
```

## 使い方
[Wiki参照](https://github.com/deresmos/deres.vimrc/wiki)

## License
Released under the MIT license, see LICENSE.
