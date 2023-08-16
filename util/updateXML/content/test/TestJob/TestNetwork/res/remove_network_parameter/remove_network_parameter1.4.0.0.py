def update(jobs):
    networks = jobs.get_networks()
    for network in networks:
        network.parset.remove_param_or_ref("load_isControllable")
