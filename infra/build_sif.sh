#!/bin/bash

# Gitコマンドを使って、実行場所に関係なくリポジトリのルートディレクトリを完全自動で取得する
REPO_ROOT="$(git rev-parse --show-toplevel)"

# 万が一git管理外などで取得できない場合のフォールバック（スクリプトの位置から逆算）
if [ -z "$REPO_ROOT" ]; then
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    # infra/ または infra/apptainer/ にある場合を考慮してルートを特定
    REPO_ROOT="$(cd "$SCRIPT_DIR/../.." 2>/dev/null || cd "$SCRIPT_DIR/.." 2>/dev/null || pwd)"
fi

# リポジトリの場所ではなく、ユーザーのホームディレクトリ自体をベースに /work 側を作る
USER_HOME="$HOME"
USER_WORK="${USER_HOME/home/work}"

export APPTAINER_CACHEDIR="${USER_WORK}/.apptainer_cache"
export APPTAINER_TMPDIR="${USER_WORK}/.apptainer_tmp"
mkdir -p "$APPTAINER_CACHEDIR" "$APPTAINER_TMPDIR"

OUTPUT_DIR="${USER_WORK}/containers"
mkdir -p "$OUTPUT_DIR"

OUTPUT_SIF="${OUTPUT_DIR}/tf_2.20.sif"

# 定義ファイル (.def) のパスを絶対パスで確実に指定
DEF_FILE="${REPO_ROOT}/infra/apptainer/cfd-unet.def"

echo "=== Apptainer Build Start ==="
echo "Repo Root : $REPO_ROOT"
echo "Target Def: $DEF_FILE"
echo "Output SIF: $OUTPUT_SIF"

# --fakeroot フラグを追加して apt-get を許可する
apptainer build --fakeroot "$OUTPUT_SIF" "$DEF_FILE"

echo "ビルドが完了しました！"