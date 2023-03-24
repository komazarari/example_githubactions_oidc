# Google Cloud workload identity federation with GitHub Actions

(Followd by english version)
## ブランチや Environment ごとに異なる権限を借用する

この Terraform コードは、Google Cloud に以下のものを作成します。
- オーナー `komazarari` のレポジトリで実行される workflows を認識する Workload Identity Pool
- 特定条件下でそれぞれの権限を借用を許可する3つのサービスアカウント

### workload_identity
[workload_identity.tf](./workload_identity.tf) は、`komazarari` 以下のリポジトリで実行される workflow をプリンシパルとして認識する Workload Identity Pool を作成します。このプールでは GitHub から提供される claim の一部をプール内属性にマップします。マップされた属性はサービスアカウント権限借用条件として使用可能です。

### service_accounts

[service_account.tf](./service_account.tf) は、foo、bar、baz のサフィックスのついた3つのサービスアカウントを作成します。各サービスアカウントは以下のように権限の借用条件が設定されます。

- foo: このレポジトリの `main` ブランチから実行された workflow
- bar: このレポジトリの `develop` ブランチから実行された workflow
- baz: Environment `production` で実行された workflow

baz: においてはレポジトリを限定する条件が書かれていません。プールは `komazarari` 以下のすべてのレポジトリを認識するよう条件設定されているため、Environment `production` で実行される `komazarari` 以下レポジトリの workflow 全体に権限の借用を許可していることになります。仮に、プール側に条件がない場合、この設定は GitHub 全体の Environment `production` で実行される workflow に権限の借用を許可してしまいます。

-----------------------

## Authorization for each specific branch or environment
This Terraform code creates the following in Google Cloud:

- A Workload Identity Pool that recognizes workflows executed in the repository owned by `komazarari`
- Three service accounts with specific roles and configurations to allow impersonation from the workflows under certain conditions

### workload_identity
The [workload_identity.tf](./workload_identity.tf) file creates a Workload Identity Pool that is configured to recognize repositories under `komazarari` (my repos). It also maps claims provided by GitHub to attributes of the pool. The mapped attributes can be used as conditions for impersonate service account permissions.

### service_accounts
The service_account.tf file creates three service accounts with suffixes -foo, -bar, and -baz. Each service account is configured to allow impersonation under the following conditions:

- foo: workflows executed on the main branch of this repository.
- bar: workflows executed on the develop branch of this repository.
- baz: workflows executed with Environment `production`.

**Note**: About baz, since the pool recognizes repositories under `komazarari/*`, it allows workflows of any repositories under `komazarari/*` with Environemnt `production`. If the pool had NO conditions, this configuration would enable workflows of any repositories in GitHub with Environment `production` to impersonate the service account and be insecure.
