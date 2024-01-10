# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.


def ticket(ticket_number):
    """
    Decorator to assign a ticket number to update() function

    Parameter:
        ticket_number (int): ticket number
    """
    def decorator(func):
        def update_function(jobs):
            return func(jobs)
        update_function.ticket_number = str(ticket_number)
        return update_function
    return decorator
