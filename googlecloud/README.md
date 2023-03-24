# Google Cloud workload identity federation with GitHub Actions
## Authenticate by specific branchs or environments

この Terraform コードは、Google Cloud に以下のものを作成します。
- オーナー `komazarari` のレポジトリで実行される workflows を認識する Workload Identity Pool
- 3つのサービスアカウントとそれぞれのロール。および、特定の条件下でそれぞれの権限を借用するための設定

### workload_identity
[workload_identity.tf](./workload_identity.tf) は、Workload Identity Pool を作成します。このプールは、`komazarari` 以下のリポジトリを認識するよう条件設定しています。また、GitHub から提供される claim をプールの属性にマップしています。マップされた属性は、サービスアカウントの権限借用の条件に使用できます。

### service_accounts

[service_account.tf](./service_account.tf) は、それぞれ foo、bar、baz のサフィックスのついた3つのサービスアカウントを作成します。

各サービスアカウントは以下のように権限の借用条件を設定しています。
- foo は、このレポジトリの `main` ブランチから実行された workflow に権限の借用を許可しています。
- bar は、このレポジトリの ``develop` ブランチから実行された workflow に権限の借用を許可しています。
- baz は、Environment `production` で実行された workflow に権限の借用を許可しています。プールには `komazarari/*` レポジトリが認識されるようにしているため、これらのレポジトリで Environment `production` で実行されたものに権限の借用を許可していることになります。