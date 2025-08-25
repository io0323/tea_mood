# TeaMood 🍵

TeaMoodは、お茶の摂取記録・気分のログ・カフェイン量のトラッキング・グラフによる可視化を提供するヘルス系Flutterアプリです。ユーザーが日々の茶摂取量と気分を記録し、健康意識を高める目的で設計されています。

## 🌟 主な機能

### 📱 記録機能
- **お茶の記録**: 茶種、量、温度、気分、カフェイン強度を記録
- **時間選択**: DateTimePickerで記録時間を選択
- **メモ機能**: お茶に関するメモを追加

### 📅 カレンダー機能
- **月間カレンダー**: `table_calendar`パッケージを使用
- **日別記録表示**: タップで記録内容の詳細表示
- **マーカー表示**: 記録がある日をマーカーで表示

### 📊 分析機能
- **統計サマリー**: 期間別のお茶摂取回数、カフェイン量
- **カフェイン推移**: 折れ線グラフでカフェイン摂取量の推移を表示
- **気分分布**: 円グラフで気分の分布を可視化
- **茶種分布**: 円グラフでお茶の種類別分布を表示

## 🏗️ アーキテクチャ

このアプリは**クリーンアーキテクチャ**で設計されています：

```
lib/
├── core/           # 共通ロジック・ユーティリティ
│   ├── constants/  # アプリ定数
│   └── di/         # 依存性注入
├── data/           # ローカルDB・リポジトリ実装
│   └── repositories/
├── domain/         # エンティティ・リポジトリ抽象・ユースケース
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/   # UI・状態管理
    ├── screens/
    ├── widgets/
    └── providers/
```

## 🛠️ 使用技術

### 状態管理
- **flutter_riverpod**: リアクティブな状態管理

### ローカルデータベース
- **hive**: NoSQLローカルデータベース
- **hive_flutter**: Flutter用Hiveアダプター

### UI・UX
- **Material Design 3**: モダンなUIデザイン
- **fl_chart**: データ可視化（グラフ・チャート）
- **table_calendar**: カレンダーウィジェット

### その他
- **get_it**: 依存性注入
- **intl**: 国際化・日付フォーマット
- **flutter_slidable**: スライド可能なリストアイテム
- **shared_preferences**: 設定保存

## 📦 インストール・実行

### 前提条件
- Flutter SDK (3.0.0以上)
- Dart SDK (3.0.0以上)
- Android Studio / VS Code

### セットアップ
```bash
# リポジトリをクローン
git clone https://github.com/io0323/tea_mood.git
cd tea_mood

# 依存関係をインストール
flutter pub get

# アプリを実行
flutter run
```

### プラットフォーム対応
- ✅ iOS
- ✅ Android
- ✅ macOS
- ✅ Web
- ✅ Windows
- ✅ Linux

## 🎯 使用方法

### 1. お茶を記録
1. ホーム画面の「お茶を記録」ボタンをタップ
2. 茶種、量、温度、気分を選択
3. 記録時間を設定
4. メモを追加（任意）
5. 「保存」ボタンをタップ

### 2. カレンダーで確認
1. カレンダー画面に移動
2. 日付をタップして記録を確認
3. 記録をタップして詳細表示・編集

### 3. 分析で統計確認
1. 分析画面に移動
2. 期間を選択（7日間・14日間・30日間）
3. 統計情報とグラフを確認

## 📊 データ構造

### TeaLog エンティティ
```dart
class TeaLog {
  final String id;           // ユニークID
  final String teaType;      // 茶種（green, black, oolong, etc.）
  final int caffeineMg;      // カフェイン量（mg）
  final int temperature;     // 温度（℃）
  final DateTime dateTime;   // 記録日時
  final String mood;         // 気分（relaxed, focused, etc.）
  final int amount;          // 量（ml）
  final String? notes;       // メモ（任意）
}
```

## 🔧 開発

### コード生成
```bash
# Hiveアダプターを生成
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### テスト
```bash
# ユニットテストを実行
flutter test

# 統合テストを実行
flutter test integration_test
```

## 📝 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 🤝 コントリビューション

プルリクエストやイシューの報告を歓迎します！

## 📞 サポート

問題や質問がある場合は、[GitHub Issues](https://github.com/io0323/tea_mood/issues)でお知らせください。

---

**TeaMood** - お茶と気分で健康管理 🍵✨
