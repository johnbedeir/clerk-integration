##############################################################
# MONITORING STACK
# Make sure to update YOUR_DOMAIN to match the build.sh script
##############################################################
variable "kube_monitoring_stack_values" {
  type    = string
  default = <<-EOF
    grafana:
      adminUser: admin
      adminPassword: admin
      enabled: true
      service:
        type: ClusterIP
      ingress:
        enabled: true
        ingressClassName: nginx
        annotations:
          cert-manager.io/cluster-issuer: letsencrypt-production
        hosts:
          - grafana.johnydev.com
        tls:
          - secretName: grafana-tls
            hosts:
              - grafana.johnydev.com

    alertmanager:
      enabled: true
      service:
        type: ClusterIP
      ingress:
        enabled: true
        ingressClassName: nginx
        annotations:
          cert-manager.io/cluster-issuer: letsencrypt-production
        hosts:
          - alertmanager.johnydev.com
        tls:
          - secretName: alertmanager-tls
            hosts:
              - alertmanager.johnydev.com

    prometheus:
      ingress:
        enabled: true
        ingressClassName: nginx
        annotations:
          cert-manager.io/cluster-issuer: letsencrypt-production
        hosts:
          - prometheus.johnydev.com
        tls:
          - secretName: prometheus-tls
            hosts:
              - prometheus.johnydev.com
      service:
        type: ClusterIP
      prometheusSpec:
        replicas: 2
        replicaExternalLabelName: prometheus_replica
        prometheusExternalLabelName: prometheus_cluster
        enableAdminAPI: false
        logFormat: logfmt
        logLevel: info
        retention: 120h
        serviceMonitorSelectorNilUsesHelmValues: false
        serviceMonitorNamespaceSelector: {}
        serviceMonitorSelector: {}
        resources:
          limits:
            memory: 1Gi
          requests:
            cpu: 250m
            memory: 512Mi

    prometheus-node-exporter:
      resources:
        limits:
          memory: 20Mi
        requests:
          cpu: 10m
          memory: 20Mi

    kube-state-metrics:
      resources:
        limits:
          memory: 200Mi
        requests:
          cpu: 10m
          memory: 100Mi

    prometheusOperator:
      resources:
        limits:
          memory: 300Mi
        requests:
          cpu: 10m
          memory: 200Mi
    EOF
}

resource "helm_release" "kube_monitoring_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  version    = "67.2.0"

  create_namespace = true

  values = [var.kube_monitoring_stack_values]
}
