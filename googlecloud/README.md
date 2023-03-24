# Google Cloud workload identity federation with GitHub Actions
## Authenticate by specific branchs or environments

この Terraform コードは、Google Cloud に以下のものを作成します。
- オーナー `komazarari` のレポジトリで実行される workflows を認識する Workload Identity Pool
- 特定条件下でそれぞれの権限を借用するための設定をもつ3つのサービスアカウント

### workload_identity
[workload_identity.tf](./workload_identity.tf) は、`komazarari` 以下のリポジトリで実行される workflow をプリンシパルとして認識する Workload Identity Pool を作成します。このプールでは GitHub から提供される claim の一部をプール内属性にマップします。マップされた属性はサービスアカウント権限借用条件として使用可能です。

### service_accounts

[service_account.tf](./service_account.tf) は、foo、bar、baz のサフィックスのついた3つのサービスアカウントを作成します。各サービスアカウントは以下のように権限の借用条件が設定されます。

- foo: このレポジトリの `main` ブランチから実行された workflow
- bar: このレポジトリの `develop` ブランチから実行された workflow
- baz: Environment `production` で実行された workflow

baz: においてはレポジトリを限定する条件が書かれていません。プールは `komazarari` 以下のすべてのレポジトリを認識するよう条件設定されているため、Environment `production` で実行される `komazarari` 以下レポジトリの workflow 全体に権限の借用を許可していることになります。仮に、プール側に条件がない場合、この設定は GitHub 全体の Environment `production` で実行される workflow に権限の借用を許可してしまいます。
