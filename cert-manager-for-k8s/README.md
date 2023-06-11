# Сert-manager with Intermediate Certificate

## Deploy cert-manager

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade --install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.11.2 --dry-run
```

## Deploy manifests

```bash
kubectl apply -n nginx-ssl -f deployment.yaml
kubectl apply -n nginx-ssl -f svc.yaml
kubectl apply -n nginx-ssl -f ingress.yaml
kubectl apply -n cert-manager -f root-secret.yaml
kubectl apply -n cert-manager -f cluster-issuer.yaml
```

## Documentation
```bash
https://cert-manager.io/docs/installation/helm/
```

# Certs

## Init

```bash
export CERTS_FOLDER=/Certs
sudo apt install easy-rsa
mkdir $CERTS_FOLDER/easy-rsa
ln -s /usr/share/easy-rsa/* $CERTS_FOLDER/easy-rsa
chmod 700 $CERTS_FOLDER/easy-rsa
cd $CERTS_FOLDER/easy-rsa
# Initializing a pki directory
./easyrsa init-pki
# Creating a configuration file
nano easy-rsa/pki/vars
# Issuing a Root Certificate
./easyrsa build-ca
```

## Issuing an Intermediate Root Certificate

```bash
./easyrsa gen-req ca_intermediate_k8s01 nopass
./easyrsa sign-req ca ca_intermediate_k8s01
# Archiving
cd ../
tar -cv \
  'easy-rsa/pki/issued/ca_intermediate_k8s01.crt' \
  'easy-rsa/pki/private/ca_intermediate_k8s01.key' \
  'easy-rsa/pki/ca.crt' \
  | gzip > ca_intermediate_k8s01.tar.gz
```

## Certs in base64 for secret

```bash
cat ca.crt | base64 -w 0
cat ca_intermediate_k8s01.crt | base64 -w 0
cat ca_intermediate_k8s01.key | base64 -w 0
```
