package main

import (
	"context"
)

type Home struct {}

// example usage: "dagger call unit-test --app system/cert-manager --env dev"
func (m *Home) UnitTest(ctx context.Context, app *Directory, env string) (string, error) {
	return dag.Container().
		From("alpine:3.19.1").
		WithExec([]string{"apk", "add", "--no-cache", "git", "kubectl", "kustomize", "helm"}).
		WithEnvVariable("KUBEBUILDER_TOOLS_VERSION", "1.29.1").
		WithExec([]string{"sh", "-c", "wget https://storage.googleapis.com/kubebuilder-tools/kubebuilder-tools-${KUBEBUILDER_TOOLS_VERSION}-linux-amd64.tar.gz -O - | tar -xvz -C /usr/local"}).
		WithEnvVariable("KUTTL_VERSION", "0.15.0").
		WithExec([]string{"sh", "-c", "wget https://github.com/kudobuilder/kuttl/releases/download/v${KUTTL_VERSION}/kubectl-kuttl_${KUTTL_VERSION}_linux_x86_64 -O /usr/local/bin/kubectl-kuttl && chmod +x /usr/local/bin/kubectl-kuttl"}).
		WithEnvVariable("KFILT_VERSION", "0.0.8").
		WithExec([]string{"sh", "-c", "wget https://github.com/ryane/kfilt/releases/download/v${KFILT_VERSION}/kfilt_${KFILT_VERSION}_linux_amd64 -O /usr/bin/kfilt && chmod +x /usr/bin/kfilt"}).
		WithMountedDirectory("/mnt", app).
		WithWorkdir("/mnt/" + env).
		WithExec([]string{"kubectl", "kuttl", "test"}).
		Stdout(ctx)
}
