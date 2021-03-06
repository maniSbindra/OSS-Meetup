# Setup Elastic search using helm chart
# helm install --name esearch4 incubator/elasticsearch --namespace kube-system --set client.replicas=1 --set master.replicas=2 --set data.replicas=1 --set data.persistence.enabled=false

helm install --name esearch5 incubator/elasticsearch --namespace kube-system --set client.replicas=1 --set master.replicas=2 --set data.replicas=1 --set data.persistence.enabled=false

# Install fluentd daemonset
kubectl apply -f fluentd-ds.yaml


# Install Kibana
 kl apply -f kibana.yaml




# install VAMP
curl -s \
  https://raw.githubusercontent.com/magneticio/vamp.io/master/static/res/v0.9.5/vamp_kube_quickstart.sh \
  | bash

# uninstall VAMP
curl -s \
  https://raw.githubusercontent.com/magneticio/vamp.io/master/static/res/v0.9.5/vamp_kube_uninstall.sh \
  | bash


# export VAMP Host
export VAMP_HOST=http://****:8080

# crete vamp blueprints
vamp create blueprint -f visage-vmp-1089.yaml


# deploy blueprint
vamp deploy visage:1089 visage

# merge deployment with typo fixed
vamp merge visage:1091 visage


# check % of traffic against deployments
vamp describe gateway visage/visage/webport

vamp update-gateway visage/visage/webport --weights visage/visage/visage:1089/webport@70%,visage/visage/visage:1091/webport@30%

vamp update-gateway visage/visage/webport --weights visage/visage/visage:1089/webport@50%,visage/visage/visage:1091/webport@50%