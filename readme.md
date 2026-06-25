nhưng bạn giải thích từng step này cho mình :
      - name: Recreate backend config
        if: ${{ github.event.inputs.action == 'destroy' }}
        working-directory: terragrunt/bootstrap/local
        run: |
          chmod +x remote_state.sh
          ./remote_state.sh

      - name: Init remote backend
        if: ${{ github.event.inputs.action == 'destroy' }}
        working-directory: terragrunt/bootstrap/local
        run: |
          terragrunt init --terragrunt-non-interactive

      - name: Destroy Bootstrap
        if: ${{ github.event.inputs.action == 'destroy' }}
        working-directory: terragrunt/bootstrap/local
        run: |
          set -euo pipefail
          terragrunt destroy --auto-approve --terragrunt-non-interactive