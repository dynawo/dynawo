def update(jobs):
    networks = jobs.get_networks()
    for network in networks:
        network.parset.add_param("DOUBLE", "my_param", 42)
