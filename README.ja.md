
# Ralph Loop：汎用AIコーディングエージェント・ループ

このリポジトリは、特定のAIエージェントに依存しない「Ralph」自律型コーディングループのパターンを実装したものです。Claude、Codex、Gemini、あるいは Ollama / Qwen 経由のローカルモデルなど、どのAIエージェントを使用する場合でも、Ralph Loop が処理全体を統括します。

> **Ralphとは何か**
> Ralphは以下を行う bash ループです。
>
> 1. コンテキスト用プロンプトとタスクリスト（`prd.json`）をAIエージェントに渡します。
> 2. エージェントがストーリーを1つ選択し、実装・テスト実行・コミット・進捗更新を行います。
> 3. すべてのストーリーが完了とマークされるまで、このループを繰り返します。

## 🚀 セットアップ

中核となる仕組みは `` に配置されています。

0. **クローン**：このリポジトリをプロジェクトにクローンします。
1. **バックログを定義する**
   `prd.json` を編集し、ユーザーストーリーを記述します。
2. **環境を設定する**
   プロジェクト内に、エージェントが実行できるテストコマンド（例：`npm test`、`cargo test`）が用意されていることを確認します。
3. **実行権限を付与する**
   `chmod +x ./ralph-loop/ralph.sh`

## 🏃 使い方

`./ralph-loop/ralph.sh` スクリプトを実行し、第一引数として使用するエージェントのCLIコマンドを渡します。第二引数として最大反復回数を指定できます（デフォルトは10回）。このスクリプトは、エージェントが **標準入力（stdin）** 経由でプロンプトを受け取ることを前提としています。

```bash
./ralph-loop/ralph.sh "<YOUR_AGENT_COMMAND>" [最大反復回数]
```

### 使用例

#### Claude Code（Anthropic）

```bash
# 最大20回まで繰り返す場合
./ralph-loop/ralph.sh "claude --dangerously-skip-permissions" 20
```

#### Codex CLI

OpenAI の自律型エージェントCLIです。

```bash
# --full-auto は確認プロンプトを省略します（ヘッドレス実行に必須）
./ralph-loop/ralph.sh "codex exec --full-auto" 20
```

#### Gemini CLI

Google の生成AIエージェントCLIです。

```bash
# --yolo は自律的なアクション実行を有効にします
./ralph-loop/ralph.sh "gemini --yolo" 20
```

#### Qwen Code

Alibaba の Qwen エージェントCLIです。
※ 自律実行のために「YOLOモード」の設定が必要です。

```bash
# 1. .qwen/settings.json を更新し、完全自律モードを許可します
#    { "permissions": { "defaultMode": "yolo" } }
# 2. Ralph を実行します（qwen が stdin を受け取る前提）
./ralph-loop/ralph.sh "qwen" 20
```

## 📁 ファイル構成

* `ralph-loop/ralph.sh`：メインのループスクリプト
* `prd.json`：プロダクト要件／バックログ
* `progress.txt`：永続的なメモリおよび学習内容のログ
* `prompt.md`：各ループで毎回エージェントに渡されるシステムプロンプト

## 🧠 メモリとコンテキスト管理

Ralph は以下を通じて状態と学習内容を保持します。

1. **Git履歴**：エージェントが作成したコミット
2. **`progress.txt`**：実施内容および発見された知見（パターンや注意点）の記録
3. **`prd.json`**：各ストーリーの成功／失敗状態の管理

## 特定エージェント向けのカスタマイズ

エージェントが stdin ではなく引数としてプロンプトを受け取る必要がある場合は、`ralph-loop/ralph.sh` を直接修正するか、小さなラッパースクリプトを作成します。

**ラッパー例（agent-wrapper.sh）：**

```bash
#!/bin/bash
# stdin を変数に読み込む
PROMPT=$(cat)
# explicit-agent --prompt "$PROMPT"
```

その後、以下のように実行します。

```bash
./ralph-loop/ralph.sh "./agent-wrapper.sh"
```
