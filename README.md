# Rsync Deployments

Rsync files from a GitHub repo to a destination server over SSH

## Environment variables

| Variable           | Description                                                                                                                      |
|--------------------|----------------------------------------------------------------------------------------------------------------------------------|
| `SSH_PRIVATE_KEY`  | The private key part of an SSH key pair. The public key part should be added to the `authorized_keys` on the destination server. |
| `SSH_USERNAME`     | The username to use when connecting to the destination server                                                                    |
| `SSH_HOSTNAME`     | The hostname of the destination server                                                                                           |
| `SSH_CONFIG`       | Override the SSH config (/gh-rsync/.ssh/config) file                                                                             |

```sh
# The `SSH_PRIVATE_KEY` will be stored in `/gh-rsync/.ssh/deploy_key`
# It can be referenced in a `SSH_CONFIG` like:

Host example.com
  IdentityFile /gh-rsync/.ssh/deploy_key
```

## Required arguments

| Argument           | Description                                                                                                                                          |
|--------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| `RSYNC_OPTIONS`    | Rsync-specific options when running the command. Exclusions, deletions, etc                                                                          |
| `RSYNC_TARGET`     | Where to deploy the files on the server                                                                                                              |
| `RSYNC_SOURCE`     | What files to deploy from the repo (starts at root) **NOTE**: a trailing `/` deploys the _contents_ of the directory instead of the entire directory |

## Example usage

```yaml
name: Deploy to Environment

on: pull_request

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v1

      - name: Deploy via rsync
        uses: bnnanet/github-actions-rsync@master
        with:
          RSYNC_OPTIONS: -avzr --delete --exclude node_modules --exclude '.git*'
          RSYNC_TARGET: /path/to/target/folder/on/server
          RSYNC_SOURCE: /src/public/
        env:
          SSH_PRIVATE_KEY: ${{secrets.SSH_PRIVATE_KEY}}
          SSH_USERNAME: ${{secrets.SSH_USERNAME}}
          SSH_HOSTNAME: ${{secrets.SSH_HOSTNAME}}
          SSH_CONFIG: ${{secrets.SSH_CONFIG}}
```

## Disclaimer

Check your keys. Check your deployment paths. And use at your own risk!
