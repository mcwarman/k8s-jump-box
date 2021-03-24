# K8s Jump Box

There are times when you need to test connectivity or access services that are
only accessible in a cluster. This image is designed to service that need installing
packages commonly used to assist.

## Usage

```shell
kubectl run mcwarman --image=ghcr.io/mcwarman/k8s-jump-box:1 -i -t --image-pull-policy=Always --restart=Never --rm
```
