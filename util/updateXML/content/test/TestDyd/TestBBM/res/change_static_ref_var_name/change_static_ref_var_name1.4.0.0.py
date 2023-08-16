def update(jobs):
    loads = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadAlphaBeta")
    for load in loads:
        load.static_refs.change_var_name("load_PPu", "load_PPu_NAME_CHANGED")
        load.static_refs.change_var_name("load_QPu", "load_QPu_NAME_CHANGED")
