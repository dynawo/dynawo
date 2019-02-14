
#ifndef MACHINE_PQ_h
#define MACHINE_PQ_h
#include "DYNModelManager.h"
#include "DYNSubModelFactory.h"

namespace DYN {

  class ModelMACHINE_PQFactory : public SubModelFactory
  {
    public:
    ModelMACHINE_PQFactory() {}
    ~ModelMACHINE_PQFactory() {}

    SubModel * create() const;
  };

  class ModelMACHINE_PQ : public ModelManager
  {
    public:
    ModelMACHINE_PQ();
    ~ModelMACHINE_PQ();

    bool hasInit() const { return true; }
  };
}

#endif

