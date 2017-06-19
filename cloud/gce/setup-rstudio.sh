## Deploy shiny app
library(googleComputeEngineR)

## auto auth, project and zone pre-set
Sys.setenv("GCE_AUTH_FILE" = "/home/manos/Downloads/auth.json")
gce_global_project('custom-manifest-113615')
gce_global_zone(zone = "europe-west1-c")

## auto auth, project and zone pre-set
gce_auth()


# Test it works : list your VMs in the project/zone
the_list <- gce_list_instances()

## Launch VM in GCE and configure it
# Launch
vm.rstudio <- gce_vm(template = "rstudio",
             name = "rstudio-production-vm",
             username = "rstudio",
             password = "efood_bi",
             predefined_type = "n1-standard-1",
             open_webports = TRUE,
             )

vm.gce <- gce_vm(name = "rstudio-production-bare",
                 image_project = "debian-cloud",
                 image_family = "debian-9",
                 network = "default",
                # username = "rstudio",
                #   password = "efood_bi",
                  predefined_type = "n1-standard-1",
                  open_webports = TRUE)

# Add SSH keys for administration
vm.rstudio <- gce_ssh_setup(vm.rstudio,
                        username = "manosp",
                        key.pub = "/home/manos/.ssh/gcloud.pub",
                        key.private = "/home/manos/.ssh/gcloud")

vm.gce <- gce_ssh_setup(vm.gce,
                    username = "manosp",
                    key.pub = "/home/manos/.ssh/gcloud.pub",
                    key.private = "/home/manos/.ssh/gcloud")


# Add users to RStudio VM
gce_rstudio_adduser(vm.rstudio, username = "manosp", password = "m@nosp")
gce_rstudio_adduser(vm.rstudio, username = "thomas", password = "thom@s")
gce_rstudio_adduser(vm.rstudio, username = "dion", password = "di0n")
gce_rstudio_adduser(vm.rstudio, username = "george", password = "ge0rg3")
gce_rstudio_adduser(vm.rstudio, username = "alex", password = "al3x")


