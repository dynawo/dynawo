def update(jobs):
    loads = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "_LOAD___3_EC")
    for load in loads:
        load.macro_static_refs.remove_macro_static_ref("LOAD")
