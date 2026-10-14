# OpenShift Demo — Runbook

## Before you start — set these once

```bash
export REGISTRY="default-route-openshift-image-registry.apps.ocp.ks75b.sandbox3353.opentlc.com"
export NS="workshop-demo"
export BASE="https://gateway-workshop-demo.apps.ocp.ks75b.sandbox3353.opentlc.com"
```

---

## STEP 1 — Run one service locally with Python

> "This is just Python. Any developer can run this on their laptop."

```bash
uvicorn products-service.main:app --port 8002 --reload
```

Test it:
```bash
curl http://localhost:8002/health
curl http://localhost:8002/products
curl -X POST http://localhost:8002/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Widget","description":"A demo product","price":9.99}'
curl http://localhost:8002/products
```

Or open: http://localhost:8002/docs

> "One service, running locally. But we have 5 services — and this is only reachable on my machine."

Stop it: `Ctrl+C`

---

## STEP 2 — Run the full stack in containers

> "Now let's run everything together in containers — the way it would actually be deployed."

```bash
podman compose up --build -d
```

Seed some data:
```bash
bash scripts/seed.sh http://localhost:8000
```

Test it:
```bash
curl http://localhost:8000/health
curl http://localhost:8000/users
curl http://localhost:8000/products
curl http://localhost:8000/orders
```

Or open: http://localhost:8000/docs

> "All 5 services running, talking to each other, through one URL. Still only on my machine though."

Stop it and wipe the data volumes so you start clean next time:
```bash
podman compose down
podman volume prune -f
```

---

## STEP 3 — Deploy to OpenShift

> "Same containers — now let's put them on OpenShift so anyone can reach them."

### Log in

```bash
oc login https://api.ocp.ks75b.sandbox3353.opentlc.com:6443 -u admin
oc project workshop-demo
podman login --tls-verify=false -u admin -p $(oc whoami -t) $REGISTRY
```

### Build and push the images

```bash
podman build --tls-verify=false -t $REGISTRY/$NS/users-service:latest    -f users-service/Dockerfile .
podman build --tls-verify=false -t $REGISTRY/$NS/products-service:latest  -f products-service/Dockerfile .
podman build --tls-verify=false -t $REGISTRY/$NS/inventory-service:latest -f inventory-service/Dockerfile .
podman build --tls-verify=false -t $REGISTRY/$NS/orders-service:latest    -f orders-service/Dockerfile .
podman build --tls-verify=false -t $REGISTRY/$NS/gateway:latest           -f gateway/Dockerfile .

podman push --tls-verify=false $REGISTRY/$NS/users-service:latest
podman push --tls-verify=false $REGISTRY/$NS/products-service:latest
podman push --tls-verify=false $REGISTRY/$NS/inventory-service:latest
podman push --tls-verify=false $REGISTRY/$NS/orders-service:latest
podman push --tls-verify=false $REGISTRY/$NS/gateway:latest
```

### Deploy

```bash
oc apply -f k8s/
oc get pods
```

Wait until all pods show `Running`.

### Seed data and test

```bash
bash scripts/seed.sh
curl -sk $BASE/products
```

Or open: https://gateway-workshop-demo.apps.ocp.ks75b.sandbox3353.opentlc.com/docs

> "Same app. Public HTTPS URL. Health checks, auto-restart, and anyone on the internet can reach it."

---

## BONUS — Make a change and update live

Edit `products-service/main.py` — find `list_products` and change the return:

```python
# Before
return [row_to_dict(r) for r in rows]

# After
return [{"_version": "2.0", **row_to_dict(r)} for r in rows]
```

Then redeploy just that one service:

```bash
podman build --tls-verify=false -t $REGISTRY/$NS/products-service:latest -f products-service/Dockerfile .
podman push --tls-verify=false $REGISTRY/$NS/products-service:latest
oc rollout restart deployment/products-service
oc rollout status deployment/products-service
curl -sk $BASE/products
```

> "Zero downtime update. OpenShift kept the old pod running until the new one was ready."

---

## Useful commands

```bash
oc get pods                                    # see all pods
oc logs -f deployment/products-service         # stream logs
oc scale deployment/products-service --replicas=3   # scale up
oc scale deployment/products-service --replicas=1   # scale back
oc delete -f k8s/                             # tear everything down
```

## Reset (start fresh)

Local db files (created by uvicorn in Step 1):
```bash
find . -name "*.db" -delete
```

Compose volumes:
```bash
podman compose down
podman volume prune -f
```

OpenShift:
```bash
oc delete -f k8s/ --ignore-not-found
oc apply -f k8s/
bash scripts/seed.sh
```
