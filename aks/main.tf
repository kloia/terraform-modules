resource "azurerm_kubernetes_cluster" "k8s" {
    name                = "${var.aks["cluster_name"]}"
    location            = "${var.global["location"]}"
    resource_group_name = "${var.aks_resource_group}"
    dns_prefix          = "${var.aks["dns_prefix"]}"

    linux_profile {
        admin_username = "${var.aks["admin_user_name"]}"

        ssh_key {
            key_data = "${file("${var.aks["public_key_path"]}")}"
        }
    }


    agent_pool_profile {
        
        name            = "${var.aks["pool_name"]}"
        count           = "${var.aks["agent_count"]}"
        vm_size         = "${var.aks["vm_size"]}"
        os_type         = "${var.aks["os"]}"
        os_disk_size_gb = "${var.aks["disk_size"]}"
        ## subnet tests
        vnet_subnet_id = "${var.aks["subnet_id"]}"

    }

    service_principal {
        client_id     = "${var.client_id}"
        client_secret = "${var.client_secret}"
    }


    tags {
        Environment = "${var.aks["tag_env"]}"
    }
}