set -euo pipefail

aws sts get-caller-identity

cd terragrunt/bootstrap/local

terragrunt run-all validate

terragrunt plan --terragrunt-non-interactive

terragrunt apply --auto-approve --terragrunt-non-interactive

chmod +x remote_state.sh
./remote_state.sh 

terragrunt init -migrate-state -force-copy -terragrunt-non-interactive

terragrunt init --terragrunt-non-interactive

terragrunt destroy --auto-approve --terragrunt-non-interactive