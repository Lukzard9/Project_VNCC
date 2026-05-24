# Progetto Terraform & Kubernetes (Kind)

Questo repository contiene una serie di esempi per l'apprendimento e l'implementazione di infrastrutture con **Terraform**. Molte delle configurazioni si concentrano sulla creazione e test di cluster Kubernetes locali utilizzando **Kind** (Kubernetes in Docker).

## Struttura del Progetto

Il progetto è strutturato in una progressione logica, composta da 4 sezioni principali:

- **`1_first_cluster/`**  
  Configurazione base per effettuare il deploy del primissimo cluster. Introduce i file fondamentali di Terraform come `main.tf`, `providers.tf` e `network.tf`.

- **`2_parameters_and_modules/`**  
  Introduzione all'utilizzo di variabili (`variables.tf`) e alla modularizzazione del codice Terraform. Include un modulo pre-impostato per una semplice applicazione (`modules/web-app/`).

- **`3_randomness_certificate/`**  
  Gestione di risorse più avanzate come generazione di dati casuali o configurazione di certificati. Mostra nello specifico come allocare un cluster su Kind usando il provider adeguato (`kind_cluster.tf`).

- **`4_complete_pipeline/`**  
  L'ultimo step combina tutto in una configurazione più complessa. Integra risorse aggiuntive come Job (`job.tf`) per un'implementazione di tipo end-to-end.

## Prerequisiti

Per eseguire i manifesti in locale, è necessario aver installato i seguenti strumenti:
* [Terraform](https://www.terraform.io/downloads)
* [Docker](https://docs.docker.com/get-docker/)
* [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)

## Utilizzo

Per deployare l'infrastruttura di ciascun modulo, naviga nella specifica cartella ed esegui i comandi base di Terraform:

```bash
# Entra nella cartella desiderata
cd 1_first_cluster

# Inizializza il progetto (scarica i provider)
terraform init

# Visualizza i cambiamenti che verranno applicati
terraform plan

# Applica la configurazione
terraform apply
```

*(Ricorda sempre di lanciare `terraform destroy` quando hai finito per liberare le risorse)*