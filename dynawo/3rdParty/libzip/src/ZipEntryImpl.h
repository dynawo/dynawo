//
// Copyright (c) 2013-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libzip, a library to handle zip archives.
//

#ifndef __ZIP_ENTRY_IMPL_H__
#define __ZIP_ENTRY_IMPL_H__

#include <libzip/ZipEntry.h>

namespace zip {

class ZipEntry::Impl : public ZipEntry {
public:
    Impl(const std::string& filename);

    Impl(const std::string& name, const std::string& data);

    Impl(struct archive_entry* info, const std::string& data);

    virtual ~Impl();

    virtual struct archive_entry* getInfo() const;

    virtual const std::string& getData() const;

private:
    struct archive_entry* m_info;

    std::string m_data;

};

}

#endif /* __ZIP_ENTRY_IMPL_H__ */
