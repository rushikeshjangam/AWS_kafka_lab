Here is a **ready-to-use rebuild guide** as a Markdown file for your repo:

---

### eks-strimzi-rebuild-guide.md

````markdown
# AWS EKS + Strimzi Kafka Rebuild Guide

This guide helps you **rebuild your AWS EKS cluster** with Strimzi Kafka and KafkaBridge after tearing it down. Use these steps for a clean, repeatable setup.

---

## Prerequisites
- AWS CLI v2 installed and configured (`aws configure`)
- kubectl (latest)
- Terraform (latest)
- Key pair (e.g., `eks-kafka`) created and imported into AWS EC2
- All the provided Terraform files (`main.tf`, `vpc.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars`) in a directory, e.g., `/mnt/e/Repo/AWS_kafka_lab`

---

## 1. Clone or Prepare Your Repo

```bash
cd /mnt/e/Repo/AWS_kafka_lab
````

Place the following files here (use your last working versions):

* `main.tf`
* `vpc.tf`
* `variables.tf`
* `outputs.tf`
* `terraform.tfvars`

---

## 2. Initialize and Apply Terraform

```bash
terraform init
terraform apply -auto-approve
```

This will recreate:

* VPC
* Subnets
* EKS Cluster (3 nodes, t3.medium)

---

## 3. Configure kubectl for EKS

```bash
aws eks --region us-east-1 update-kubeconfig --name kafka-cluster
kubectl get nodes
```

You should see 3 nodes in `Ready` state.

---

## 4. Install Strimzi Operator

```bash
kubectl create namespace kafka
kubectl apply -f https://strimzi.io/install/latest?namespace=kafka -n kafka
```

---

## 5. Deploy Kafka Cluster and KafkaBridge

**Create `kafka-cluster.yaml`**

```yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: my-cluster
  namespace: kafka
spec:
  kafka:
    version: 3.6.0
    replicas: 3
    listeners:
      - name: plain
        port: 9092
        type: internal
        tls: false
    storage:
      type: persistent-claim
      class: gp3
      size: 10Gi
      deleteClaim: true
  zookeeper:
    replicas: 3
    storage:
      type: persistent-claim
      class: gp3
      size: 10Gi
      deleteClaim: true
  entityOperator:
    topicOperator: {}
    userOperator: {}
```

**Apply:**

```bash
kubectl apply -f kafka-cluster.yaml -n kafka
```

---

**Create `kafka-bridge.yaml`**

```yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaBridge
metadata:
  name: my-bridge
  namespace: kafka
spec:
  replicas: 1
  bootstrapServers: my-cluster-kafka-bootstrap:9092
  http:
    port: 8080
  consumer:
    config:
      auto.offset.reset: earliest
  producer:
    config:
      acks: all
```

**Apply:**

```bash
kubectl apply -f kafka-bridge.yaml -n kafka
```

---

## 6. Wait for Pods to be Ready

```bash
kubectl get pods -n kafka -w
```

Wait until all Strimzi, Kafka, Zookeeper, and Bridge pods are `Running`/`Ready`.

---

## 7. Port-forward KafkaBridge REST API

```bash
kubectl port-forward svc/my-bridge-bridge-service -n kafka 8080:8080
```

Test locally:

```bash
curl http://localhost:8080/topics
```

---

## 8. Destroy All Resources

```bash
terraform destroy -auto-approve
```

---

## Troubleshooting

* If you see exec plugin errors, regenerate your kubeconfig:

  ```bash
  aws eks --region us-east-1 update-kubeconfig --name kafka-cluster
  sed -i 's/client.authentication.k8s.io\\/v1alpha1/client.authentication.k8s.io\\/v1beta1/g' ~/.kube/config
  ```
* Make sure your AWS key pair exists and matches the `key_name` in `terraform.tfvars`.
* Use the latest versions of kubectl, AWS CLI, and Terraform for best results.

---

**Happy streaming!**

```

---

Let me know if you want this as a downloadable file or with extra examples (topic creation, producing/consuming data, etc)!
```
