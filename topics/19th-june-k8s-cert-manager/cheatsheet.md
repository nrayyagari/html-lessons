# Reference: Kubernetes cert-manager — Cheat Sheet

> Compressed essence. Print this; review before touching production certs.

## The three CRDs

| Resource      | Scope        | What it does                                  |
| ------------- | ------------ | --------------------------------------------- |
| `Issuer`      | namespaced   | how to sign certs in this namespace           |
| `ClusterIssuer` | cluster    | how to sign certs anywhere in the cluster     |
| `Certificate` | namespaced   | what cert you want; references an Issuer     |

The cert lands in a regular `Secret` named by `Certificate.spec.secretName`.
`Ingress.spec.tls[].secretName` points at that same Secret.

## Issuer types (the `spec.<x>` blocks)

- `acme` — public CAs via ACME (Let's Encrypt, ZeroSSL, …)
- `ca` — internal CA bundle
- `selfSigned` — good for bootstrapping, not for browsers
- `vault` — HashiCorp Vault PKI engine
- `venafi` — Venafi TPP / Venafi Cloud

## ACME challenge types

| Challenge | What proves control                 | Needs                       |
| --------- | ----------------------------------- | --------------------------- |
| `http01`  | serve a token on port 80            | inbound 80 reachable        |
| `dns01`   | create a TXT record on the domain   | DNS provider API access     |

Use `dns01` if the cluster isn't on the public internet or if you need
wildcard certs (`*.example.com` — only `dns01` works for those).

## The 4 debugging commands

```bash
kubectl describe certificate <name> -n <ns>     # what & why it failed
kubectl describe order <name>      -n <ns>     # ACME order state
kubectl describe challenge <name>  -n <ns>     # which challenge is stuck
kubectl describe ingress <name>    -n <ns>     # ingress-shim view + events
```

Look at the `Events:` block at the bottom of each. They tell you exactly
what step failed and why.

## Minimal end-to-end

```yaml
# 1. ClusterIssuer
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata: { name: letsencrypt-prod }
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ops@example.com
    privateKeySecretRef: { name: letsencrypt-prod-account }
    solvers:
      - http01: { ingress: { class: nginx } }

---
# 2. Ingress — the annotation creates the Certificate for you
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api
  annotations: { cert-manager.io/cluster-issuer: letsencrypt-prod }
spec:
  ingressClassName: nginx
  tls:
    - hosts: [api.example.com]
      secretName: api-example-com-tls
  rules:
    - host: api.example.com
      http: { paths: [ { path: /, pathType: Prefix,
          backend: { service: { name: api, port: { number: 8080 } } } } ] }
```

## Gotchas

- **Rate limits**: Let's Encrypt caps at 50 certs / registered domain /
  week. Use `acme-staging-v02.api.letsencrypt.org/directory` for testing.
- **HTTP-01 needs port 80**: firewalled → switch to DNS-01.
- **Wildcards need DNS-01**: HTTP-01 can only prove the exact hostname.
- **Private CA ≠ ACME**: use the `ca` or `vault` issuer kinds instead.
- **Don't `kubectl delete secret` the issuer's account key** — the
  controller will lose its ACME registration and you'll start over.
