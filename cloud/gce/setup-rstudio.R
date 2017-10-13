## Deploy shiny app
library(googleComputeEngineR)

## auto auth, project and zone pre-set
Sys.setenv("GCE_AUTH_FILE" = "/PATH/TO/SERVICE/TOKEN/auth.json")
gce_global_project('YOUR_PROJECT_ID')
gce_global_zone(zone = "YOUR_ZONE")

## auto auth, project and zone pre-set
gce_auth()


# Test it works : list your VMs in the project/zone
the_list <- gce_list_instances()

## Launch VM in GCE and configure it
# Launch
vm.rstudio <- gce_vm(template = "rstudio",
             name = "rstudio-production-vm",
             username = "YOUR_USERNAME",
             password = "YOUR_USERNAME",
             predefined_type = "n1-standard-1",
             open_webports = TRUE,
             )

vm.gce <- gce_vm(name = "rstudio-production-bare",
                 image_project = "debian-cloud",
                 image_family = "debian-9",
                 network = "default",
                # username = "YOUR_USERNAME",
                #   password = "YOUR_USERNAME",
                  predefined_type = "n1-standard-1",
                  open_webports = TRUE)

# Add SSH keys for administration
vm.rstudio <- gce_ssh_setup(vm.rstudio,
                        username = "YOUR_USERNAME",
                        key.pub = "/PATH/TO/.ssh/gcloud.pub",
                        key.private = "/PATH/TO/.ssh/gcloud")

vm.gce <- gce_ssh_setup(vm.gce,
                    username = "YOUR_USERNAME",
                    key.pub = "/PATH/TO/.ssh/gcloud.pub",
                    key.private = "/PATH/TO/.ssh/gcloud")


# Add users to RStudio VM
gce_rstudio_adduser(vm.rstudio, username = "YOUR_USERNAME", password = "YOUR_PASSWORD")
