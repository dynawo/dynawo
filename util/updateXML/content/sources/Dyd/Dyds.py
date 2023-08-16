class Dyds:
    """
    Collection of Dyd files

    Attribute
    ----------
    _dyds_collection : list[DydData]
        collection of Dyd files
    """
    def __init__(self):
        self._dyds_collection = dict()

    def get_bbms(self, func):
        selected_bbms = list()
        for dyd in self._dyds_collection.values():
            bbms = dyd._get_bbms(func)
            selected_bbms.extend(bbms)
        return selected_bbms

    def get_modelica_models(self, func):
        selected_modelica_models = list()
        for dyd in self._dyds_collection.values():
            modelica_models = dyd._get_modelica_models(func)
            selected_modelica_models.extend(modelica_models)
        return selected_modelica_models

    def get_model_templates(self, func):
        selected_model_templates = list()
        for dyd in self._dyds_collection.values():
            model_templates = dyd._get_model_templates(func)
            selected_model_templates.extend(model_templates)
        return selected_model_templates

    def get_model_template_expansions(self, func):
        selected_model_template_expansions = list()
        for dyd in self._dyds_collection.values():
            model_template_expansions = dyd._get_model_template_expansions(func)
            selected_model_template_expansions.extend(model_template_expansions)
        return selected_model_template_expansions

    def remove_macro_connector(self, id):
        for dyd in self._dyds_collection.values():
            dyd._remove_macro_connector(id)

    def remove_macro_static_reference(self, id):
        for dyd in self._dyds_collection.values():
            dyd._remove_macro_static_reference(id)
