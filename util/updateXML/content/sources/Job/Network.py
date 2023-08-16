from ..utils.Common import *
from ..Par.Parset import Parset
from .Curves import Curves
from .FinalStateValues import FinalStateValues


class Network:
    """
    Represents the network model

    Attribute
    ----------
    parset : Parset
        parset related to the network
    curves : Curves
        curves data of the jobs
    final_state_values : FinalStateValues
        final state values data of the job
    """
    def __init__(self, parset, curves_collection, final_state_values_collection):
        self.parset = Parset(parset)
        self.curves = Curves(curves_collection, NETWORK_ID)
        self.final_state_values = FinalStateValues(final_state_values_collection, NETWORK_ID)
