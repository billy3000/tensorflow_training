# TensorFlow Training Environment (TSUBAME4.0)

研究室の機械学習学習会用のリポジトリです。TSUBAME4.0上において、Apptainer（Singularity）を用いてGPU対応のTensorFlow（v2.20.0）環境を構築・実行するためのスクリプトを含んでいます。

## 前提環境
- TSUBAME4.0
- Apptainer

## ディレクトリ構成

```

.
├── infra/
│   ├── apptainer/
│   │   └── cfd-unet.def    # コンテナの定義ファイル
│   └── build_sif.sh        # コンテナビルド用スクリプト
└── requirements.txt        # 必要なPythonパッケージ一覧

```

## 使い方

### 1. リポジトリのクローン
```bash
git clone git@github.com:billy3000/tensorflow_training.git
cd tensorflow_training

```

### 2. コンテナのビルド

共有ディレクトリにコンテナがビルドされるスクリプトが用意されています。

```bash
chmod +x infra/build_sif.sh
./infra/build_sif.sh

```

### 3. 動作確認（GPUを利用する場合の注意点）

TSUBAME4.0の計算ノード（またはGPUが割り当てられたインタラクティブジョブ等）で実行する際は、**事前にホスト側のCUDAモジュールをロードする**必要があります。

```bash
# 1. CUDAモジュールのロード（※環境に合わせてバージョンを選択）
module load cuda/12.8.0

# 2. コンテナ内のGPU認識確認
bash test.sh

```

※ `Num GPUs Available: 1`（または2以上）と表示されれば正常にGPUが認識されています。

## ライセンス

このリポジトリのコードは学習会用のものです。無保証（No Warranty）となります。
