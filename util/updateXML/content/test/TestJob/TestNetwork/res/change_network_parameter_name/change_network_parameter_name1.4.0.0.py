def update(jobs):
    networks = jobs.get_networks()
    for network in networks:
        network.parset.change_param_or_ref_name("load_isControllable", "load_isControllable_NAME_CHANGED")
