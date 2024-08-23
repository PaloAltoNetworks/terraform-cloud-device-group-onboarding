# Commit Script for Cloud NGFW Device Group Onboarding

This script commits all device groups to Panorama and push the configuration to a Cloud Device Group you specify

The first trailing CLI arg is the commit comment. If there is no CLI arg present then no commit comment is given to PAN-OS

```
$ curl https://raw.githubusercontent.com/PaloAltoNetworks/terraform-cloudngfw-panorama-onboarding/main/scripts/commit.go > commit.go
$ go mod init example/user/panos-commit
$ go mod tidy
$ go build commit.go
$ mv commit ~/bin
$ commit -h
```