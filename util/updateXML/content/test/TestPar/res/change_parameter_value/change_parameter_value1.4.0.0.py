def update(jobs):
    loads = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadAlphaBeta")
    for load in loads:
        load.parset.change_param_value("load_name", "myLoad_NAME_CHANGED")
        load.parset.change_param_value("load_isControllable", False)
        load.parset.change_param_value("load_alpha", 42)
        load.parset.change_param_value("load_beta", 555)
        load.parset.change_param_value("load_gamma", 777)
