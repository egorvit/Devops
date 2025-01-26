## ArgoCD Applications per EKS Cluster

Name of the folder represent name of the EKS Cluster (Except HelmCharts).

```
HelmCharts             # Все Helm Charts
├── ChartTest1
│   ├── Chart.yaml
│   ├── templates
│   └── values
│       ├── values_dev.yaml    # DEV Values
│       ├── values_prod.yaml   # PROD Values
│       └── values.yaml        # Default Values
└── ChartTest2
    ├── Chart.yaml
    ├── templates
    └── values
        ├── values_dev.yaml    # DEV Values
        ├── values_prod.yaml   # PROD Values
        └── values.yaml        # Default Values

demo-dev                   # Имя EKS кластера
├── applications
│   ├── apache.yaml
│   └── nginx.yaml
└── root.yaml              # Корневое приложение ArgoCD

demo-prod                  # Имя EKS кластера
├── applications
│   ├── apache.yaml
│   └── nginx.yaml
└── root.yaml              # Корневое приложение ArgoCD       
```
