
#############
# Namespace #
#############

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"

    labels = {
      "component" = "flux-system"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"                = "Flux-system"
      "cloud-platform.justice.gov.uk/business-unit"              = "Platforms"
      "cloud-platform.justice.gov.uk/owner"                      = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"                = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "cloud-platform-out-of-hours-alert"                        = "true"
    }
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}


resource "helm_release" "flux2" {
  name       = "flux2"
  namespace   = kubernetes_namespace.flux_system.metadata[0].name
  repository = "https://fluxcd-community.github.io/helm-charts"
  chart      = "flux2"
  version    = "2.9.2"
   values = ["${file("${path.module}/templates/values.yaml.tpl")}"]

  depends_on = [kubernetes_namespace.flux_system]
}