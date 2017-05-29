# DereS vimrc
**目次**

- [概要](#概要)
- [使い方](#使い方)
- [よく使うキーバインド](#よく使うキーバインド)
- [移動系キーバインド](#移動系キーバインド)
- [ショートカットキー一覧](#ショートカットキー一覧)
	- [F keybind](#f-keybind)
	- [Q keybind](#q-keybind)
	- [D keybind](#d-keybind)
	- [B keybind](#b-keybind)
	- [P keybind](#p-keybind)
	- [Y keybind](#y-keybind)
	- [T keybind](#t-keybind)
	- [W keybind](#w-keybind)
	- [G keybind](#g-keybind)
	- [S keybind](#s-keybind)
	- [H keybind](#h-keybind)
	- [R keybind](#r-keybind)
	- [J keybind](#j-keybind)
	- [C keybind](#c-keybind)
	- [O keybind](#o-keybind)
	- [M keybind](#m-keybind)
	- [U keybind](#u-keybind)
	- [V keybind](#v-keybind)
- [プラグインショートカット](#プラグインショートカット)
	- [NERDTree](#nerdtree)

## 概要
日々進歩のvim設定たちです。

まだ、使い切れていない機能とかありますが、徐々に埋めていきたい。

## 必要なもの(オプション含む)
動かない機能がある場合は、どれかが入ってない可能性
* Lua
* python3
* Neovim
* Python client to Neovim *(pip install neovim)*
* yapf *(pip install yapf)*
* flake8 *(pip install flake8)*
* isort *(pip install isort)*
* autopep8 *(pip install autopep8)*
* neovim-remote *(pip install neovim-remote)*
* jedi *(pip install jedi)*
* csslint *(npm install -g csslint)*
* jshint *(npm install -g jshint)*

## 使い方
Linux, Macの方なら、link.sh実行させれば、使えるようになります。
Neovimに対応してます。(Vimでも動きますが、いくつか使えないコマンドがあります)

## よく使うキーバインド
| キーバインド               | 説明                                   |
| :--                        | :--                                    |
| f d                        | i,vモード中にノーマルモードへ移行      |
| &lt;C-j&gt; or &lt;C-k&gt; | 表示される補完リストなどの行移動       |
| &lt;C-l&gt;                | スニペット展開                         |
| SPC f s                    | ファイル保存                           |
| SPC q q                    | 終了                                   |
| SPC f f                    | 現在階層でファインダー表示             |
| &lt;C-t&gt;                | 新規タブで表示 (ファインダー上)        |
| &lt;C-v&gt;                | 垂直画面で表示 (ファインダー上)        |
| &lt;C-s&gt;                | 水平画面で表示 (ファインダー上)        |
| SPC w [h/j/k/l]            | 画面移動                               |
| SPC t [h/j/k/l]            | タブ移動                               |
| SPC w d                    | 現在画面削除                           |
| SPC t d                    | 現在タブ削除                           |
| SPC TAB                    | １つ前のバッファと切り替え             |
| SPC s s                    | 現在の状態をセッション保存(名前きめる) |
| SPC u p                    | 補完などが表示されなくなったとき使う   |
| SPC u P                    | プラグインをアップデートする時使う     |
| SPC c c                    | コメントアウトトグル                   |
| SPC m c c                  | 現在ファイルを実行                     |
| g a * =                    | =を揃えて整形する                      |
| R i w                      | 単語を置き換える(レジスタ汚さない)     |
| s a [s/d/b/B]              | 選択した部分を[''/""/()/{}]で囲む      |
| s r a ' "                  | ''で囲まれた部分を"aaa"に変更          |

## 移動系キーバインド
| キーバインド              | 説明                                         |
| :--                       | :--                                          |
| H                         | 現在行の初めに飛ぶ                           |
| L                         | 現在行の最後に飛ぶ                           |
| J                         | 段落の下に移動                               |
| K                         | 段落の上に移動                               |
| m                         | 対となる括弧へ移動                           |
| }                         | 次の行を現在行の後に持ってくる（くっつける） |
| 選択した状態で&lt;C-j&gt; | 選択された文字を一行下に移動                 |
| 選択した状態で&lt;C-k&gt; | 選択された文字を一行上に移動                 |

## ショートカットキー一覧

### F keybind
| キーバインド | 説明                                  | 実行コマンド                                 |
| :--          | :--                                   | :--                                          |
| SPC f f      | 現在階層でファインダー表示            | FufFileWithCurrentBufferDir                  |
| SPC f r      | 最近開いたファイルリスト表示          | Denite file_mru                              |
| SPC f l      | ファイルの各行に対して検索            | Denite line                                  |
| SPC f v      | ファイル中のfoldリストを表示          | Denite line -input=.*\{\{\{                  |
| SPC f g      | 現在階層に対してgrepを実行            | DeniteBufferDir grep                         |
| SPC f G      | 現在階層に対してgrepを実行 (tab open) | DeniteBufferDir grep -default-action=tabopen |
| SPC f s      | ファイルを保存                        | w                                            |
| SPC f q      | ファイルを保存して終了                | wq                                           |
| SPC f q      | ファイル名を変更してから編集          | f&lt;space&gt;                               |
| SPC f c      | 最近実行したコマンド一覧表示          | FufMruCmd                                    |
| SPC f q      | ジャンプリストを表示                  | FufJumpList                                  |
| SPC f h      | チェンジリストを表示                  | FufChangeList                                |
| SPC f b f    | ブックマークされたファイルを表示      | FufBookmarkFile                              |
| SPC f b d    | ブックマークされたディレクトリを表示  | FufBookmarkDir                               |
| SPC f t      | NERDTreeトグル                        | NERDTreeToggle                               |
| SPC f T      | NERDTreeフォーカス                    | NERDTreeForcus                               |
| SPC f F      | 現在のファイルの位置でNERDTreeを開く  | NERDTreeFind                                 |

### Q keybind
| キーバインド | 説明               | 実行コマンド |
| :--          | ---                | :--          |
| SPC q q      | 全て閉じる         | qa           |
| SPC q Q      | 強制的に全て閉じる | qa!          |
| SPC q r      | 置換バッファを開く | Qfreplace    |

### D keybind
| キーバインド | 説明                             | 実行コマンド    |
| :--          | :--                              | :--             |
| SPC d l      | Deniteで前実行した状態を呼び出す | Denite --resume |

### B keybind
| キーバインド | 説明                       | 実行コマンド       |
| :--          | :--                        | :--                |
| SPC b b      | バッファリストを表示       | Denite buffer      |
| SPC b f      | ファイルをブックマーク     | FufBookmarkFileAdd |
| SPC b d      | バッファを削除する         | bdelete            |
| SPC b D      | バッファを削除する（強制） | bdelete!           |
| SPC b s      | 開いているバッファ全て保存 | wa                 |
| SPC b n      | 次のバッファに移動         | bn                 |
| SPC b N      | 前のバッファに移動         | bp                 |
| SPC TAB      | １つ前のバッファと切り替え | b #                |

### P keybind
| キーバインド  | 説明                                                | 実行コマンド                                  |
| :--           | :--                                                 | :--                                           |
| SPC p f       | 検知されたルートディレクトリのファイルリストを表示  | DeniteProjectDir file_rec                     |
| SPC p g       | 検知されたルートディレクトリに対してgrep            | DeniteProjectDir grep                         |
| SPC p G       | 検知されたルートディレクトリに対してgrep (tab open) | DeniteProjectDir grep -default-action=tabopen |
| p &lt;C-p&gt; | ペースト履歴を後ろに遡る                            | neoyank                                       |
| p &lt;C-P&gt; | ペースト履歴を前に遡る                              | neoyank                                       |

### Y keybind
| キーバインド | 説明               | 実行コマンド   |
| :--          | :--                | :--            |
| SPC y l      | ヤンクリストを表示 | Denite neoyank |

### T keybind
| キーバインド | 説明                           | 実行コマンド     |
| :--          | :--                            | :--              |
| SPC t c      | 新規にタブを作成               | tabnew           |
| SPC t C      | 同じファイルを新規タブで作成   | tab split        |
| SPC t d      | タブを閉じる                   | tabclose         |
| SPC t O      | 現在のタブ以外閉じる           | tabonly          |
| SPC t l      | 右のタブへ移動                 | tabnext          |
| SPC t h      | 左のタブへ移動                 | tabprevious      |
| SPC t L      | 現在タブを右に移動             | +tabmove         |
| SPC t H      | 現在タブを左に移動             | -tabmove         |
| SPC t t      | l,h,L,Hでタブ移動系の操作      | submodeで設定    |
| SPC t 1...9  | 1~9のタブ番号いずれかに移動    | tabnext 1...9    |
| SPC t g      | ctagsを作成                    | TagsGenerate     |
| SPC t b      | ctagsの情報を表示              | Tabbar           |
| SPC t f      | ファイルツリーを表示           | NERDTreeToggle   |
| SPC t n      | 行番号の表示トグル             | setlocal number! |
| SPC t o e    | ターミナルを開く               | NTerm            |
| SPC t o v    | vsplitでターミナルを開く       | NTermV           |
| SPC t o s    | splitでターミナルを開く        | NTermS           |
| SPC t o t    | タブでターミナルを開く         | NTermT           |
| SPC t o o    | トグルターミナルを開く         | NTermToggle      |
| SPC t o O    | トグルターミナルを開く         | 30NTermToggle    |
| SPC t o 2    | ターミナルを開く(2画面)        | NTerm            |
| SPC t o 3    | ターミナルを開く(3画面)        | NTerm            |
| SPC t o d    | 現在開いてるターミナル以外削除 | NTermDeletes     |
| SPC t o D    | 全てのターミナル削除           | NTermDeleteAll   |

### W keybind
| キーバインド | 説明                              | 実行コマンド       |
| :--          | :--                               | :--                |
| SPC w s      | 下に画面分割                      | split              |
| SPC w v      | 右に画面分割                      | vsplit             |
| SPC w d      | 画面を閉じる                      | close              |
| SPC w D      | 下の画面を閉じる                  | &lt;C-w&gt;j:close |
| SPC w O      | 現在の画面以外閉じる              | only               |
| SPC w l      | 右の画面に移動                    | &lt;C-w&gt;l       |
| SPC w h      | 左の画面に移動                    | &lt;C-w&gt;h       |
| SPC w j      | 下の画面に移動                    | &lt;C-w&gt;j       |
| SPC w k      | 上の画面に移動                    | &lt;C-w&gt;k       |
| SPC w L      | 現在の画面を右に移動              | &lt;C-w&gt;L       |
| SPC w H      | 現在の画面を左に移動              | &lt;C-w&gt;H       |
| SPC w J      | 現在の画面を下に移動              | &lt;C-w&gt;J       |
| SPC w K      | 現在の画面を上に移動              | &lt;C-w&gt;K       |
| SPC w w      | l,h,j,k,L,H,J,Kで画面移動系の操作 | submodeで設定      |
| SPC w c c    | l,h,j,kで画面の大きさ変更         | submodeで設定      |
| SPC w =      | 全ウィンドウを同一に              | &lt;C-w&gt;=       |

### G keybind
| キーバインド | 説明                                   | 実行コマンド                  |
| :--          | :--                                    | :--                           |
| SPC g s      | Git status実行                         | Gstatus                       |
| SPC g c      | Git commit実行                         | Gcommit                       |
| SPC g d      | Git diff実行                           | Gdiff                         |
| SPC g b      | Git blame実行                          | Gblame                        |
| SPC g p      | Git push実行                           | Gpush                         |
| SPC g m      | Merginal実行                           | Merginal                      |
| SPC g l      | Git 履歴表示                           | Agit                          |
| SPC g f      | Git ファイル履歴表示                   | AgitFile                      |
| SPC g k      | 現在行より前での変更場所に移動         | GitGutterPrevHunk             |
| SPC g j      | 現在行より後での変更場所に移動         | GitGutterNextHunk             |
| SPC g p      | 現在行での変更差分を表示               | GitGutterPreviewHunk          |
| SPC g t t    | 左の差分表示トグル                     | GitGutterToggle               |
| SPC g t s    | 左の差分マークトグル                   | GitGutterSignsToggle          |
| SPC g t l    | 差分箇所の行をハイライト               | GitGutterLineHighlightsToggle |
| g f          | カーソル下のファイルを開く             | gf                            |
| g F          | カーソル下のファイルをタブで開く       | g&lt;C-w&gt; gf               |
| g S          | カーソル下のファイルをsplitで開く      | wincmd f                      |
| g V          | カーソル下のファイルをvsplitで開く     | vertical wincmd f             |
| g /          | その場から飛ばずにインクリメンタル検索 | -                             |
| g a          | 決めた文字で整形                       | EasyAlign                     |

### S keybind
| キーバインド | 説明                            | 実行コマンド   |
| :--          | :--                             | :--            |
| SPC s s      | 現在のセッションを保存          | SSave          |
| SPC s S      | 現在のセッションをtmp名前で保存 | SSave tmp      |
| SPC s l      | 保存済みセッションを読み込み    | SLoad          |
| SPC s d      | セッションを削除                | SDelete        |
| SPC s c      | 現在のセッションを閉じる        | SClose         |
| SPC s C      | 現在のセッションを閉じて終了    | SClose and qa! |
| SPC s w      | 複数検索する                    | SearchBuffers  |

### H keybind
| キーバインド | 説明                     | 実行コマンド                                          |
| :--          | :--                      | :--                                                   |
| SPC h c      | カレンダー表示           | call qficmemo#Calendar()                              |
| SPC h m      | メモファイルを開く       | call qfixmemo#EditDiary('memo.txt')                   |
| SPC h s      | 予定ファイルを開く       | call qfixmemo#EditDiary('schedule.txt')               |
| SPC h t      | 本日の日記ファイルを開く | call qfixmemo#EditDiary('%Y/%m/%Y-%m-%d-000000.howm') |
| SPC h i d    | 日付を挿入               | call qfixmemo#InsertDate('date')                      |
| SPC h i t    | 日時を挿入               | call qfixmemo#InsertDate('time')                      |
| SPC h l r    | 最近開いたファイル表示   | call qfixmemo#ListMru()                               |
| SPC h l t    | TODOを表示               | call qfixmemo#ListReminder('todo')                    |
| SPC h l s    | 予定を表示               | call qfixmemo#ListReminder('schedule')                |
| SPC h p w    | howm仕事モードに変更     | HowmDir work                                          |
| SPC h p m    | howmメインモードに変更   | HowmDir main                                          |
| SPC h p d    | howm git pull実行        | call pullHowm()                                       |
| SPC h p u    | howm git push実行        | call pushHowm()                                       |

### R keybind
| キーバインド | 説明                                  | 実行コマンド               |
| :--          | :--                                   | :--                        |
| SPC r e      | 検索のハイライトをリセット            | noh and SearchBuffersReset |
| SPC r p      | 現在カーソル上の文字を文字列置換      | %s                         |
| SPC r v      | loadview                              | loadview                   |
| SPC r n      | ファイル名をvim操作で編集             | Renamer                    |
| SPC r s      | Renamerで編集したファイル名に変更する | Ren                        |

### J keybind
| キーバインド | 説明                         | 実行コマンド |
| :--          | :--                          | :--          |
| SPC j v      | ディレクトリツリー表示       | Vaffle       |
| SPC j s      | スタート画面表示             | Startify     |
| SPC j j      | 2つ文字選択して画面内に飛ぶ  | Easymotion   |
| SPC j g      | 複数文字選択して画面内に飛ぶ | Easymotion   |

### C keybind
| キーバインド | 説明                               | 実行コマンド           |
| :--          | :--                                | :--                    |
| SPC c n      |                                    | NERDCommenterNested    |
| SPC c y      |                                    | NERDCommenterYank      |
| SPC c m      | 最小でコメントアウト               | NERDCommenterMinimal   |
| SPC c c      | コメントアウトトグル               | NERDCommenterToggle    |
| SPC c s      | ブロックコメント追加               | NERDCommenterSexy      |
| SPC c i      | 一行最初から最後までコメントアウト | NERDCommenterToEOL     |
| SPC c A      | 末尾にコメントアウト追加           | NERDCommenterAppend    |
| SPC c x      | ディレクトリツリー表示             | NERDCommenterAltDelims |

### O keybind
| キーバインド | 説明                         | 実行コマンド                            |
| :--          | :--                          | :--                                     |
| SPC o s      | 指定単語をブラウザで検索する | openbrowser-smart-search                |
| SPC o b      | ブラウザで開く               | execute "OpenBrowser" expand("%:p")<CR> |
| SPC o m      | マークダウンプレビュー       | MarkdownPreview                         |

### M keybind
| キーバインド | 説明                                     | 実行コマンド    |
| :--          | :--                                      | :--             |
| SPC m a      | マークしたaに移動                        | \`a             |
| SPC m s      | マークしたsに移動                        | \`s             |
| SPC m d      | マークしたdに移動                        | \`d             |
| SPC m A      | aとしてマーク登録                        | mark a          |
| SPC m B      | aとしてマーク登録                        | mark s          |
| SPC m D      | aとしてマーク登録                        | mark d          |
| SPC m =      | 自動でフォーマットを整える               | Autoformat      |
| SPC m c c    | 現在のファイルを実行                     | QuickRun        |
| SPC m c v    | 現在のファイルを実行(vsplit)             | QuickRun        |
| SPC m c s    | 現在のファイルを実行(split)              | QuickRun        |
| SPC m c o    | 現在のファイルを実行してファイルに出力   | QuickRun        |
| SPC m c l    | 実行エラーをリスト表示                   | lwindow         |
| SPC m f y    | pep8でフォーマット（pythonのみ）         | pep8            |
| SPC m f i    | isortでフォーマット（pythonのみ）        | isort           |
| SPC m f =    | 自動でフォーマットを整える（pythonのみ） | yapf pep8 isort |
| SPC m e e    | Emmet実行                                | &lt;C-y&gt;,    |
| SPC m e u    | 指定タグの属性編集                       | &lt;C-y&gt;u    |
| SPC m e d    | 指定タグ全体を選択                       | &lt;C-y&gt;d    |
| SPC m e n    | 次入力するべきところに移動               | &lt;C-y&gt;n    |
| SPC m e N    | 前で入力するべきところに移動             | &lt;C-y&gt;N    |

### U keybind
| キーバインド | 説明                     | 実行コマンド        |
| :--          | :--                      | :--                 |
| SPC u p      | アップデートなんちゃら   | UpdateRemotePlugins |
| SPC u P      | パッケージのアップデート | call dein#update()  |
| SPC u t      | undoツリーを表示         | UndotreeToggle      |
| SPC u T      | undoツリーにフォーカス   | UndotreeFocus       |

### V keybind
| キーバインド | 説明        | 実行コマンド |
| :--          | :--         | :--          |
| SPC v g      | vimgrepする | vimgrep /^v/ |

## プラグインショートカット
### NERDTree
| キーバインド | 説明                           |
| :--          | :--                            |
| SPC f t      | NERDTree開くトグル             |
| SPC f T      | NERDTreeフォーカス             |
| SPC f F      | 現在のファイルの位置でNERDTree |
| v            | 選択中ファイルを縦分割で表示   |
| s            | 選択中ファイルを横分割で表示   |
| l            | 階層進む&amp;ファイル開く      |
| L            | 選択したディレクトリに移動     |
| h            | １つ前の階層戻る               |
| m            | ディレクトリ操作メニュー表示   |
| p            | ルートに飛ぶ                   |
| P            | 現在のルートに飛ぶ             |
| I            | 隠しファイル表示トグル         |

