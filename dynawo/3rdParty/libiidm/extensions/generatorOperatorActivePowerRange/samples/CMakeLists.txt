# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

if( BUILD_XML )
  add_executable(GeneratorOperatorActivePowerRange1 GeneratorOperatorActivePowerRange1.cpp )
  target_link_libraries(GeneratorOperatorActivePowerRange1
    iidm-ext-generatoroperatoractivepowerrange-xml-testing
  )

  add_executable(GeneratorOperatorActivePowerRange_cat GeneratorOperatorActivePowerRange_cat.cpp )
  target_link_libraries(GeneratorOperatorActivePowerRange_cat
    iidm-ext-generatoroperatoractivepowerrange-xml-testing
  )
endif()
