# Cheat sheet — Azure RG vs GCP projects

> Compressed essence. Print this; review before designing a layout.

## The four problems, mapped

| Problem | Azure | GCP |
| --- | --- | --- |
| Billing boundary | Resource Group (cost analyzer scoped) | Project (billing export per project) |
| Access / least-privilege | Resource Group (RBAC scope) | Project (IAM binding scope) |
| Lifecycle (delete all) | Resource Group | Project |
| Policy / governance | Resource Group (Azure Policy) | Project (Org Policy) |

The <em>smallest</em> unit is the same on both sides: one Azure
Resource Group ≈ one GCP Project.

## The structural difference

- **Azure:** flat. RGs are peers inside a subscription. Hierarchy
  is layered on top via Management Groups (separate, optional).
- **GCP:** nested. Projects are leaves of a tree: Org → Folder(s) →
  Project. Folders are optional organizational sugar.

## Identity

- **Azure Managed Identity** ≈ **GCP Service Account**. Both
  are workload identities; both can federate with external
  providers (Workload Identity Federation, OIDC).
- **Azure RBAC role assignment** is a separate resource attached
  to a scope. **GCP IAM binding** is part of the resource's policy.
- Both clouds are **additive**: the user gets the union of all
  bindings from the root of the hierarchy down.

## Naming & tagging

- **Azure RG name:** `<app>-<env>-<region>-rg` (region in the name
  because the RG is the unit of deletion across regions).
- **GCP project ID:** `<app>-<env>` (region lives at the resource,
  not the project).
- **Tags (Azure) / Labels (GCP):** the same shape. The four that
  matter: `environment`, `team` / `owner`, `cost-center`,
  `data-class` / `compliance`, `ttl` (for sandboxes).

## Policy

- **Azure Policy** = Deny / Audit / Append effects. Initiatives
  group related policies. Scopes: MG, subscription, RG.
- **GCP Org Policy** = `deny` / `allow` constraints. Scopes: org,
  folder, project.

## Service identity without keys

| Goal | Azure | GCP |
| --- | --- | --- |
| Get an OAuth token for code | Managed Identity + IMDS | Service Account + metadata server |
| Federate with GitHub Actions / k8s | Workload Identity for AKS | Workload Identity Federation (OIDC) |
| Federate across clouds | AAD app registration + federated credential | WIF trust with Azure AD as IdP |

The era of "download a JSON key file" is over. Don't do it.

## Migration (Azure ↔ GCP)

1. Map the topology, not the resources. RGs ↔ Projects, MGs ↔ Folders.
2. Build the new hierarchy first; validate IAM and cost reports.
3. Migrate per-group, lowest-risk first, with rollback.
4. Identity federation is a separate project. Do it after workloads
   are stable.
