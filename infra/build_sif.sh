#!/bin/bash

# Gitコマンドを使って、実行場所に関係なくリポジトリのルートディレクトリを完全自動で取得する
REPO_ROOT="$(git rev-parse --show-toplevel)"
if [ -z "$REPO_ROOT" ]; then
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    REPO_ROOT="$(cd "$SCRIPT_DIR/../.." 2>/dev/null || cd "$SCRIPT_DIR/.." 2>/dev/null || pwd)"
fi

# ユーザーのホームディレクトリからワークスペースを動的に決定（誰が実行しても自分の /work になる）
USER_HOME="$HOME"
USER_WORK="${USER_HOME/home/work}"

export APPTAINER_CACHEDIR="${USER_WORK}/.apptainer_cache"
export APPTAINER_TMPDIR="${USER_WORK}/.apptainer_tmp"
mkdir -p "$APPTAINER_CACHEDIR" "$APPTAINER_TMPDIR"

OUTPUT_DIR="${USER_WORK}/containers"
mkdir -p "$OUTPUT_DIR"

OUTPUT_SIF="${OUTPUT_DIR}/tf_2.20_jupyter.sif"

# 定義ファイル (.def) のパスを絶対パスで確実に指定
DEF_FILE="${REPO_ROOT}/infra/apptainer/cfd-unet.def"

echo "=== Apptainer Build Start ==="
echo "Repo Root : $REPO_ROOT"
echo "Target Def: $DEF_FILE"
echo "Output SIF: $OUTPUT_SIF"

# --fakeroot フラグを追加して apt-get を許可する
apptainer build --fakeroot "$OUTPUT_SIF" "$DEF_FILE"

echo "=== Jupyter Kernel 登録中 ==="
# コンテナ内のPythonを使って、Apptainerを直接叩くタイプのkernel.jsonを自動生成して登録する
KERNEL_DIR="$HOME/.local/share/jupyter/kernels/tf220_container"
mkdir -p "$KERNEL_DIR"

cat << EOF > "$KERNEL_DIR/kernel.json"
{
 "argv": [
  "apptainer",
  "exec",
  "--nv",
  "$OUTPUT_SIF",
  "python3",
  "-m",
  "ipykernel_launcher",
  "-f",
  "{connection_file}"
 ],
 "display_name": "Python (TensorFlow 2.20 Container)",
 "language": "python",
 "metadata": {
  "debugger": true
 },
 "kernel_protocol_version": "5.5"
}
EOF

echo "ビルドおよびカーネルの自動登録が完了しました！"