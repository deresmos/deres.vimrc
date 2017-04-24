# DereS vimrc
## 概要
日々進歩のvimrcです。
まだベータ版です（書いてないこと多い
自分の使いやすさ優先で設定してます。

まだまだ、使い切れていない機能とかありますが、徐々に埋めていきたい。
「この設定のほうが良いよ」とか、「このプラグイン良いよ」とかあれば、
是非是非教えてください。

## 使い方
Linux, Macの方なら、link.sh実行させれば、使えるようになります。
Vim, Neovimに対応しており、
VimだとLuaや、
Neovimだと、pythonなど必要なものが有りますが、
後日記述します。(init.vimの最初の行にちょろっと書いてます)

## よく使うショートカットキー一覧 
| キーバインド               | 説明                               |
| :--                        | :--                                |
| f d                        | i,vモード中にノーマルモードへ移行  |
| &lt;C-j&gt; or &lt;C-k&gt; | 表示される補間リストなどの行移動   |
| &lt;C-l&gt;                | スニペット展開                     |
| SPC f s                    | ファイル保存                       |
| SPC q q                    | 終了                               |
| SPC f f                    | 現在階層でファインダー表示         |
| &lt;C-t&gt;                | 新規タブで表示                     |
| &lt;C-v&gt;                | 垂直画面で表示                     |
| &lt;C-s&gt;                | 水平画面で表示                     |
| SPC w [h/j/k/l]            | 画面移動                           |
| SPC t [h/j/k/l]            | タブ移動                           |
| SPC w d                    | 現在画面削除                       |
| SPC t d                    | 現在タブ削除                       |
| SPC TAB                    | １つ前のバッファと切り替え         |
| SPC u p                    | 補間が表示されなくなったとき使う   |
| SPC U p                    | プラグインをアップデートする時使う |
| SPC c c                    | コメントアウトトグル               |
| g a * =                    | =を揃えて整形する                  |
| R i w                      | 単語を置き換える(レジスタ汚さない) |
| s a [s/d/b/B]              | 選択した部分を[''/""/()/{}]で囲む  |
| s r a ' "                  | ''で囲まれた部分を"aaa"に変更      |

## ショートカットキー一覧 
### f 
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
| SPC f q      | チェンジリストを表示                  | FufChangeList                                |
| SPC f b f    | ブックマークされたファイルを表示      | FufBookmarkFile                              |
| SPC f b d    | ブックマークされたディレクトリを表示  | FufBookmarkDir                               |

### q
| キーバインド | 説明           | 実行コマンド |
| :--          | ---            | :--          |
| SPC q q      | 閉じる         | q            |
| SPC q Q      | 強制的に閉じる | q!           |

### b
| キーバインド | 説明                       | 実行コマンド       |
| :--          | :--                        | :--                |
| SPC b b      | バッファリストを表示       | Denite buffer      |
| SPC b f      | ファイルをブックマーク     | FufBookmarkFileAdd |
| SPC b d      | ディレクトリをブックマーク | FufBookmarkDirAdd  |
| SPC b d      | ディレクトリをブックマーク | FufBookmarkDirAdd  |
| SPC b s      | 開いているバッファ全て保存 | wa                 |
| SPC b n      | 次のバッファに移動         | bn                 |
| SPC b N      | 前のバッファに移動         | bp                 |
| SPC TAB      | １つ前のバッファと切り替え | b #                |

### p
| キーバインド | 説明                                                | 実行コマンド                                  |
| :--          | :--                                                 | :--                                           |
| SPC p f      | 検知されたルートディレクトリのファイルリストを表示  | DeniteProjectDir file_rec                     |
| SPC p g      | 検知されたルートディレクトリに対してgrep            | DeniteProjectDir grep                         |
| SPC p G      | 検知されたルートディレクトリに対してgrep (tab open) | DeniteProjectDir grep -default-action=tabopen |

### y
| キーバインド | 説明               | 実行コマンド   |
| :--          | :--                | :--            |
| SPC y l      | ヤンクリストを表示 | Denite neoyank |

### t
| キーバインド | 説明                         | 実行コマンド       |
| :--          | :--                          | :--                |
| SPC t c      | 新規にタブを作成             | tabnew             |
| SPC t C      | 同じファイルを新規タブで作成 | tab split          |
| SPC t d      | タブを閉じる                 | tabclose           |
| SPC t O      | 現在のタブ以外閉じる         | tabonly            |
| SPC t l      | 右のタブへ移動               | tabnext            |
| SPC t h      | 左のタブへ移動               | tabprevious        |
| SPC t L      | 現在タブを右に移動           | +tabmove           |
| SPC t H      | 現在タブを左に移動           | -tabmove           |
| SPC t t      | l,h,L,Hでタブ移動系の操作    | submodeで設定      |
| SPC t 1...9  | 1~9のタブ番号いずれかに移動  | tabnext 1...9      |
| SPC t g      | ctagsを作成                  | TagsGenerate       |
| SPC t b      | ctagsの情報を表示            | Tabbar             |
| SPC t f      | ファイルツリーを表示         | NERDTreeToggle     |
| SPC t n      | 行番号の表示トグル           | LineNumberToggle() |

### w
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

### g
| キーバインド | 説明                           | 実行コマンド                  |
| :--          | :--                            | :--                           |
| SPC g s      | Git status実行                 | Gstatus                       |
| SPC g c      | Git commit実行                 | Gcommit                       |
| SPC g d      | Git diff実行                   | Gcommit                       |
| SPC g b      | Git blame実行                  | Gblame                        |
| SPC g p      | Git push実行                   | Gpush                         |
| SPC g m      | Merginal実行                   | Merginal                      |
| SPC g m      | Merginal実行                   | Merginal                      |
| SPC g l      | Git 履歴表示                   | Agit                          |
| SPC g l      | Git ファイル履歴表示           | AgitFile                      |
| SPC g k      | 現在行より前での変更場所に移動 | GitGutterPrevHunk             |
| SPC g j      | 現在行より後での変更場所に移動 | GitGutterNextHunk             |
| SPC g p      | 現在行での変更差分を表示       | GitGutterPreviewHunk          |
| SPC g t t    | 左の差分表示トグル             | GitGutterToggle               |
| SPC g t l    | 差分箇所の行をハイライト       | GitGutterLineHighlightsToggle |

### s
| キーバインド | 説明                         | 実行コマンド |
| :--          | :--                          | :--          |
| SPC s s      | 現在のセッションを保存       | SSave        |
| SPC s l      | 保存済みセッションを読み込み | SLoad        |
| SPC s d      | セッションを削除             | SDelete      |
| SPC s c      | 現在のセッションを閉じる     | SClose       |
| SPC s C      | 現在のセッションを閉じて終了 | SClose and q |

### h
| キーバインド | 説明                   | 実行コマンド                            |
| :--          | :--                    | :--                                     |
| SPC h c      | カレンダー表示         | call qficmemo#Calendar()                |
| SPC h m      | メモファイルを開く     | call qfixmemo#EditDiary('memo.txt')     |
| SPC h s      | 予定ファイルを開く     | call qfixmemo#EditDiary('schedule.txt') |
| SPC h i d    | 日付を挿入             | call qfixmemo#InsertDate('date')        |
| SPC h i t    | 日時を挿入             | call qfixmemo#InsertDate('time')        |
| SPC h l r    | 最近開いたファイル表示 | call qfixmemo#ListMru()                 |
| SPC h l t    | TODOを表示             | call qfixmemo#ListReminder('todo')      |
| SPC h l t    | 予定を表示             | call qfixmemo#ListReminder('schedule')  |
| SPC h p w    | howm仕事モードに変更   | HowmDir work                            |
| SPC h p m    | howmメインモードに変更 | HowmDir main                            |
| SPC h p d    | howm git pull実行      | call pullHowm()                         |
| SPC h p u    | howm git push実行      | call pushHowm()                         |

### r 
| キーバインド | 説明                       | 実行コマンド       |
| :--          | :--                        | :--                |
| SPC r e      | 検索のハイライトをリセット | SearchBuffersReset |
| SPC r p      | 文字列インタラクティブ置換 | OverCommandLine    |
| SPC r v      | loadview                   | loadview           |

### j
| キーバインド | 説明                   | 実行コマンド |
| :--          | :--                    | :--          |
| SPC j v      | ディレクトリツリー表示 | Vaffle       |
| SPC j s      | スタート画面表示       | Startify     |

### c
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

### o
| キーバインド | 説明                         | 実行コマンド                            |
| :--          | :--                          | :--                                     |
| SPC o s      | 指定単語をブラウザで検索する | openbrowser-smart-search                |
| SPC o b      | ブラウザで開く               | execute "OpenBrowser" expand("%:p")<CR> |

### u
| キーバインド | 説明                     | 実行コマンド        |
| :--          | :--                      | :--                 |
| SPC u p      | アップデートなんちゃら   | UpdateRemotePlugins |
| SPC U p      | パッケージのアップデート | call dein#update()  |

### Neovim
| キーバインド | 説明                                     | 実行コマンド    |
| :--          | :--                                      | :--             |
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
