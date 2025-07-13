# Terraform GKE + Anthos + Monitoring

Ce projet déploie :
- Un cluster GKE standard
- Anthos Service Mesh (Istio)
- Prometheus + Grafana + Loki via Helm
- Une application de démonstration avec sidecar Istio

## Déploiement

```bash
terraform init
terraform apply
./scripts/enable-asm.sh <PROJECT_ID> <CLUSTER_NAME> <REGION>
kubectl apply -f demo-app/deployment.yaml
```